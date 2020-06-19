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
	errLocateWorkload          = "cannot find workload"
	errLocateResources         = "cannot find resources"
	errLocateAvailableResouces = "cannot find available resources"
	errMarshalDeployment       = "cannot unmarshal deployment"
	errFailUpdateDeployment    = "failed to update deployment"
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
	if isNewleCreatedRolloutTrait(&rollouttrait) {
		//if it's new, set rollingupdate for deployment & update rollouttrait status
		workload, _, err := r.fetchWorkload(ctx, log, &rollouttrait)
		if err != nil {
			return ctrl.Result{}, err
		}
		underlyingDeployments, err := r.getUnderlyingDeployment(ctx, log, workload)
		if err != nil {
			return ctrl.Result{}, err
		}

		for _, deployment := range underlyingDeployments {
			if deployment.Status.AvailableReplicas != *deployment.Spec.Replicas {
				// initial setup is not ready, requeue to wait
				return reconcile.Result{Requeue: true}, nil
			}
			deployment.Spec.Replicas = targetReplica
			// gradually increase replicas for newly created rollout

			log.Info("Going to update Deployment", "deployment detail", deployment)
			applyOpts := []client.UpdateOption{client.FieldOwner(rollouttrait.Spec.WorkloadReference.UID)}
			if err := r.Update(ctx, deployment, applyOpts...); err != nil {
				r.Log.Error(err, "Failed to apply a deployment", "deployment spec", deployment.Spec)
				return util.ReconcileWaitResult,
					util.PatchCondition(ctx, r, &rollouttrait, cpv1alpha1.ReconcileError(errors.Wrap(err, errFailUpdateDeployment)))
			}
		}
		//update rollouttrait status
		rollouttrait.Status.CurrentWorkloadReference = rollouttrait.Spec.WorkloadReference
		if err := r.Status().Update(ctx, &rollouttrait); err != nil {
			r.Log.Error(err, "Failed to update rollouttrait status")
			return util.ReconcileWaitResult,
				util.PatchCondition(ctx, r, &rollouttrait, cpv1alpha1.ReconcileError(errors.Wrap(err, errFailUpdateStatus)))
		}
		return ctrl.Result{}, nil
	} else {
		//TODO if it's not new, then check whether it's in the middle of rollout
		if isUnderRollout(&rollouttrait) {
			//if it's under rollout
			//fetch two workloadInstances (spec.workloadRef & status.currentWorkloadRef)
			newWorkload, _, err := r.fetchWorkload(ctx, log, &rollouttrait)
			if err != nil {
				return ctrl.Result{}, err
			}

			newUnderlyingDeployments, err := r.getUnderlyingDeployment(ctx, log, newWorkload)
			if err != nil {
				return ctrl.Result{}, err
			}

			var oldWorkload unstructured.Unstructured
			oldWorkload.SetAPIVersion(rollouttrait.Status.CurrentWorkloadReference.APIVersion)
			oldWorkload.SetKind(rollouttrait.Status.CurrentWorkloadReference.Kind)

			wn := client.ObjectKey{Name: rollouttrait.Status.CurrentWorkloadReference.Name, Namespace: rollouttrait.GetNamespace()}

			if err := r.Get(ctx, wn, &oldWorkload); err != nil {
				log.Error(err, "Workload not find", "kind", rollouttrait.GetWorkloadReference().Kind,
					"workload name", rollouttrait.GetWorkloadReference().Name)
				return ctrl.Result{}, err
			}

			oldUnderlyingDeployments, err := r.getUnderlyingDeployment(ctx, log, &oldWorkload)

			// check whether both scale are ready
			if isScaleUpReady(newUnderlyingDeployments[0], *targetReplica) && isScaleDownReady(oldUnderlyingDeployments[0]) {
				// if both are ready
				// delete old workload instance
				if err := r.Delete(ctx, &oldWorkload); err != nil {
					log.Error(err, "Failed to delete old workload instance", "kind", oldWorkload.GetKind())
					return ctrl.Result{}, err
				}
				log.Info("Deleted old workload instance successfully", "kind", oldWorkload.GetKind())

				// update rollouttrait.status.currentWorkloadRef to new one
				rollouttrait.Status.CurrentWorkloadReference = rollouttrait.Spec.WorkloadReference
				if err := r.Status().Update(ctx, &rollouttrait); err != nil {
					r.Log.Error(err, "Failed to update rollouttrait status")
					return util.ReconcileWaitResult,
						util.PatchCondition(ctx, r, &rollouttrait, cpv1alpha1.ReconcileError(errors.Wrap(err, errFailUpdateStatus)))
				}
				// rollouttrait turn out Stable status, no more requeue
				return ctrl.Result{}, nil

			} else {
				// if anyone is not ready
				// gradually scale up/down
				r.scaleUpGradually(ctx, log, newUnderlyingDeployments[0], *targetReplica, batch.IntVal)
				r.scaleDownGradually(ctx, log, oldUnderlyingDeployments[0], 0, maxUnavailable.IntVal)
				// no status update
				// reconcile after 5 seconds
				// requeue after 5s to observe status transition
				return reconcile.Result{RequeueAfter: 5 * time.Second}, nil
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
