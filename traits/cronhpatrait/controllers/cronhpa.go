package controllers

import (
	"context"
	"fmt"
	"reflect"

	corev1alpha2 "github.com/oam-dev/catalog/traits/cronhpatrait/api/v1alpha2"

	"github.com/AliyunContainerService/kubernetes-cronhpa-controller/pkg/apis/autoscaling/v1beta1"
	"github.com/crossplane/oam-kubernetes-runtime/pkg/oam"
	"github.com/pkg/errors"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

// Reconcile error strings.
const (
	errNotCronHPATrait = "object is not a cronHPA trait"
)

const (
	LabelKey = "cronhpatrait.oam.crossplane.io"
)

var (
	cronHPAKind       = reflect.TypeOf(v1beta1.CronHorizontalPodAutoscaler{}).Name()
	cronHPAAPIVersion = v1beta1.SchemeGroupVersion.String()
)

// CronHPAInjector adds a CronHPA object for the resources observed in a workload translation.
func (r *CronHPATraitReconciler) CronHPAInjector(ctx context.Context, trait oam.Trait,
	obj oam.Object) (*v1beta1.CronHorizontalPodAutoscaler, error) {
	t, ok := trait.(*corev1alpha2.CronHPATrait)
	if !ok {
		return nil, errors.New(errNotCronHPATrait)
	}
	workloadGvk := obj.GetObjectKind().GroupVersionKind()
	cronHPA := &v1beta1.CronHorizontalPodAutoscaler{
		TypeMeta: metav1.TypeMeta{
			Kind:       cronHPAKind,
			APIVersion: cronHPAAPIVersion,
		},
		ObjectMeta: metav1.ObjectMeta{
			Name:      t.GetName(),
			Namespace: t.GetNamespace(),
			Labels: map[string]string{
				LabelKey: string(t.GetUID()),
			},
		},
		Spec: v1beta1.CronHorizontalPodAutoscalerSpec{
			ExcludeDates: t.Spec.ExcludeDates,
			Jobs:         convertJobs(t.Spec.Jobs),
			ScaleTargetRef: v1beta1.ScaleTargetRef{
				ApiVersion: fmt.Sprintf("%s/%s", workloadGvk.Group, workloadGvk.Version),
				Kind:       workloadGvk.Kind,
				Name:       obj.GetName(),
			},
		},
		Status: v1beta1.CronHorizontalPodAutoscalerStatus{
			Conditions: []v1beta1.Condition{},
		},
	}

	return cronHPA, nil
}

func convertJobs(jobs []corev1alpha2.Job) []v1beta1.Job {
	targets := make([]v1beta1.Job, len(jobs))
	for i, job := range jobs {
		targets[i] = v1beta1.Job{
			Name:       job.Name,
			Schedule:   job.Schedule,
			RunOnce:    job.RunOnce,
			TargetSize: job.TargetSize,
		}
	}
	return targets
}
