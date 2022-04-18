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
	"github.com/crossplane/crossplane-runtime/pkg/event"
	oamutil "github.com/crossplane/oam-kubernetes-runtime/pkg/oam/util"
	"github.com/go-logr/logr"
	"github.com/pkg/errors"
	appsv1 "k8s.io/api/apps/v1"
	"k8s.io/api/policy/v1beta1"
	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"
	"k8s.io/apimachinery/pkg/runtime"
	ctrl "sigs.k8s.io/controller-runtime"
	"sigs.k8s.io/controller-runtime/pkg/client"

	corev1alpha2 "github.com/oam-dev/catalog/traits/poddisruptionbudgettrait/api/v1alpha2"
)

const (
	errLocateWorkload            = "cannot find workload"
	errLocateResources           = "cannot find resources"
	errApplyPodDisruptionBudget  = "cannot apply the podDisruptionBudget"
	errRenderPodDisruptionBudget = "cannot render podDisruptionBudget"
)

// PodDisruptionBudgetTraitReconciler reconciles a PodDisruptionBudgetTrait object
type PodDisruptionBudgetTraitReconciler struct {
	client.Client
	Log    logr.Logger
	Scheme *runtime.Scheme
	record event.Recorder
}

// +kubebuilder:rbac:groups=core.oam.dev,resources=poddisruptionbudgettraits,verbs=get;list;watch;create;update;patch;delete
// +kubebuilder:rbac:groups=core.oam.dev,resources=poddisruptionbudgettraits/status,verbs=get;update;patch
// +kubebuilder:rbac:groups=core.oam.dev,resources=statefulsetworkloads,verbs=get;list;watch
// +kubebuilder:rbac:groups=core.oam.dev,resources=statefulsetworkloads/status,verbs=get;
// +kubebuilder:rbac:groups=core.oam.dev,resources=containerizedworkloads,verbs=get;list;
// +kubebuilder:rbac:groups=core.oam.dev,resources=containerizedworkloads/status,verbs=get;
// +kubebuilder:rbac:groups=core.oam.dev,resources=workloaddefinitions,verbs=get;list;watch
// +kubebuilder:rbac:groups=apps,resources=statefulsets,verbs=get;list;watch;update;patch;delete
// +kubebuilder:rbac:groups=apps,resources=deployments,verbs=get;list;watch;update;patch;delete
// +kubebuilder:rbac:groups=apps,resources=replicasets,verbs=get;list;watch;update;patch;delete
// +kubebuilder:rbac:groups=policy,resources=poddisruptionbudgets,verbs=get;list;watch;create;update;patch;delete

