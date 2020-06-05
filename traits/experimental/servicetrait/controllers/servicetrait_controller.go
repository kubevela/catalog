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
	"github.com/crossplane/oam-kubernetes-runtime/pkg/oam"
	corev1 "k8s.io/api/core/v1"
	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"
	"sigs.k8s.io/controller-runtime/pkg/builder"
	"sigs.k8s.io/controller-runtime/pkg/predicate"

	"github.com/go-logr/logr"
	"github.com/pkg/errors"
	appsv1 "k8s.io/api/apps/v1"
	"k8s.io/apimachinery/pkg/runtime"
	ctrl "sigs.k8s.io/controller-runtime"
	"sigs.k8s.io/controller-runtime/pkg/client"

	corev1alpha2 "github.com/oam-dev/catalog/traits/experimental/servicetrait/api/v1alpha2"
)

// Reconcile error strings.
const (
	errLocateWorkload    = "cannot find workload"
	errLocateResources   = "cannot find resources"
	errLocateStatefulSet = "cannot find statefulset"
	errRenderService     = "cannot render service"
	errApplyService      = "cannot apply the service"
	errGCService         = "cannot clean up stale services"
)

// ServiceTraitReconciler reconciles a ServiceTrait object
type ServiceTraitReconciler struct {
	client.Client
	Log    logr.Logger
	Scheme *runtime.Scheme
}

// +kubebuilder:rbac:groups=core.oam.dev,resources=servicetraits,verbs=get;list;watch;
// +kubebuilder:rbac:groups=core.oam.dev,resources=servicetraits/status,verbs=get;update;patch
// +kubebuilder:rbac:groups=core.oam.dev,resources=statefulsetworkloads,verbs=get;list;
// +kubebuilder:rbac:groups=core.oam.dev,resources=statefulsetworkloads/status,verbs=get;
// +kubebuilder:rbac:groups=core.oam.dev,resources=containerizedworkloads,verbs=get;list;
// +kubebuilder:rbac:groups=core.oam.dev,resources=containerizedworkloads/status,verbs=get;
// +kubebuilder:rbac:groups=core.oam.dev,resources=workloaddefinitions,verbs=get;list;watch
// +kubebuilder:rbac:groups=apps,resources=statefulsets,verbs=get;list;watch;update;patch;delete
// +kubebuilder:rbac:groups=apps,resources=deployments,verbs=get;list;watch;update;patch;delete
// +kubebuilder:rbac:groups=core,resources=services,verbs=get;list;watch;create;update;patch;delete

func (r *ServiceTraitReconciler) Reconcile(req ctrl.Request) (ctrl.Result, error) {
	ctx := context.Background()
	log := r.Log.WithValues("servicetrait", req.NamespacedName)
	log.Info("Reconcile Service Trait")

	var trait corev1alpha2.ServiceTrait
	if err := r.Get(ctx, req.NamespacedName, &trait); err != nil {
		return ctrl.Result{}, client.IgnoreNotFound(err)
	}
	log.Info("Get the service trait", "WorkloadReference", trait.Spec.WorkloadReference)

	// Fetch the workload this trait is referring to
	workload, result, err := r.fetchWorkload(ctx, log, &trait)
	if err != nil {
		return result, err
	}

	// Determine the workload type
	resources, err := DetermineWorkloadType(ctx, log, r, workload)
	if err != nil {
		r.Log.Error(err, "Cannot find the workload child resources", "workload", workload.UnstructuredContent())
		return util.ReconcileWaitResult,
			util.PatchCondition(ctx, r, &trait, cpv1alpha1.ReconcileError(fmt.Errorf(errLocateResources)))
	}

	// Create a service for the child resources we know
	svc, err := r.createService(ctx, trait, resources)
	if err != nil {
		return result, err
	}

	// server side apply the service, only the fields we set are touched
	applyOpts := []client.PatchOption{client.ForceOwnership, client.FieldOwner(trait.Name)}
	if err := r.Patch(ctx, svc, client.Apply, applyOpts...); err != nil {
		r.Log.Error(err, "Failed to apply a service")
		return util.ReconcileWaitResult,
			util.PatchCondition(ctx, r, &trait, cpv1alpha1.ReconcileError(errors.Wrap(err, errApplyService)))
	}
	r.Log.Info("Successfully applied a service", "UID", svc.UID)

	// garbage collect the service that we created but not needed
	if err := r.cleanupResources(ctx, &trait, &svc.UID); err != nil {
		r.Log.Error(err, "Failed to clean up resources")
		return util.ReconcileWaitResult,
			util.PatchCondition(ctx, r, &trait, cpv1alpha1.ReconcileError(errors.Wrap(err, errGCService)))
	}
	trait.Status.Resources = nil
	// record the new service
	trait.Status.Resources = append(trait.Status.Resources, cpv1alpha1.TypedReference{
		APIVersion: svc.GetObjectKind().GroupVersionKind().GroupVersion().String(),
		Kind:       svc.GetObjectKind().GroupVersionKind().Kind,
		Name:       svc.GetName(),
		UID:        svc.GetUID(),
	})

	if err := r.Status().Update(ctx, &trait); err != nil {
		return util.ReconcileWaitResult, err
	}

	return ctrl.Result{}, util.PatchCondition(ctx, r, &trait, cpv1alpha1.ReconcileSuccess())
}

func (r *ServiceTraitReconciler) createService(ctx context.Context, serviceTr corev1alpha2.ServiceTrait, resources []*unstructured.Unstructured) (*corev1.Service, error) {
	for _, res := range resources {
		// Determine whether APIVersion is "appsv1"
		if res.GetAPIVersion() == appsv1.SchemeGroupVersion.String() {
			r.Log.Info("Get the resources the trait is going to create a service for it",
				"resources name", res.GetName(), "UID", res.GetUID())

			// Create a service for the workload which this trait is referring to
			svc, err := r.renderService(ctx, &serviceTr, res)
			if err != nil {
				r.Log.Error(err, "Failed to render a service")
				return nil, util.PatchCondition(ctx, r, &serviceTr, cpv1alpha1.ReconcileError(errors.Wrap(err, errRenderService)))
			}
			return svc, nil
		}
	}
	r.Log.Info("Cannot locate any statefulset", "total resources", len(resources))
	return nil, util.PatchCondition(ctx, r, &serviceTr, cpv1alpha1.ReconcileError(fmt.Errorf(errLocateStatefulSet)))
}

func (r *ServiceTraitReconciler) fetchWorkload(ctx context.Context, log logr.Logger,
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

func (r *ServiceTraitReconciler) SetupWithManager(mgr ctrl.Manager) error {
	return ctrl.NewControllerManagedBy(mgr).
		For(&corev1alpha2.ServiceTrait{}).
		Owns(&appsv1.StatefulSet{}, builder.WithPredicates(predicate.GenerationChangedPredicate{})).
		Owns(&corev1.Service{}, builder.WithPredicates(predicate.GenerationChangedPredicate{})).
		Complete(r)
}
