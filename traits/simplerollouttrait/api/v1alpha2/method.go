package v1alpha2

import (
	runtimev1alpha1 "github.com/crossplane/crossplane-runtime/apis/core/v1alpha1"

	"github.com/crossplane/oam-kubernetes-runtime/pkg/oam"
)

var _ oam.Trait = &SimpleRolloutTrait{}

// GetCondition of this SimpleRolloutTrait.
func (rt *SimpleRolloutTrait) GetCondition(ct runtimev1alpha1.ConditionType) runtimev1alpha1.Condition {
	return rt.Status.GetCondition(ct)
}

// SetConditions of this SimpleRolloutTrait.
func (rt *SimpleRolloutTrait) SetConditions(c ...runtimev1alpha1.Condition) {
	rt.Status.SetConditions(c...)
}

// GetWorkloadReference of this SimpleRolloutTrait.
func (rt *SimpleRolloutTrait) GetWorkloadReference() runtimev1alpha1.TypedReference {
	return rt.Spec.WorkloadReference
}

// SetWorkloadReference of this SimpleRolloutTrait.
func (rt *SimpleRolloutTrait) SetWorkloadReference(r runtimev1alpha1.TypedReference) {
	rt.Spec.WorkloadReference = r
}
