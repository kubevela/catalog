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

	"github.com/AliyunContainerService/kubernetes-cronhpa-controller/pkg/apis/autoscaling/v1beta1"
	appsv1 "k8s.io/api/apps/v1"

	cpv1alpha1 "github.com/crossplane/crossplane-runtime/apis/core/v1alpha1"
	"github.com/crossplane/oam-kubernetes-runtime/pkg/oam"
	"github.com/crossplane/oam-kubernetes-runtime/pkg/oam/util"
	"github.com/pkg/errors"
	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"

	"github.com/go-logr/logr"
	"k8s.io/apimachinery/pkg/runtime"
	ctrl "sigs.k8s.io/controller-runtime"
	"sigs.k8s.io/controller-runtime/pkg/client"

	corev1alpha2 "github.com/oam-dev/catalog/traits/cronhpatrait/api/v1alpha2"
)

// Reconcile error strings.
const (
	errLocateWorkload  = "cannot find workload"
	errLocateResources = "cannot find resources"
	errApplyCronHPA    = "cannot apply the cronHPA"
	errRenderCronHPA   = "cannot render cronHPA"
	errGCCronHPA       = "cannot clean up stale cronHPA"
)

// CronHPATraitReconciler reconciles a CronHPATrait object
type CronHPATraitReconciler struct {
	client.Client
	Log    logr.Logger
	Scheme *runtime.Scheme
}

// +kubebuilder:rbac:groups=core.oam.dev,resources=cronhpatraits,verbs=get;list;watch;create;update;patch;delete
// +kubebuilder:rbac:groups=core.oam.dev,resources=cronhpatraits/status,verbs=get;update;patch
// +kubebuilder:rbac:groups=core.oam.dev,resources=statefulsetworkloads,verbs=get;list;watch
// +kubebuilder:rbac:groups=core.oam.dev,resources=statefulsetworkloads/status,verbs=get;
// +kubebuilder:rbac:groups=core.oam.dev,resources=containerizedworkloads,verbs=get;list;
// +kubebuilder:rbac:groups=core.oam.dev,resources=containerizedworkloads/status,verbs=get;
// +kubebuilder:rbac:groups=core.oam.dev,resources=workloaddefinitions,verbs=get;list;watch
// +kubebuilder:rbac:groups=apps,resources=statefulsets,verbs=get;list;watch;update;patch;delete
// +kubebuilder:rbac:groups=apps,resources=deployments,verbs=get;list;watch;update;patch;delete

func (r *CronHPATraitReconciler) Reconcile(req ctrl.Request) (ctrl.Result, error) {
	ctx := context.Background()
	log := r.Log.WithValues("cronhpatrait", req.NamespacedName)
	log.Info("Reconcile CronHPA Trait")

	var trait corev1alpha2.CronHPATrait
	if err := r.Get(ctx, req.NamespacedName, &trait); err != nil {
		return ctrl.Result{}, client.IgnoreNotFound(err)
	}
	log.Info("Get the cronHPA trait", "WorkloadReference", trait.Spec.WorkloadReference)

	// Fetch the workload this trait is referring to
	workload, result, err := r.fetchWorkload(ctx, &trait)
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

	// Create a CronHPA for the resources we know
	cronHPA, err := r.createCronHPA(ctx, trait, resources)
	_ = cronHPA
	if err != nil {
		return result, err
	}

	// server side apply the cronHPA, only the fields we set are touched
	applyOpts := []client.PatchOption{client.ForceOwnership, client.FieldOwner(trait.Name)}
	if err := r.Patch(ctx, cronHPA, client.Apply, applyOpts...); err != nil {
		r.Log.Error(err, "Failed to apply a cronHPA")
		return util.ReconcileWaitResult,
			util.PatchCondition(ctx, r, &trait, cpv1alpha1.ReconcileError(errors.Wrap(err, errApplyCronHPA)))
	}
	r.Log.Info("Successfully applied a cronHPA", "UID", cronHPA.UID)

	// garbage collect the cronHPA that we created but not needed
	if err := r.cleanupResources(ctx, &trait, &cronHPA.UID); err != nil {
		r.Log.Error(err, "Failed to clean up resources")
		return util.ReconcileWaitResult,
			util.PatchCondition(ctx, r, &trait, cpv1alpha1.ReconcileError(errors.Wrap(err, errGCCronHPA)))
	}
	trait.Status.Resources = nil
	// record the new cronHPA
	trait.Status.Resources = append(trait.Status.Resources, cpv1alpha1.TypedReference{
		APIVersion: cronHPA.GetObjectKind().GroupVersionKind().GroupVersion().String(),
		Kind:       cronHPA.GetObjectKind().GroupVersionKind().Kind,
		Name:       cronHPA.GetName(),
		UID:        cronHPA.GetUID(),
	})

	if err := r.Status().Update(ctx, &trait); err != nil {
		return util.ReconcileWaitResult, err
	}

	return ctrl.Result{}, util.PatchCondition(ctx, r, &trait, cpv1alpha1.ReconcileSuccess())
}

