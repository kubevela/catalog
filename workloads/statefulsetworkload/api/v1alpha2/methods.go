package v1alpha2

import (
	runtimev1alpha1 "github.com/crossplane/crossplane-runtime/apis/core/v1alpha1"
	"github.com/crossplane/oam-kubernetes-runtime/pkg/oam"
)

var _ oam.Workload = &StatefulSetWorkload{}

// GetCondition of this StatefulSetWorkload.
func (wl *StatefulSetWorkload) GetCondition(ct runtimev1alpha1.ConditionType) runtimev1alpha1.Condition {
	return wl.Status.GetCondition(ct)
}

// SetConditions of this StatefulSetWorkload.
func (wl *StatefulSetWorkload) SetConditions(c ...runtimev1alpha1.Condition) {
	wl.Status.SetConditions(c...)
}
