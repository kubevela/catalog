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
	"time"

	cpv1alpha1 "github.com/crossplane/crossplane-runtime/apis/core/v1alpha1"
	"github.com/crossplane/oam-controllers/pkg/oam/util"
	"github.com/go-logr/logr"
	"github.com/pkg/errors"
	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"
	"k8s.io/apimachinery/pkg/runtime"
	ctrl "sigs.k8s.io/controller-runtime"
	"sigs.k8s.io/controller-runtime/pkg/client"
	"sigs.k8s.io/controller-runtime/pkg/reconcile"

	extendoamdevv1alpha2 "github.com/oam-dev/catalog/traits/simplerollouttrait/api/v1alpha2"
)

// Reconcile error strings.
const (
	errLocateWorkload            = "cannot find workload"
	errLocateResources           = "cannot find resources"
	errLocateAvailableResouces   = "cannot find available resources"
	errMarshalDeployment         = "cannot unmarshal deployment"
	errFailUpdateDeployment      = "failed to update deployment"
	errFailDeleteLegacyWorkload  = "failed to delete wrokload"
	errFailScaleUp               = "failed to scale up new workload"
	errFailScaleDown             = "failed to scale down new workload"
	errFailUpdateStatus          = "fail to update rollout status"
	errFailGetControllerRevision = "fail to get controller revision"
)

var (
	ReconcileWaitWorkloadInit  = reconcile.Result{RequeueAfter: 5 * time.Second}
	ReconcileWaitWorkloadScale = reconcile.Result{RequeueAfter: 5 * time.Second}
)

// SimpleRolloutTraitReconciler reconciles a SimpleRolloutTrait object
type SimpleRolloutTraitReconciler struct {
	client.Client
	Log    logr.Logger
	Scheme *runtime.Scheme
}

// +kubebuilder:rbac:groups=extend.oam.dev,resources=simplerollouttraits,verbs=get;list;watch;create;update;patch;delete
// +kubebuilder:rbac:groups=extend.oam.dev,resources=simplerollouttraits/status,verbs=get;update;patch
// +kubebuilder:rbac:groups=apps,resources=deployments,verbs=get;list;watch;update;patch;delete
// +kubebuilder:rbac:groups=apps,resources=controllerrevisions,verbs=get;list;watch
// +kubebuilder:rbac:groups=core.oam.dev,resources=containerizedworkloads/status,verbs=get;
// +kubebuilder:rbac:groups=core.oam.dev,resources=containerizedworkloads,verbs=get;list;watch;update;patch;delete
// +kubebuilder:rbac:groups=core.oam.dev,resources=workloaddefinitions,verbs=get;list;watch
// +kubebuilder:rbac:groups=core,resources=services,verbs=get;list;watch;create;update;patch;delete