func (r *CronHPATraitReconciler) createCronHPA(ctx context.Context, trait corev1alpha2.CronHPATrait,
	resources []*unstructured.Unstructured) (*v1beta1.CronHorizontalPodAutoscaler, error) {
	for _, res := range resources {
		// Determine whether APIVersion is "appsv1"
		if res.GetAPIVersion() == appsv1.SchemeGroupVersion.String() {
			r.Log.Info("Get the resources the trait is going to create a cronHPA for it",
				"resources name", res.GetName(), "UID", res.GetUID())

			// Create a cronHPA for the workload which this trait is referring to
			cronHPA, err := r.renderCronHPA(ctx, &trait, res)
			if err != nil {
				r.Log.Error(err, "Failed to render a cronHPA")
				return nil, util.PatchCondition(ctx, r, &trait, cpv1alpha1.ReconcileError(errors.Wrap(err, errRenderCronHPA)))
			}
			return cronHPA, nil
		}
	}
	r.Log.Info("Cannot locate any resources", "total resources", len(resources))
	return nil, util.PatchCondition(ctx, r, &trait, cpv1alpha1.ReconcileError(fmt.Errorf(errLocateResources)))
}

func (r *CronHPATraitReconciler) fetchWorkload(ctx context.Context,
	oamTrait oam.Trait) (*unstructured.Unstructured, ctrl.Result, error) {
	var workload unstructured.Unstructured
	workload.SetAPIVersion(oamTrait.GetWorkloadReference().APIVersion)
	workload.SetKind(oamTrait.GetWorkloadReference().Kind)
	wn := client.ObjectKey{Name: oamTrait.GetWorkloadReference().Name, Namespace: oamTrait.GetNamespace()}
	if err := r.Get(ctx, wn, &workload); err != nil {
		r.Log.Error(err, "Workload not find", "kind", oamTrait.GetWorkloadReference().Kind,
			"worklaod name", oamTrait.GetWorkloadReference().Name)
		return nil, util.ReconcileWaitResult,
			util.PatchCondition(ctx, r, oamTrait, cpv1alpha1.ReconcileError(errors.Wrap(err, errLocateWorkload)))
	}
	r.Log.Info("Get the workload the trait is pointing to", "workload name", oamTrait.GetWorkloadReference().Name,
		"workload APIVersion", workload.GetAPIVersion(), "workload Kind", workload.GetKind(), "UID",
		workload.GetUID())
	return &workload, ctrl.Result{}, nil
}

func (r *CronHPATraitReconciler) SetupWithManager(mgr ctrl.Manager) error {
	return ctrl.NewControllerManagedBy(mgr).
		For(&corev1alpha2.CronHPATrait{}).
		Complete(r)
}
