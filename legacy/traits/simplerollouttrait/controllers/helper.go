package controllers

import (
	"context"
	"encoding/json"
	"fmt"

	cpv1alpha1 "github.com/crossplane/crossplane-runtime/apis/core/v1alpha1"
	"github.com/crossplane/oam-kubernetes-runtime/pkg/oam"
	appsv1 "k8s.io/api/apps/v1"
	ctrl "sigs.k8s.io/controller-runtime"

	runtimev1alpha1 "github.com/crossplane/crossplane-runtime/apis/core/v1alpha1"
	"github.com/crossplane/oam-controllers/pkg/oam/util"
	"github.com/crossplane/oam-kubernetes-runtime/apis/core/v1alpha2"
	"github.com/go-logr/logr"
	"github.com/pkg/errors"
	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"
	"sigs.k8s.io/controller-runtime/pkg/client"

	extendoamdevv1alpha2 "github.com/oam-dev/catalog/traits/simplerollouttrait/api/v1alpha2"
)

var (
	oamAPIVersion  = v1alpha2.SchemeGroupVersion.String()
	appsAPIVersion = appsv1.SchemeGroupVersion.String()
)

const (
	KindDeployment         = "Deployment"
	KindStatefulSet        = "StatefulSet"
	KindControllerRevision = "ControllerRevision"

	GVKDeployment  = "apps/v1, Kind=Deployment"
	GVKStatefulSet = "apps/v1, Kind=StatefulSet"
)

func (r *SimpleRolloutTraitReconciler) fetchWorkload(ctx context.Context, log logr.Logger,
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

// Determine whether the workload is K8S native resources or oam WorkloadDefinition
func DetermineWorkloadType(ctx context.Context, log logr.Logger, r client.Reader,
	workload *unstructured.Unstructured) ([]*unstructured.Unstructured, error) {
	apiVersion := workload.GetAPIVersion()
	switch apiVersion {
	case oamAPIVersion:
		// oam core workloads
		unsctrucs, err := util.FetchWorkloadDefinition(ctx, log, r, workload)
		if err != nil {
			return nil, err
		}
		return unsctrucs, nil
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

func isNewlyCreatedRolloutTrait(rt *extendoamdevv1alpha2.SimpleRolloutTrait) bool {
	if rt.Status.CurrentWorkloadReference == (runtimev1alpha1.TypedReference{}) {
		return true
	}
	return false
}

func isUnderRollout(rt *extendoamdevv1alpha2.SimpleRolloutTrait) bool {
	if rt.Status.CurrentWorkloadReference != rt.Spec.WorkloadReference {
		return true
	}
	return false
}

func isScaleUpReady(deployments []*appsv1.Deployment, targetReplicas int32) bool {
	//TODO if there's no deployment
	// does it mean something wrong with Workload controller?
	if len(deployments) == 0 {
		return false
	}
	for _, deploy := range deployments {
		if deploy.Status.ReadyReplicas != targetReplicas {
			return false
		}
	}
	return true
}

func isScaleDownReady(deployments []*appsv1.Deployment) bool {
	if len(deployments) == 0 {
		return false
	}
	for _, deploy := range deployments {
		if *(deploy.Spec.Replicas) != 0 || deploy.Status.ReadyReplicas != 0 {
			return false
		}
	}
	return true
}

func (r *SimpleRolloutTraitReconciler) scaleUpGradually(ctx context.Context, log logr.Logger, deployments []*appsv1.Deployment, targetReplica, batch int32) error {
	// check whether last round scale up is done
	for _, deployment := range deployments {
		if *(deployment.Spec.Replicas) == deployment.Status.ReadyReplicas {
			if *(deployment.Spec.Replicas) == targetReplica {
				log.Info("Scale up is ready")
				continue
			}
			if *(deployment.Spec.Replicas)+batch >= targetReplica {
				*(deployment.Spec.Replicas) = targetReplica
			} else {
				*(deployment.Spec.Replicas) += batch
			}
			// update deployment
			if err := r.Update(ctx, deployment); err != nil {
				log.Error(err, "Failed to upate deployment for scaling up")
				return err
			}
			log.Info("Successfully update deployment for scaling up", "deployment name", deployment.GetName())
			continue
		}
		continue
	}
	return nil
}

func (r *SimpleRolloutTraitReconciler) scaleDownGradually(ctx context.Context, log logr.Logger, deployments []*appsv1.Deployment, targetReplica, batch int32) error {
	for _, deployment := range deployments {
		if *(deployment.Spec.Replicas) == 0 {
			continue
		}
		// check whether last round scale down is done
		if *(deployment.Spec.Replicas) == deployment.Status.ReadyReplicas {
			if *(deployment.Spec.Replicas) == targetReplica {
				log.Info("Scale down is ready")
				continue
			}
			if *(deployment.Spec.Replicas)-batch <= targetReplica {
				*(deployment.Spec.Replicas) = targetReplica
			} else {
				*(deployment.Spec.Replicas) -= batch
			}
			// update deployment
			if err := r.Update(ctx, deployment); err != nil {
				log.Error(err, "Failed to upate deployment for scaling down")
				return err
			}
			log.Info("Successfully update deployment for scaling down", "deployment name", deployment.GetName())
			continue
		}
		continue
	}
	return nil
}

func (r *SimpleRolloutTraitReconciler) getUnderlyingDeployment(ctx context.Context, log logr.Logger, workload *unstructured.Unstructured) ([]*appsv1.Deployment, error) {

	resources, err := DetermineWorkloadType(ctx, log, r, workload)
	if err != nil {
		log.Error(err, "Cannot find the workload's child resources", "workload", workload.UnstructuredContent())
		return nil, err
	}
	log.Info("Get underlying resources", "native resources: ", len(resources))

	deployments := make([]*appsv1.Deployment, 0)
	for _, res := range resources {
		resGVK := res.GetObjectKind().GroupVersionKind().String()
		//TODO currently only support for deployment
		if resGVK != GVKDeployment {
			continue
		}
		var deployment appsv1.Deployment
		bts, _ := json.Marshal(res)
		if err := json.Unmarshal(bts, &deployment); err != nil {
			return nil, err
		}
		deployments = append(deployments, &deployment)
	}
	return deployments, nil
}

func (r *SimpleRolloutTraitReconciler) getControllerRevision(ctx context.Context, log logr.Logger, rolloutTrait *extendoamdevv1alpha2.SimpleRolloutTrait) (*appsv1.ControllerRevision, error) {
	var cr appsv1.ControllerRevision
	// rolloutTrait.spec.workloadRef.name equals to controllerrevision name
	wn := client.ObjectKey{Name: rolloutTrait.GetWorkloadReference().Name, Namespace: rolloutTrait.GetNamespace()}

	if err := r.Get(ctx, wn, &cr); err != nil {
		log.Error(err, "ControllerRevision not find", "kind", rolloutTrait.GetWorkloadReference().Kind,
			"ControllerRevision name", rolloutTrait.GetWorkloadReference().Name)
		return nil, err
	}
	return &cr, nil
}
