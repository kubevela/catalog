package controllers

import (
	"context"
	"encoding/json"
	"fmt"

	cpv1alpha1 "github.com/crossplane/crossplane-runtime/apis/core/v1alpha1"
	"github.com/crossplane/oam-kubernetes-runtime/pkg/oam"
	appsv1 "k8s.io/api/apps/v1"
	autoscalingv1 "k8s.io/api/autoscaling/v1"
	apierrors "k8s.io/apimachinery/pkg/api/errors"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/types"
	ctrl "sigs.k8s.io/controller-runtime"

	"github.com/crossplane/oam-controllers/pkg/oam/util"
	"github.com/crossplane/oam-kubernetes-runtime/apis/core/v1alpha2"
	"github.com/go-logr/logr"
	"github.com/pkg/errors"
	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"
	"sigs.k8s.io/controller-runtime/pkg/client"

	coreoamdevv1alpha2 "github.com/oam-dev/catalog/traits/hpatrait/api/v1alpha2"
)

var (
	oamAPIVersion  = v1alpha2.SchemeGroupVersion.String()
	appsAPIVersion = appsv1.SchemeGroupVersion.String()

	GroupVersionHPA = autoscalingv1.SchemeGroupVersion.String()
)

const (
	KindHPA         = "HorizontalPodAutoscaler"
	KindDeployment  = "Deployment"
	KindStatefulSet = "StatefulSet"

	GVKDeployment  = "apps/v1, Kind=Deployment"
	GVKStatefulSet = "apps/v1, Kind=StatefulSet"

	LabelKey = "hpatrait.oam.crossplane.io"
)

const (
	errMissContainerResources = "missing container resources config"
)

func (r *HorizontalPodAutoscalerTraitReconciler) renderHPA(ctx context.Context, trait oam.Trait, resources []*unstructured.Unstructured) ([]*autoscalingv1.HorizontalPodAutoscaler, error) {
	t, ok := trait.(*coreoamdevv1alpha2.HorizontalPodAutoscalerTrait)
	if !ok {
		return nil, errors.New("not a hpa trait")
	}
	hpas := make([]*autoscalingv1.HorizontalPodAutoscaler, 0)

	for _, res := range resources {
		// currently support appsv1/Deployment, appsv1/StatefulSet
		// TODO any resouces with Scale endpoint should be accepted

		//render autoscalingv1.CrossVersionObjectReference basing unstructured resource
		scaleTargetRef, isValidResource, err := renderReference(res)
		if err != nil {
			return nil, err
		}
		if !isValidResource {
			continue
		}
		// construct autoscalingv1/HPA obj
		hpa := &autoscalingv1.HorizontalPodAutoscaler{
			TypeMeta: metav1.TypeMeta{
				Kind:       KindHPA,
				APIVersion: GroupVersionHPA,
			},
			ObjectMeta: metav1.ObjectMeta{
				Name:      t.GetName(), // use trait name as hpa name
				Namespace: t.GetNamespace(),
				Labels: map[string]string{
					LabelKey: string(t.GetUID()),
				},
			},
			Spec: autoscalingv1.HorizontalPodAutoscalerSpec{
				ScaleTargetRef:                 scaleTargetRef,
				MinReplicas:                    t.Spec.MinReplicas,
				MaxReplicas:                    t.Spec.MaxReplicas,
				TargetCPUUtilizationPercentage: t.Spec.TargetCPUUtilizationPercentage,
			},
		}
		if err := ctrl.SetControllerReference(trait, hpa, r.Scheme); err != nil {
			return nil, err
		}
		hpas = append(hpas, hpa)
	}
	return hpas, nil
}

func (r *HorizontalPodAutoscalerTraitReconciler) fetchWorkload(ctx context.Context, log logr.Logger,
	oamTrait oam.Trait) (*unstructured.Unstructured, ctrl.Result, error) {
	var workload unstructured.Unstructured
	workload.SetAPIVersion(oamTrait.GetWorkloadReference().APIVersion)
	workload.SetKind(oamTrait.GetWorkloadReference().Kind)

	wn := client.ObjectKey{Name: oamTrait.GetWorkloadReference().Name, Namespace: oamTrait.GetNamespace()}

	if err := r.Get(ctx, wn, &workload); err != nil {
		log.Error(err, "Workload not find", "kind", oamTrait.GetWorkloadReference().Kind,
			"workload name", oamTrait.GetWorkloadReference().Name)
		return nil, util.ReconcileWaitResult,
			util.PatchCondition(ctx, r, oamTrait, cpv1alpha1.ReconcileError(errors.Wrap(err, errLocateWorkload)))
	}

	log.Info("Get the workload the trait is pointing to", "workload name", oamTrait.GetWorkloadReference().Name,
		"workload APIVersion", workload.GetAPIVersion(), "workload Kind", workload.GetKind(), "workload UID",
		workload.GetUID())

	return &workload, ctrl.Result{}, nil
}

