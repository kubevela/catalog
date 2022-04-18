/*


Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package controllers

import (
	"context"
	"fmt"
	"reflect"
	"strings"

	cpv1alpha1 "github.com/crossplane/crossplane-runtime/apis/core/v1alpha1"
	"github.com/crossplane/oam-kubernetes-runtime/pkg/oam/util"
	"github.com/go-logr/logr"

	kedav1alpha1 "github.com/kedacore/keda/pkg/apis/keda/v1alpha1"

	extendv1alpha2 "github.com/oam-dev/catalog/traits/metrichpatrait/api/v1alpha2"
	"github.com/pkg/errors"
	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/runtime"
	ctrl "sigs.k8s.io/controller-runtime"
	"sigs.k8s.io/controller-runtime/pkg/client"
)

const (
	errLocateResources   = "cannot find resources"
	errCreatConfigMap    = "cannot create configmap"
	errCreatePromeSvc    = "cannot create service for Prometheus"
	errCreatePromeDeploy = "cannot create deployment for Prometheus"
	errCreatScaledObject = "cannot create KEDA ScaledObject"
	errGarbageCollection = "garbage collect failed"
	LabelKey             = "extend.oam.dev/metrichpatrait"
)

// MetricHPATraitReconciler reconciles a MetricHPATrait object
type MetricHPATraitReconciler struct {
	client.Client
	Log    logr.Logger
	Scheme *runtime.Scheme
}

// +kubebuilder:rbac:groups=keda.k8s.io,resources=scaledobjects,verbs=get;list;watch;create;update;patch;delete
// +kubebuilder:rbac:groups=core.oam.dev,resources=containerizedworkloads,verbs=get;list;
// +kubebuilder:rbac:groups=core.oam.dev,resources=containerizedworkloads/status,verbs=get;
// +kubebuilder:rbac:groups=core.oam.dev,resources=workloaddefinitions,verbs=get;list;watch
// +kubebuilder:rbac:groups=apps,resources=deployments,verbs=get;list;watch;update;patch;delete
// +kubebuilder:rbac:groups=core,resources=services,verbs=get;list;watch;create;update;patch;delete
// +kubebuilder:rbac:groups=extend.oam.dev,resources=metrichpatraits,verbs=get;list;watch;create;update;patch;delete
// +kubebuilder:rbac:groups=extend.oam.dev,resources=metrichpatraits/status,verbs=get;update;patch

func (r *MetricHPATraitReconciler) Reconcile(req ctrl.Request) (ctrl.Result, error) {
	ctx := context.Background()
	log := r.Log.WithValues("metrichpatrait", req.NamespacedName)

	log.Info("Reconcile MetricHPATrait")

	var mhpaTrait extendv1alpha2.MetricHPATrait
	if err := r.Get(ctx, req.NamespacedName, &mhpaTrait); err != nil {
		return ctrl.Result{}, client.IgnoreNotFound(err)
	}

	//TODO get ContainerizedWorkload and its Deployment & Service
	workload, result, err := r.getReferecedWrokload(ctx, log, &mhpaTrait)
	if err != nil {
		return result, err
	}

	resources, err := util.FetchWorkloadChildResources(ctx, log, r, workload)
	// resources, err := r.getUnderlyingResources(ctx, log, workload)
	if err != nil {
		if errP := util.PatchCondition(ctx, r, &mhpaTrait, cpv1alpha1.ReconcileError(fmt.Errorf(errLocateResources))); errP != nil {
			return util.ReconcileWaitResult, errors.Wrap(err, errP.Error())
		}
		return util.ReconcileWaitResult, err
	}

	cwDeploy, cwSvc, err := r.getCWChildResource(resources)
	log.Info("Get resources", "deployment", cwDeploy, "service", cwSvc)

	if err != nil {
		if errP := util.PatchCondition(ctx, r, &mhpaTrait, cpv1alpha1.ReconcileError(fmt.Errorf(errLocateResources))); errP != nil {
			return util.ReconcileWaitResult, errors.Wrap(err, errP.Error())
		}
		return util.ReconcileWaitResult, err
	}

	//TODO construct & create ConfiMap for Prometheus
	cwSvcName := mhpaTrait.Spec.WorkloadReference.Name // cw always uses cw's name as underlying svc's name

	promeConfigMap := &corev1.ConfigMap{
		TypeMeta: metav1.TypeMeta{
			Kind:       reflect.TypeOf(corev1.ConfigMap{}).Name(),
			APIVersion: corev1.SchemeGroupVersion.String(),
		},
		ObjectMeta: metav1.ObjectMeta{
			Name:      "prom-conf-" + mhpaTrait.Spec.WorkloadReference.Name, // use cw name as configmap name
			Namespace: mhpaTrait.GetNamespace(),
			Labels: map[string]string{
				LabelKey: string(mhpaTrait.GetUID()),
			},
		},
		Data: map[string]string{
			"prometheus.yml": fmt.Sprintf("global:\n  scrape_interval: 5s\n  evaluation_interval: 5s\nscrape_configs:\n  - job_name: '%s'\n    kubernetes_sd_configs:\n    - role: endpoints\n    relabel_configs:\n    - source_labels: [__meta_kubernetes_endpoints_name]\n      regex: '%s'\n      action: keep", cwSvcName, cwSvcName),
		},
	}

	log.Info("Render promeConfigMap", "data", promeConfigMap.Data)

	if err := ctrl.SetControllerReference(&mhpaTrait, promeConfigMap, r.Scheme); err != nil {
		return util.ReconcileWaitResult, err
	}

	applyOptions := []client.PatchOption{client.ForceOwnership, client.FieldOwner(mhpaTrait.GetUID())}

	if err := r.Patch(ctx, promeConfigMap, client.Apply, applyOptions...); err != nil {
		log.Error(err, "Apply ConfigMap failed.")
		if errP := util.PatchCondition(ctx, r, &mhpaTrait, cpv1alpha1.ReconcileError(errors.Wrap(err, errCreatConfigMap))); errP != nil {
			return util.ReconcileWaitResult, errors.Wrap(err, errP.Error())
		}
		return util.ReconcileWaitResult, err
	}

	var promeServerAddress string
	var promeDeploy *appsv1.Deployment
	var promeSvc *corev1.Service

	if len(mhpaTrait.Spec.PromServerAddress) > 0 {
		// use external Prometheus server
		promeServerAddress = mhpaTrait.Spec.PromServerAddress
	} else {
		// construct & create Deployment&Service for Prometheus
		promeDeploy, promeSvc = renderPrometheusResources(&mhpaTrait)

		if err := ctrl.SetControllerReference(&mhpaTrait, promeDeploy, r.Scheme); err != nil {
			return util.ReconcileWaitResult, err
		}
		if err := ctrl.SetControllerReference(&mhpaTrait, promeSvc, r.Scheme); err != nil {
			return util.ReconcileWaitResult, err
		}

		if err := r.Patch(ctx, promeDeploy, client.Apply, applyOptions...); err != nil {
			log.Error(err, "Apply Deployment for Prometheus failed.")
			if errP := util.PatchCondition(ctx, r, &mhpaTrait, cpv1alpha1.ReconcileError(errors.Wrap(err, errCreatePromeDeploy))); errP != nil {
				return util.ReconcileWaitResult, errors.Wrap(err, errP.Error())
			}
			return util.ReconcileWaitResult, err
		}
		if err := r.Patch(ctx, promeSvc, client.Apply, applyOptions...); err != nil {
			log.Error(err, "Apply Service for Prometheus failed.")
			if errP := util.PatchCondition(ctx, r, &mhpaTrait, cpv1alpha1.ReconcileError(errors.Wrap(err, errCreatePromeSvc))); errP != nil {
				return util.ReconcileWaitResult, errors.Wrap(err, errP.Error())
			}
			return util.ReconcileWaitResult, err
		}
		promeServerAddress = "http://" + strings.Join([]string{promeSvc.ObjectMeta.Name, promeSvc.ObjectMeta.Namespace, "svc.cluster.local"}, ".") + ":" + fmt.Sprint(defaultPromeServerPort)
	}

	//TODO construct & create KEDA ScaledObject
	scaledObj := &kedav1alpha1.ScaledObject{
		TypeMeta: metav1.TypeMeta{
			Kind:       reflect.TypeOf(kedav1alpha1.ScaledObject{}).Name(),
			APIVersion: kedav1alpha1.SchemeGroupVersion.String(),
		},
		ObjectMeta: metav1.ObjectMeta{
			Name:      mhpaTrait.GetName(), // use trait name as ScaledObject name
			Namespace: mhpaTrait.GetNamespace(),
		},
		Spec: kedav1alpha1.ScaledObjectSpec{
			ScaleTargetRef: &kedav1alpha1.ObjectReference{
				DeploymentName: mhpaTrait.Spec.WorkloadReference.Name, // specify deployment being scaled
			},
			PollingInterval: mhpaTrait.Spec.PollingInterval,
			CooldownPeriod:  mhpaTrait.Spec.CooldownPeriod,
			MinReplicaCount: mhpaTrait.Spec.MinReplicaCount,
			MaxReplicaCount: mhpaTrait.Spec.MaxReplicaCount,
			Triggers: []kedav1alpha1.ScaleTriggers{{
				Type: "prometheus",
				Metadata: map[string]string{
					"serverAddress": promeServerAddress,
					"metricName":    mhpaTrait.GetName() + "-metric",
					"threshold":     fmt.Sprint(*mhpaTrait.Spec.PromThreshold),
					"query":         mhpaTrait.Spec.PromQuery,
				},
			}},
		},
	}
	if err := ctrl.SetControllerReference(&mhpaTrait, scaledObj, r.Scheme); err != nil {
		return util.ReconcileWaitResult, err
	}

	if err := r.Patch(ctx, scaledObj, client.Apply, applyOptions...); err != nil {
		log.Error(err, "Apply KEDA ScaledObject failed.")
		if errP := util.PatchCondition(ctx, r, &mhpaTrait, cpv1alpha1.ReconcileError(errors.Wrap(err, errCreatScaledObject))); errP != nil {
			return util.ReconcileWaitResult, errors.Wrap(err, errP.Error())
		}
		return util.ReconcileWaitResult, err
	}

	// garbage collect
	if err := r.cleanupResources(ctx, &mhpaTrait, &promeDeploy.UID, &promeSvc.UID, &scaledObj.UID); err != nil {
		log.Error(err, "Garbage collection failed.")
		if errP := util.PatchCondition(ctx, r, &mhpaTrait, cpv1alpha1.ReconcileError(errors.Wrap(err, errGarbageCollection))); errP != nil {
			return util.ReconcileWaitResult, errors.Wrap(err, errP.Error())
		}
		return util.ReconcileWaitResult, err
	}

	// update Trait status
	mhpaTrait.Status.Resources = nil
	mhpaTrait.Status.Resources = append(mhpaTrait.Status.Resources,
		cpv1alpha1.TypedReference{
			APIVersion: scaledObj.GetObjectKind().GroupVersionKind().GroupVersion().String(),
			Kind:       scaledObj.GetObjectKind().GroupVersionKind().Kind,
			Name:       scaledObj.GetName(),
			UID:        scaledObj.UID,
		},
	)
	if promeDeploy != nil && promeSvc != nil {
		mhpaTrait.Status.Resources = append(mhpaTrait.Status.Resources,
			cpv1alpha1.TypedReference{
				APIVersion: promeDeploy.GetObjectKind().GroupVersionKind().GroupVersion().String(),
				Kind:       promeDeploy.GetObjectKind().GroupVersionKind().Kind,
				Name:       promeDeploy.GetName(),
				UID:        promeDeploy.UID,
			},
			cpv1alpha1.TypedReference{
				APIVersion: promeSvc.GetObjectKind().GroupVersionKind().GroupVersion().String(),
				Kind:       promeSvc.GetObjectKind().GroupVersionKind().Kind,
				Name:       promeSvc.GetName(),
				UID:        promeSvc.UID,
			},
		)

	}
	if err := r.Status().Update(ctx, &mhpaTrait); err != nil {
		log.Error(err, "Update mhpaTrait status failed", "mhpaTrait", mhpaTrait)
		return util.ReconcileWaitResult, err
	}
	return ctrl.Result{}, util.PatchCondition(ctx, r, &mhpaTrait, cpv1alpha1.ReconcileSuccess())
}

func (r *MetricHPATraitReconciler) SetupWithManager(mgr ctrl.Manager) error {
	return ctrl.NewControllerManagedBy(mgr).
		For(&extendv1alpha2.MetricHPATrait{}).
		Complete(r)
}