// Reconcile reconciles the request
func (r *SimpleRolloutTraitReconciler) Reconcile(req ctrl.Request) (ctrl.Result, error) {
	ctx := context.Background()
	log := r.Log.WithValues("simplerollouttrait", req.NamespacedName)

	log.Info("Reconcile SimpleRolloutTrait")

	var rollouttrait extendoamdevv1alpha2.SimpleRolloutTrait
	if err := r.Get(ctx, req.NamespacedName, &rollouttrait); err != nil {
		return ctrl.Result{}, client.IgnoreNotFound(err)
	}

	log.Info("Reconcile target", "spec", rollouttrait.Spec, "status", rollouttrait.Status)

	targetReplica := rollouttrait.Spec.Replica
	batch := rollouttrait.Spec.Batch
	maxUnavailable := rollouttrait.Spec.MaxUnavailable

	// check whether it's newly created
	if isNewlyCreatedRolloutTrait(&rollouttrait) {
		//if it's new, set rollingupdate for deployment & update rollouttrait status
		workload, result, err := r.fetchWorkload(ctx, log, &rollouttrait)
		if err != nil {
			return result, err
		}
		underlyingDeployments, err := r.getUnderlyingDeployment(ctx, log, workload)
		if err != nil {
			log.Error(err, "Cannot find the workload child resources", "workload", workload.UnstructuredContent())
			return util.ReconcileWaitResult, util.PatchCondition(ctx, r, &rollouttrait, cpv1alpha1.ReconcileError(fmt.Errorf(errLocateResources)))
		}

		// check initial setup starts
		if len(underlyingDeployments) == 0 {
			return ReconcileWaitWorkloadInit, nil
		}

		for _, deployment := range underlyingDeployments {
			if deployment.Status.AvailableReplicas != *deployment.Spec.Replicas {
				// initial setup is not ready, requeue to wait
				// if update deployment before initial setup finish
				// runtime will raise an error
				return ReconcileWaitWorkloadInit, nil
			}

			if deployment.Status.AvailableReplicas == *targetReplica {
				continue
			}
			//TODO is it necessary to make the initial create gradually?
			// or just set the replicas and leave it swarm?
			deployment.Spec.Replicas = targetReplica

			log.Info("Going to update Deployment", "deployment detail", deployment)
			applyOpts := []client.UpdateOption{client.FieldOwner(rollouttrait.Spec.WorkloadReference.UID)}
			if err := r.Update(ctx, deployment, applyOpts...); err != nil {
				r.Log.Error(err, "Failed to apply a deployment", "deployment spec", deployment.Spec)
				return util.ReconcileWaitResult,
					util.PatchCondition(ctx, r, &rollouttrait, cpv1alpha1.ReconcileError(errors.Wrap(err, errFailUpdateDeployment)))
			}
		}
		// get corresponding ControllerRevision
		cr, err := r.getControllerRevision(ctx, log, &rollouttrait)
		if err != nil {
			r.Log.Error(err, "Failed to get ControllerRevision", "Revision name", rollouttrait.Spec.WorkloadReference.Name)
			return util.ReconcileWaitResult,
				util.PatchCondition(ctx, r, &rollouttrait, cpv1alpha1.ReconcileError(errors.Wrap(err, errFailGetControllerRevision)))
		}

		newRolloutiHistory := extendoamdevv1alpha2.RolloutHistory{
			Revision:    cr.Revision,
			HistoryData: cr.Data,
		}

		rollouttrait.Status.RolloutHistory = []extendoamdevv1alpha2.RolloutHistory{newRolloutiHistory}
		rollouttrait.Status.CurrentWorkloadReference = rollouttrait.Spec.WorkloadReference

		//update rollouttrait status
		if err := r.Status().Update(ctx, &rollouttrait); err != nil {
			r.Log.Error(err, "Failed to update rollouttrait status")
			return util.ReconcileWaitResult,
				util.PatchCondition(ctx, r, &rollouttrait, cpv1alpha1.ReconcileError(errors.Wrap(err, errFailUpdateStatus)))
		}
		return ctrl.Result{}, util.PatchCondition(ctx, r, &rollouttrait, cpv1alpha1.ReconcileSuccess())
	} else {
		// if it's not new, then check whether it's in the middle of rollout
		if isUnderRollout(&rollouttrait) {
			//if it's under rollout
			//fetch two workloadInstances (spec.workloadRef & status.currentWorkloadRef)
			newWorkload, result, err := r.fetchWorkload(ctx, log, &rollouttrait)
			if err != nil {
				return result, err
			}

			newUnderlyingDeployments, err := r.getUnderlyingDeployment(ctx, log, newWorkload)
			if err != nil {
				log.Error(err, "Cannot find the workload child resources", "workload", newWorkload.UnstructuredContent())
				return util.ReconcileWaitResult, util.PatchCondition(ctx, r, &rollouttrait, cpv1alpha1.ReconcileError(fmt.Errorf(errLocateResources)))
			}

			// handle the situation where no deployments in the workload returned
			if len(newUnderlyingDeployments) == 0 {
				// it means workload instance is already created
				// but underlying deployments not
				return util.ReconcileWaitResult, nil
			}

			var oldWorkload unstructured.Unstructured
			oldWorkload.SetAPIVersion(rollouttrait.Status.CurrentWorkloadReference.APIVersion)
			oldWorkload.SetKind(rollouttrait.Status.CurrentWorkloadReference.Kind)

			wn := client.ObjectKey{Name: rollouttrait.Status.CurrentWorkloadReference.Name, Namespace: rollouttrait.GetNamespace()}

			if err := r.Get(ctx, wn, &oldWorkload); err != nil {
				log.Error(err, "Old workload not find", "kind", rollouttrait.GetWorkloadReference().Kind,
					"workload name", rollouttrait.GetWorkloadReference().Name)
				return util.ReconcileWaitResult, err
			}

			oldUnderlyingDeployments, err := r.getUnderlyingDeployment(ctx, log, &oldWorkload)
			if err != nil {
				log.Error(err, "Cannot find the workload child resources", "workload", oldWorkload.UnstructuredContent())
				return util.ReconcileWaitResult, util.PatchCondition(ctx, r, &rollouttrait, cpv1alpha1.ReconcileError(fmt.Errorf(errLocateResources)))
			}

			// check whether both scale are ready
			if isScaleUpReady(newUnderlyingDeployments, *targetReplica) && isScaleDownReady(oldUnderlyingDeployments) {
				// if both are ready
				// delete old workload instance
				if err := r.Delete(ctx, &oldWorkload); err != nil {
					log.Error(err, "Failed to delete old workload instance", "kind", oldWorkload.GetKind())
					return util.ReconcileWaitResult,
						util.PatchCondition(ctx, r, &rollouttrait, cpv1alpha1.ReconcileError(fmt.Errorf(errFailDeleteLegacyWorkload)))
				}
				log.Info("Deleted old workload instance successfully", "kind", oldWorkload.GetKind())
				// get corresponding ControllerRevision
				cr, err := r.getControllerRevision(ctx, log, &rollouttrait)
				if err != nil {
					r.Log.Error(err, "Failed to get ControllerRevision", "Revision name", rollouttrait.Spec.WorkloadReference.Name)
					return util.ReconcileWaitResult,
						util.PatchCondition(ctx, r, &rollouttrait, cpv1alpha1.ReconcileError(errors.Wrap(err, errFailGetControllerRevision)))
				}

				newRolloutHistory := extendoamdevv1alpha2.RolloutHistory{
					Revision:    cr.Revision,
					HistoryData: cr.Data,
				}

				rollouttrait.Status.RolloutHistory = append(rollouttrait.Status.RolloutHistory, newRolloutHistory)

				// update rollouttrait.status.currentWorkloadRef to new one
				rollouttrait.Status.CurrentWorkloadReference = rollouttrait.Spec.WorkloadReference

				if err := r.Status().Update(ctx, &rollouttrait); err != nil {
					r.Log.Error(err, "Failed to update rollouttrait status")
					return util.ReconcileWaitResult,
						util.PatchCondition(ctx, r, &rollouttrait, cpv1alpha1.ReconcileError(errors.Wrap(err, errFailUpdateStatus)))
				}
				// rollouttrait turn out Stable status, no more reconcile
				return ctrl.Result{}, util.PatchCondition(ctx, r, &rollouttrait, cpv1alpha1.ReconcileSuccess())

			} else {
				// if anyone is not ready
				// gradually scale up/down
				if err := r.scaleUpGradually(ctx, log, newUnderlyingDeployments, *targetReplica, batch.IntVal); err != nil {
					r.Log.Error(err, "Failed to scale up new wrokload")
					return util.ReconcileWaitResult,
						util.PatchCondition(ctx, r, &rollouttrait, cpv1alpha1.ReconcileError(errors.Wrap(err, errFailScaleUp)))
				}
				if err := r.scaleDownGradually(ctx, log, oldUnderlyingDeployments, 0, maxUnavailable.IntVal); err != nil {
					r.Log.Error(err, "Failed to scale down old wrokload")
					return util.ReconcileWaitResult,
						util.PatchCondition(ctx, r, &rollouttrait, cpv1alpha1.ReconcileError(errors.Wrap(err, errFailScaleDown)))
				}
				// reconcile after 5 seconds
				return ReconcileWaitWorkloadScale, nil
			}

		} else {
			//it's in stable status, nothing to do
			return ctrl.Result{}, nil
		}
	}
}

func (r *SimpleRolloutTraitReconciler) SetupWithManager(mgr ctrl.Manager) error {
	return ctrl.NewControllerManagedBy(mgr).
		For(&extendoamdevv1alpha2.SimpleRolloutTrait{}).
		Complete(r)
}
