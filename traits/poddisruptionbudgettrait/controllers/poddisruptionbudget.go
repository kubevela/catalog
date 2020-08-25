package controllers

import (
	"context"
	"github.com/crossplane/oam-kubernetes-runtime/pkg/oam"
	corev1alpha2 "github.com/oam-dev/catalog/traits/poddisruptionbudgettrait/api/v1alpha2"
	"github.com/pkg/errors"
	"k8s.io/api/policy/v1beta1"
	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"
	"reflect"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

// Reconcile error strings.
const (
	errNotPodDisruptionBudgetTrait = "object is not a podDisruptionBudget trait"
)

const (
	LabelKey = "poddisruptionbudgettrait.oam.crossplane.io"
)

var (
	podDisruptionBudgetKind       = reflect.TypeOf(v1beta1.PodDisruptionBudget{}).Name()
	podDisruptionBudgetAPIVersion = v1beta1.SchemeGroupVersion.String()
)

// PodDisruptionBudgetInjector adds a PodDisruptionBudget object for the resources observed in a workload translation.
func (r *PodDisruptionBudgetTraitReconciler) PodDisruptionBudgetInjector(ctx context.Context, trait oam.Trait, obj oam.Object) (*v1beta1.PodDisruptionBudget, error) {
	t, ok := trait.(*corev1alpha2.PodDisruptionBudgetTrait)
	if !ok {
		return nil, errors.New(errNotPodDisruptionBudgetTrait)
	}

	labelSelector := getLabelSelector(obj)

	pdb := &v1beta1.PodDisruptionBudget{
		TypeMeta: metav1.TypeMeta{
			Kind:       podDisruptionBudgetKind,
			APIVersion: podDisruptionBudgetAPIVersion,
		},
		ObjectMeta: metav1.ObjectMeta{
			Name:      t.GetName(),
			Namespace: t.GetNamespace(),
			Labels: map[string]string{
				LabelKey: string(t.GetUID()),
			},
		},
		Spec: v1beta1.PodDisruptionBudgetSpec{
			MinAvailable:   t.Spec.MinAvailable,
			MaxUnavailable: t.Spec.MaxUnavailable,
			Selector:       labelSelector,
		},
	}

	return pdb, nil
}

func getLabelSelector(obj oam.Object) *metav1.LabelSelector {
	res := obj.(*unstructured.Unstructured)
	content := res.UnstructuredContent()
	spec := content["spec"]
	if spec == nil {
		return nil
	}

	specMap := spec.(map[string]interface{})
	selector := specMap["selector"]
	if selector == nil {
		return nil
	}

	selectorMap := selector.(map[string]interface{})

	v, exist := selectorMap["matchLabels"]
	var matchLabels map[string]string
	if exist {
		m := v.(map[string]interface{})
		matchLabels = make(map[string]string, len(m))
		for k, v := range m {
			matchLabels[k] = v.(string)
		}
	}

	v, exist = selectorMap["matchExpressions"]
	var matchExpressions []metav1.LabelSelectorRequirement
	if exist {
		arr := v.([]interface{})
		matchExpressions = make([]metav1.LabelSelectorRequirement, len(arr))
		for i, lsr := range arr {
			matchExpressions[i] = lsr.(metav1.LabelSelectorRequirement)
		}
	}

	return &metav1.LabelSelector{
		MatchLabels:      matchLabels,
		MatchExpressions: matchExpressions,
	}
}
