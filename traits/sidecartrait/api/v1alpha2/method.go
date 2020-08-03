package v1alpha2

import (
	runtimev1alpha1 "github.com/crossplane/crossplane-runtime/apis/core/v1alpha1"

	"github.com/crossplane/oam-kubernetes-runtime/pkg/oam"
)

var _ oam.Trait = &SidecarTrait{}

// GetCondition of this SidecarTrait.
func (st *SidecarTrait) GetCondition(ct runtimev1alpha1.ConditionType) runtimev1alpha1.Condition {
	return st.Status.GetCondition(ct)
}

// SetConditions of this SidecarTrait.
func (st *SidecarTrait) SetConditions(c ...runtimev1alpha1.Condition) {
	st.Status.SetConditions(c...)
}

// GetWorkloadReference of this SidecarTrait.
func (st *SidecarTrait) GetWorkloadReference() runtimev1alpha1.TypedReference {
	return st.Spec.WorkloadReference
}

// SetWorkloadReference of this SidecarTrait.
func (st *SidecarTrait) SetWorkloadReference(r runtimev1alpha1.TypedReference) {
	st.Spec.WorkloadReference = r
}
