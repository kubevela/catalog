package controllers

import (
	corev1alpha2 "catalog/workloads/statefulsetworkload/api/v1alpha2"
	"context"
	"fmt"
	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
	apierrors "k8s.io/apimachinery/pkg/api/errors"
	"k8s.io/apimachinery/pkg/types"
	ctrl "sigs.k8s.io/controller-runtime"
	"sigs.k8s.io/controller-runtime/pkg/client"
)

const (
	KindStatefulSet = "StatefulSet"
)

// create a corresponding deployment
func (r *StatefulSetWorkloadReconciler) renderStatefulSet(ctx context.Context,
	workload *corev1alpha2.StatefulSetWorkload) (*appsv1.StatefulSet, error) {

	resources, err := Translator(ctx, workload)
	if err != nil {
		return nil, err
	}
	statefulset, ok := resources[0].(*appsv1.StatefulSet)
	if !ok {
		return nil, fmt.Errorf("internal error, statefulset is not redered correctly")
	}
	//the translator lib doesn't set the namespace
	statefulset.Namespace = workload.Namespace
	// k8s server-side patch complains if the protocol is not set
	for i := 0; i < len(statefulset.Spec.Template.Spec.Containers); i++ {
		for j := 0; j < len(statefulset.Spec.Template.Spec.Containers[i].Ports); j++ {
			if len(statefulset.Spec.Template.Spec.Containers[i].Ports[j].Protocol) == 0 {
				statefulset.Spec.Template.Spec.Containers[i].Ports[j].Protocol = corev1.ProtocolTCP
			}
		}
	}
	r.Log.Info(" rendered a statefulset", "statefulset", statefulset.Spec.Template.Spec)

	//set the controller reference so that we can watch this statefulset and it will be deleted automatically
	if err := ctrl.SetControllerReference(workload, statefulset, r.Scheme); err != nil {
		return nil, err
	}

	return statefulset, nil
}

// delete statefulsets/ that are not the same as the existing
func (r *StatefulSetWorkloadReconciler) cleanupResources(ctx context.Context,
	workload *corev1alpha2.StatefulSetWorkload, statefulsetUID *types.UID) error {
	log := r.Log.WithValues("gc statefulset", workload.Name)
	var statefulset appsv1.StatefulSet
	//var service
	for _, res := range workload.Status.Resources {
		uid := res.UID
		if res.Kind == KindStatefulSet && res.APIVersion == appsv1.SchemeGroupVersion.String() {
			if uid != *statefulsetUID {
				log.Info("Found an orphaned statefulset", "statefulset UID", *statefulsetUID, "orphaned UID", uid)
				sn := client.ObjectKey{Name: res.Name, Namespace: workload.Namespace}
				if err := r.Get(ctx, sn, &statefulset); err != nil {
					if apierrors.IsNotFound(err) {
						continue
					}
					return err
				}
				if err := r.Delete(ctx, &statefulset); err != nil {
					return err
				}
				log.Info("Removed an orphaned statefulset", "statefulset UID", *statefulsetUID, "orphaned UID", uid)
			}
		}
	}
	return nil
}
