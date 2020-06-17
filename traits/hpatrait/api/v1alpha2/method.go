package v1alpha2

import (
	runtimev1alpha1 "github.com/crossplane/crossplane-runtime/apis/core/v1alpha1"

	"github.com/crossplane/oam-kubernetes-runtime/pkg/oam"
)

var _ oam.Trait = &HorizontalPodAutoscalerTrait{}

// GetCondition of this HorizontalPodAutoscalerTrait.
func (ht *HorizontalPodAutoscalerTrait) GetCondition(ct runtimev1alpha1.ConditionType) runtimev1alpha1.Condition {
	return ht.Status.GetCondition(ct)
}

// SetConditions of this HorizontalPodAutoscalerTrait.
func (ht *HorizontalPodAutoscalerTrait) SetConditions(c ...runtimev1alpha1.Condition) {
	ht.Status.SetConditions(c...)
}

// GetWorkloadReference of this HorizontalPodAutoscalerTrait.
func (ht *HorizontalPodAutoscalerTrait) GetWorkloadReference() runtimev1alpha1.TypedReference {
	return ht.Spec.WorkloadReference
}

// SetWorkloadReference of this HorizontalPodAutoscalerTrait.
func (ht *HorizontalPodAutoscalerTrait) SetWorkloadReference(r runtimev1alpha1.TypedReference) {
	ht.Spec.WorkloadReference = r
}
