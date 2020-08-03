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
	"github.com/crossplane/crossplane-runtime/pkg/event"
	"github.com/pkg/errors"
	"k8s.io/client-go/discovery"

	cpv1alpha1 "github.com/crossplane/crossplane-runtime/apis/core/v1alpha1"
	"github.com/crossplane/oam-kubernetes-runtime/pkg/oam/util"
	"github.com/go-logr/logr"
	corev1alpha2 "github.com/oam-dev/catalog/traits/sidecartrait/api/v1alpha2"
	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"
	"k8s.io/apimachinery/pkg/runtime"
	"k8s.io/kubectl/pkg/util/openapi"
	ctrl "sigs.k8s.io/controller-runtime"
	"sigs.k8s.io/controller-runtime/pkg/client"
)

// Reconcile error strings.
const (
	errSidecarContainerNameDuplicate = "cannot deploy sidecar container, duplicate name"
	errSidecarVolumeNameDuplicate    = "cannot deploy sidecar volume, duplicate name"
	errPatchTobeSidecarResource      = "cannot patch the resource for containers"
	errSidecarResource               = "cannot sidecar the resourc"
	errQueryOpenAPI                  = "failed to query openAPI"
)

// SidecarTraitReconciler reconciles a SidecarTrait object
type SidecarTraitReconciler struct {
	client.Client
	Log    logr.Logger
	Scheme *runtime.Scheme
	Record event.Recorder
	discovery.DiscoveryClient
}

// +kubebuilder:rbac:groups=core.oam.dev,resources=sidecartraits,verbs=get;list;watch;create;update;patch;delete
// +kubebuilder:rbac:groups=core.oam.dev,resources=sidecartraits/status,verbs=get;update;patch
// +kubebuilder:rbac:groups=core.oam.dev,resources=statefulsetworkloads,verbs=get;list;watch
// +kubebuilder:rbac:groups=core.oam.dev,resources=statefulsetworkloads/status,verbs=get;
// +kubebuilder:rbac:groups=core.oam.dev,resources=containerizedworkloads,verbs=get;list;
// +kubebuilder:rbac:groups=core.oam.dev,resources=containerizedworkloads/status,verbs=get;
// +kubebuilder:rbac:groups=core.oam.dev,resources=workloaddefinitions,verbs=get;list;watch
// +kubebuilder:rbac:groups=apps,resources=statefulsets,verbs=get;list;watch;update;patch;delete
// +kubebuilder:rbac:groups=apps,resources=deployments,verbs=get;list;watch;update;patch;delete
// +kubebuilder:rbac:groups=apps,resources=replicasets,verbs=get;list;watch;update;patch;delete
// +kubebuilder:rbac:groups=apps,resources=pods,verbs=get;list;watch;update;patch;delete

func (r *SidecarTraitReconciler) Reconcile(req ctrl.Request) (ctrl.Result, error) {
	ctx := context.Background()
	log := r.Log.WithValues("sidecartrait", req.NamespacedName)

	var sidecartrait corev1alpha2.SidecarTrait
	if err := r.Get(ctx, req.NamespacedName, &sidecartrait); err != nil {
		return ctrl.Result{}, client.IgnoreNotFound(err)
	}

	log.Info("Get the Sidecar trait", "Spec: ", sidecartrait.Spec)

	// find the resource object to record the event to, default is the parent appConfig.
	eventObj, err := util.LocateParentAppConfig(ctx, r.Client, &sidecartrait)
	if eventObj == nil {
		// fallback to workload itself
		log.Error(err, "Failed to find the parent resource", "sidecar", sidecartrait.Name)
		eventObj = &sidecartrait
	}

	// Fetch the oam/workload this trait refers to
	workload, err := util.FetchWorkload(ctx, r, log, &sidecartrait)
	if err != nil {
		r.Record.Event(eventObj, event.Warning(util.ErrLocateWorkload, err))
		return ctrl.Result{}, err
	}

	// Fetch the child resources list from the corresponding workload
	resources, err := util.FetchWorkloadChildResources(ctx, log, r, workload)
	if err != nil {
		log.Error(err, "Error while fetching the workload child resources", "workload", workload.UnstructuredContent())
		r.Record.Event(eventObj, event.Warning(util.ErrFetchChildResources, err))
		return util.ReconcileWaitResult, util.PatchCondition(ctx, r, &sidecartrait, cpv1alpha1.ReconcileError(fmt.Errorf(util.ErrFetchChildResources)))
	}

	// include the workload itself if there is no child resources
	if len(resources) == 0 {
		resources = append(resources, workload)
	}

	//Sidecar the child resources that we know how to Sidecar
	result, err := r.sidecarResource(ctx, log, sidecartrait, resources)
	if err != nil {
		r.Record.Event(eventObj, event.Warning(errSidecarResource, err))
		return result, err
	}

	r.Record.Event(eventObj, event.Normal("Sidecar containers applied",
		fmt.Sprintf("Trait `%s` successfully sidecar a resource to", sidecartrait.Name)))

	return ctrl.Result{}, util.PatchCondition(ctx, r, &sidecartrait, cpv1alpha1.ReconcileSuccess())
}