func (r *PodDisruptionBudgetTraitReconciler) Reconcile(req ctrl.Request) (ctrl.Result, error) {
	ctx := context.Background()
	log := r.Log.WithValues("poddisruptionbudgettrait", req.NamespacedName)
	log.Info("Reconcile PodDisruptionBudget Trait")

	var trait corev1alpha2.PodDisruptionBudgetTrait
	if err := r.Get(ctx, req.NamespacedName, &trait); err != nil {
		return ctrl.Result{}, client.IgnoreNotFound(err)
	}
	log.Info("Get the PodDisruptionBudget trait", "WorkloadReference", trait.Spec.WorkloadReference)

	// find the resource object to record the event to, default is the parent appConfig.
	eventObj, err := oamutil.LocateParentAppConfig(ctx, r.Client, &trait)
	if eventObj == nil {
		// fallback to workload itself
		log.Error(err, "add events to podDisruptionBudgetTrait itself", "name", trait.Name)
		eventObj = &trait
	}

	// Fetch the workload instance to which we want to expose metrics
	workload, err := oamutil.FetchWorkload(ctx, r, log, &trait)
	if err != nil {
		log.Error(err, "Error while fetching the workload", "workload reference",
			trait.GetWorkloadReference())
		r.record.Event(eventObj, event.Warning(errLocateWorkload, err))
		return oamutil.ReconcileWaitResult,
			oamutil.PatchCondition(ctx, r, &trait,
				cpv1alpha1.ReconcileError(errors.Wrap(err, errLocateWorkload)))
	}

	// Fetch the child resources list from the corresponding workload
	resources, err := oamutil.FetchWorkloadChildResources(ctx, log, r, workload)
	if err != nil {
		log.Error(err, "Error while fetching the workload child resources", "workload", workload.UnstructuredContent())
		r.record.Event(eventObj, event.Warning(oamutil.ErrFetchChildResources, err))
		return oamutil.ReconcileWaitResult, oamutil.PatchCondition(ctx, r, &trait, cpv1alpha1.ReconcileError(fmt.Errorf(oamutil.ErrFetchChildResources)))
	}

	// Create a PodDisruptionBudget for the resources we know
	pdb, err := r.createPodDisruptionBudget(ctx, trait, resources)
	if err != nil {
		return oamutil.ReconcileWaitResult, err
	}

	// server side apply the podDisruptionBudget, only the fields we set are touched
	applyOpts := []client.PatchOption{client.ForceOwnership, client.FieldOwner(trait.Name)}
	if err := r.Patch(ctx, pdb, client.Apply, applyOpts...); err != nil {
		r.Log.Error(err, "Failed to apply a podDisruptionBudget")
		return oamutil.ReconcileWaitResult,
			oamutil.PatchCondition(ctx, r, &trait, cpv1alpha1.ReconcileError(errors.Wrap(err, errApplyPodDisruptionBudget)))
	}
	r.Log.Info("Successfully applied a podDisruptionBudget", "UID", pdb.UID)

	// record the new podDisruptionBudget
	trait.Status.Resources = []cpv1alpha1.TypedReference{{
		APIVersion: pdb.GetObjectKind().GroupVersionKind().GroupVersion().String(),
		Kind:       pdb.GetObjectKind().GroupVersionKind().Kind,
		Name:       pdb.GetName(),
		UID:        pdb.GetUID(),
	}}

	if err := r.Status().Update(ctx, &trait); err != nil {
		return oamutil.ReconcileWaitResult, err
	}

	return ctrl.Result{}, oamutil.PatchCondition(ctx, r, &trait, cpv1alpha1.ReconcileSuccess())
}

func (r *PodDisruptionBudgetTraitReconciler) createPodDisruptionBudget(ctx context.Context, trait corev1alpha2.PodDisruptionBudgetTrait, resources []*unstructured.Unstructured) (*v1beta1.PodDisruptionBudget, error) {
	for _, res := range resources {
		if res.GetAPIVersion() == appsv1.SchemeGroupVersion.String() {
			r.Log.Info("Get the resources the trait is going to create a podDisruptionBudgetTrait for it",
				"resources name", res.GetName(), "UID", res.GetUID())

			// Create a podDisruptionBudget for the workload which this trait is referring to
			pdb, err := r.renderPodDisruptionBudget(ctx, &trait, res)
			if err != nil {
				r.Log.Error(err, "Failed to render a podDisruptionBudget")
				return nil, oamutil.PatchCondition(ctx, r, &trait, cpv1alpha1.ReconcileError(errors.Wrap(err, errRenderPodDisruptionBudget)))
			}
			return pdb, nil
		}
	}
	r.Log.Info("Cannot locate any resources", "total resources", len(resources))
	return nil, oamutil.PatchCondition(ctx, r, &trait, cpv1alpha1.ReconcileError(fmt.Errorf(errLocateResources)))
}

func (r *PodDisruptionBudgetTraitReconciler) SetupWithManager(mgr ctrl.Manager) error {
	return ctrl.NewControllerManagedBy(mgr).
		For(&corev1alpha2.PodDisruptionBudgetTrait{}).
		Complete(r)
}
