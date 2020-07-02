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

	cpv1alpha1 "github.com/crossplane/crossplane-runtime/apis/core/v1alpha1"
	"github.com/crossplane/oam-controllers/pkg/oam/util"
	"github.com/go-logr/logr"
	"github.com/pkg/errors"
	"k8s.io/apimachinery/pkg/runtime"
	"k8s.io/apimachinery/pkg/types"
	ctrl "sigs.k8s.io/controller-runtime"
	"sigs.k8s.io/controller-runtime/pkg/client"

	coreoamdevv1alpha2 "github.com/oam-dev/catalog/traits/hpatrait/api/v1alpha2"
)

// Reconcile error strings.
const (
	errLocateWorkload          = "cannot find workload"
	errLocateResources         = "cannot find resources"
	errLocateAvailableResouces = "cannot find available resources"
	errRenderService           = "cannot render service"
	errApplyHPA                = "cannot apply the HPA"
	errGCHPA                   = "cannot clean up HPA"
)

// HorizontalPodAutoscalerTraitReconciler reconciles a HorizontalPodAutoscalerTrait object
type HorizontalPodAutoscalerTraitReconciler struct {
	client.Client
	Log    logr.Logger
	Scheme *runtime.Scheme
}

// +kubebuilder:rbac:groups=core.oam.dev,resources=horizontalpodautoscalertraits,verbs=get;list;watch;create;update;patch;delete
// +kubebuilder:rbac:groups=core.oam.dev,resources=horizontalpodautoscalertraits/status,verbs=get;update;patch
// +kubebuilder:rbac:groups=core.oam.dev,resources=workloaddefinitions,verbs=get;list;watch
// +kubebuilder:rbac:groups=core.oam.dev,resources=containerizedworkloads/status,verbs=get;
// +kubebuilder:rbac:groups=core.oam.dev,resources=containerizedworkloads,verbs=get;list;watch;update;patch;delete
// +kubebuilder:rbac:groups=apps,resources=statefulsets,verbs=get;list;watch;update;patch;delete
// +kubebuilder:rbac:groups=apps,resources=deployments,verbs=get;list;watch;update;patch;delete
// +kubebuilder:rbac:groups=autoscaling,resources=horizontalpodautoscalers,verbs=get;list;watch;create;update;patch;delete
// +kubebuilder:rbac:groups=core,resources=services,verbs=get;list;watch;

func (r *HorizontalPodAutoscalerTraitReconciler) Reconcile(req ctrl.Request) (ctrl.Result, error) {
	ctx := context.Background()
	log := r.Log.WithValues("horizontalpodautoscalertrait", req.NamespacedName)

	log.Info("Reconcile HorizontalPodAutoscalerTrait")

	var hpatrait coreoamdevv1alpha2.HorizontalPodAutoscalerTrait
	if err := r.Get(ctx, req.NamespacedName, &hpatrait); err != nil {
		return ctrl.Result{}, client.IgnoreNotFound(err)
	}
	log.Info("Get the HPA trait", "Spec: ", hpatrait.Spec)

	// Fetch the oam/workload this trait refers to
	// e.g. core.oam.dev/ContainerizedWorkload, apps/StatefulSet, apps/Deployment
	workload, result, err := r.fetchWorkload(ctx, log, &hpatrait)
	if err != nil {
		return result, err
	}

	// Determine the exact underlying resources the oam/workload refers to
	// e.g. non-native k8s resources: core.oam.dev/containerizedworkloads.spec.childResourceKinds
	// e.g. native k8s: apps/statefulset, apps/deployment
	resources, err := DetermineWorkloadType(ctx, log, r, workload)
	if err != nil {
		r.Log.Error(err, "Cannot find the workload's child resources", "workload", workload.UnstructuredContent())
		return util.ReconcileWaitResult, util.PatchCondition(ctx, r, &hpatrait, cpv1alpha1.ReconcileError(fmt.Errorf(errLocateResources)))
	}

	// render HPAs
	// it's possible that one component contains more than one deployment or statefulset.
	// then each deployment or statefulset deserves one HPA.
	hpas, err := r.renderHPA(ctx, &hpatrait, resources)
	if err != nil {
		return ctrl.Result{}, err
	}

	if len(hpas) == 0 {
		r.Log.Info("Cannot get any HPA-applicable resources")
		return ctrl.Result{}, util.PatchCondition(ctx, r, &hpatrait, cpv1alpha1.ReconcileError(fmt.Errorf(errLocateAvailableResouces)))
	}

	// to record UID of newly created HPAs
	hpaUIDs := make([]types.UID, 0)
	hpatrait.Status.Resources = nil

	// server side apply HPAs
	for _, hpa := range hpas {
		applyOpts := []client.PatchOption{client.ForceOwnership, client.FieldOwner(hpa.Name)}
		if err := r.Patch(ctx, hpa, client.Apply, applyOpts...); err != nil {
			r.Log.Error(err, "Failed to apply a HPA", "Target HPA spec", hpa, "Total HPA count", len(hpas))
			return util.ReconcileWaitResult,
				util.PatchCondition(ctx, r, &hpatrait, cpv1alpha1.ReconcileError(errors.Wrap(err, errApplyHPA)))
		}
		r.Log.Info("Successfully applied a HPA", "UID", hpa.UID)

		// record the status of newly created HPA
		hpatrait.Status.Resources = append(hpatrait.Status.Resources, cpv1alpha1.TypedReference{
			APIVersion: hpa.GetObjectKind().GroupVersionKind().GroupVersion().String(),
			Kind:       hpa.GetObjectKind().GroupVersionKind().Kind,
			Name:       hpa.GetName(),
			UID:        hpa.GetUID(),
		})
		hpaUIDs = append(hpaUIDs, hpa.GetUID())
		if err := r.Status().Update(ctx, &hpatrait); err != nil {
			r.Log.Info("Failed update HPA_trait status", "err:", err)
			return util.ReconcileWaitResult, err
		}
		r.Log.Info("Successfully update HPA_trait status", "UID", hpatrait.GetUID())
	}

	// delete existing HPAs referred to this HPAtrait
	if err := r.cleanUpLegacyHPAs(ctx, &hpatrait, hpaUIDs); err != nil {
		r.Log.Error(err, "Failed to delete legacy HPAs")
		return util.ReconcileWaitResult,
			util.PatchCondition(ctx, r, &hpatrait, cpv1alpha1.ReconcileError(errors.Wrap(err, errGCHPA)))
	}

	return ctrl.Result{}, util.PatchCondition(ctx, r, &hpatrait, cpv1alpha1.ReconcileSuccess())
}

func (r *HorizontalPodAutoscalerTraitReconciler) SetupWithManager(mgr ctrl.Manager) error {
	return ctrl.NewControllerManagedBy(mgr).
		For(&coreoamdevv1alpha2.HorizontalPodAutoscalerTrait{}).
		Complete(r)
}