func (r *HorizontalPodAutoscalerTraitReconciler) cleanUpLegacyHPAs(ctx context.Context, hpatrait *coreoamdevv1alpha2.HorizontalPodAutoscalerTrait, hpaUIDs []types.UID) error {
	log := r.Log.WithValues("gc HPA", hpatrait.Name)

	var hpa autoscalingv1.HorizontalPodAutoscaler

	for _, res := range hpatrait.Status.Resources {
		if res.Kind == "HorizontalPodAutoscaler" && res.APIVersion == autoscalingv1.SchemeGroupVersion.String() {
			isLegacy := true
			for _, i := range hpaUIDs {
				if i == res.UID {
					isLegacy = false
					break
				}
			}
			if isLegacy {
				log.Info("Find a legacy HPA", "HPA UID", res.UID)

				hn := client.ObjectKey{Name: res.Name, Namespace: hpatrait.Namespace}
				if err := r.Get(ctx, hn, &hpa); err != nil {
					if apierrors.IsNotFound(err) {
						log.Info("Failed to get the legacy HPA", "err", err)
						continue
					}
					return err
				}
				if err := r.Delete(ctx, &hpa); err != nil {
					return err
				}
				log.Info("Delete a legacy HPA", "HPA UID", res.UID)
			}
		}
	}
	return nil
}

// Determine whether the workload is K8S native resources or oam WorkloadDefinition
func DetermineWorkloadType(ctx context.Context, log logr.Logger, r client.Reader,
	workload *unstructured.Unstructured) ([]*unstructured.Unstructured, error) {
	apiVersion := workload.GetAPIVersion()
	switch apiVersion {
	case oamAPIVersion:
		// oam core workloads
		return util.FetchWorkloadDefinition(ctx, log, r, workload)
	case appsAPIVersion:
		// k8s native resources
		log.Info("workload is K8S native resources", "APIVersion", apiVersion)
		return []*unstructured.Unstructured{workload}, nil
	//TODO add support for openkruise workloads
	case "":
		return nil, errors.Errorf(fmt.Sprint("failed to get the workload APIVersion"))
	default:
		return nil, errors.Errorf(fmt.Sprint("This trait doesn't support this APIVersion", apiVersion))
	}
}

func renderReference(resource *unstructured.Unstructured) (r autoscalingv1.CrossVersionObjectReference, isValidResource bool, err error) {
	resGVK := resource.GetObjectKind().GroupVersionKind().String()
	isValidResource = false

	switch resGVK {
	case GVKDeployment:
		var deploy appsv1.Deployment
		bts, _ := json.Marshal(resource)
		if err := json.Unmarshal(bts, &deploy); err != nil {
			return r, isValidResource, errors.Wrap(err, "Failed to convert an unstructured obj to a appsv1.deployment")
		}

		// check spec.containers.resource
		// if missing, raise an error
		// for it's required by HPA
		containers := deploy.Spec.Template.Spec.Containers
		for _, container := range containers {
			if container.Resources.Requests == nil {
				return r, isValidResource, fmt.Errorf("cannot get container.resources.requests from deployment: %s", deploy.GetName())
			}
		}
		isValidResource = true
		r = autoscalingv1.CrossVersionObjectReference{
			Kind:       KindDeployment,
			Name:       deploy.GetName(),
			APIVersion: appsAPIVersion,
		}
	case GVKStatefulSet:
		var sts appsv1.Deployment
		bts, _ := json.Marshal(resource)
		if err := json.Unmarshal(bts, &sts); err != nil {
			return r, isValidResource, errors.Wrap(err, "Failed to convert an unstructured obj to a appsv1.statefulset")
		}

		// check spec.containers.resource
		// if missing, raise an error
		// for it's required by HPA
		containers := sts.Spec.Template.Spec.Containers
		for _, container := range containers {
			if container.Resources.Requests == nil {
				return r, isValidResource, fmt.Errorf("cannot get container.resources.requests from statefulset: %s", sts.GetName())
			}
		}
		isValidResource = true
		r = autoscalingv1.CrossVersionObjectReference{
			Kind:       KindDeployment,
			Name:       sts.GetName(),
			APIVersion: appsAPIVersion,
		}
	default:
		isValidResource = false
	}

	return r, isValidResource, nil
}
