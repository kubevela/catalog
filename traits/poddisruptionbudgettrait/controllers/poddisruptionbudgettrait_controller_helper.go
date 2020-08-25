package controllers

import (
	"context"
	"github.com/crossplane/oam-kubernetes-runtime/pkg/oam"
	"k8s.io/api/policy/v1beta1"
	ctrl "sigs.k8s.io/controller-runtime"

	corev1alpha2 "github.com/oam-dev/catalog/traits/poddisruptionbudgettrait/api/v1alpha2"
)

/*
var (
	kindPodDisruptionBudget = reflect.TypeOf(v1beta1.PodDisruptionBudget{}).Name()
)*/

// create a podDisruptionBudget for the workload
func (r *PodDisruptionBudgetTraitReconciler) renderPodDisruptionBudget(ctx context.Context, trait *corev1alpha2.PodDisruptionBudgetTrait, obj oam.Object) (*v1beta1.PodDisruptionBudget, error) {
	// create a podDisruptionBudget
	pdb, err := r.PodDisruptionBudgetInjector(ctx, trait, obj)
	if err != nil {
		return nil, err
	}

	if err := ctrl.SetControllerReference(trait, pdb, r.Scheme); err != nil {
		return nil, err
	}

	return pdb, nil
}
