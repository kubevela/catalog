package v1alpha2

import (
	runtimev1alpha1 "github.com/crossplane/crossplane-runtime/apis/core/v1alpha1"

	"github.com/crossplane/oam-kubernetes-runtime/pkg/oam"
)

var _ oam.Trait = &CronHPATrait{}

// GetCondition of this CronHPATrait.
func (tr *CronHPATrait) GetCondition(ct runtimev1alpha1.ConditionType) runtimev1alpha1.Condition {
	return tr.Status.GetCondition(ct)
}

// SetConditions of this CronHPATrait.
func (tr *CronHPATrait) SetConditions(c ...runtimev1alpha1.Condition) {
	tr.Status.SetConditions(c...)
}

// GetWorkloadReference of this CronHPATrait.
func (tr *CronHPATrait) GetWorkloadReference() runtimev1alpha1.TypedReference {
	return tr.Spec.WorkloadReference
}

// SetWorkloadReference of this CronHPATrait.
func (tr *CronHPATrait) SetWorkloadReference(r runtimev1alpha1.TypedReference) {
	tr.Spec.WorkloadReference = r
}