func (r *SidecarTraitReconciler) sidecarResource(
	ctx context.Context, log logr.Logger, sidecartrait corev1alpha2.SidecarTrait, resources []*unstructured.Unstructured) (
	ctrl.Result, error) {

	// prepare for openApi schema check
	schemaDoc, err := r.DiscoveryClient.OpenAPISchema()
	if err != nil {
		return util.ReconcileWaitResult,
			util.PatchCondition(ctx, r, &sidecartrait, cpv1alpha1.ReconcileError(errors.Wrap(err, errQueryOpenAPI)))
	}
	document, err := openapi.NewOpenAPIData(schemaDoc)
	if err != nil {
		return util.ReconcileWaitResult,
			util.PatchCondition(ctx, r, &sidecartrait, cpv1alpha1.ReconcileError(errors.Wrap(err, errQueryOpenAPI)))
	}

	// deploy sidecar containers to resources
	found := false
	for _, res := range resources {
		log.Info("Get the resource the trait is going to modify", "resource name", res.GetName(), "UID", res.GetUID())
		combine := false
		resPatch := client.MergeFrom(res.DeepCopyObject())
		//Combine container
		if ok, containerFieldPath := locateContainersField(document, res); ok {
			resContainers, ok, err := unstructured.NestedSlice(res.Object, containerFieldPath...)
			if !ok || err != nil {
				log.Error(err, "Failed to patch a resource for containers")
				return util.ReconcileWaitResult,
					util.PatchCondition(ctx, r, &sidecartrait, cpv1alpha1.ReconcileError(errors.Wrap(err, errPatchTobeSidecarResource)))
			}

			containers := combineContainers(resContainers, sidecartrait.Spec.Container, log)
			err = unstructured.SetNestedField(res.Object, containers, containerFieldPath...)
			if err != nil {
				log.Error(err, "Failed to deploy sidecar to resource")
				return util.ReconcileWaitResult,
					util.PatchCondition(ctx, r, &sidecartrait, cpv1alpha1.ReconcileError(errors.Wrap(err, errPatchTobeSidecarResource)))
			}
			found = true
			combine = true
		}

		//Combine Volumes
		if ok, volumesFieldPath := locateVolumesField(document, res); ok {
			resVolumes, _, err := unstructured.NestedSlice(res.Object, volumesFieldPath...)
			if err != nil {
				log.Error(err, "Failed to patch a resource for volumes")
				return util.ReconcileWaitResult,
					util.PatchCondition(ctx, r, &sidecartrait, cpv1alpha1.ReconcileError(errors.Wrap(err, errPatchTobeSidecarResource)))
			}

			volumes := combineVolumes(resVolumes, sidecartrait.Spec.Volumes, log)
			err = unstructured.SetNestedField(res.Object, volumes, volumesFieldPath...)
			if err != nil {
				log.Error(err, "Failed to add volume to resource")
				return util.ReconcileWaitResult,
					util.PatchCondition(ctx, r, &sidecartrait, cpv1alpha1.ReconcileError(errors.Wrap(err, errPatchTobeSidecarResource)))
			}
			found = true
			combine = true
		}

		if combine {
			// merge patch to sidecar the resource
			if err := r.Patch(ctx, res, resPatch, client.FieldOwner(sidecartrait.GetUID())); err != nil {
				log.Error(err, "Failed to deploy sidecar to resource")
				return util.ReconcileWaitResult,
					util.PatchCondition(ctx, r, &sidecartrait, cpv1alpha1.ReconcileError(errors.Wrap(err, errSidecarResource)))
			}
			log.Info("Successfully deploy sidecar to resource", "resource GVK", res.GroupVersionKind().String(), "res UID", res.GetUID())
		}
	}
	if !found {
		log.Info("Cannot locate any resource", "total resources", len(resources))
		return util.ReconcileWaitResult,
			util.PatchCondition(ctx, r, &sidecartrait, cpv1alpha1.ReconcileError(fmt.Errorf(errSidecarResource)))
	}

	return ctrl.Result{}, nil
}

func (r *SidecarTraitReconciler) SetupWithManager(mgr ctrl.Manager) error {
	return ctrl.NewControllerManagedBy(mgr).
		For(&corev1alpha2.SidecarTrait{}).
		Complete(r)
}
