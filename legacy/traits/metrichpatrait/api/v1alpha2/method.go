package v1alpha2

import (
	runtimev1alpha1 "github.com/crossplane/crossplane-runtime/apis/core/v1alpha1"
	"github.com/crossplane/oam-kubernetes-runtime/pkg/oam"
)

var _ oam.Trait = &MetricHPATrait{}

// GetCondition of this MetricHPATrait.
func (mht *MetricHPATrait) GetCondition(ct runtimev1alpha1.ConditionType) runtimev1alpha1.Condition {
	return mht.Status.GetCondition(ct)
}

// SetConditions of this MetricHPATrait.
func (mht *MetricHPATrait) SetConditions(c ...runtimev1alpha1.Condition) {
	mht.Status.SetConditions(c...)
}

// GetWorkloadReference of this MetricHPATrait.
func (mht *MetricHPATrait) GetWorkloadReference() runtimev1alpha1.TypedReference {
	return mht.Spec.WorkloadReference
}

// SetWorkloadReference of this MetricHPATrait.
func (mht *MetricHPATrait) SetWorkloadReference(r runtimev1alpha1.TypedReference) {
	mht.Spec.WorkloadReference = r
}
