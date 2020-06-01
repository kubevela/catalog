package controllers

import (
	"context"
	"errors"
	"github.com/crossplane/oam-kubernetes-runtime/pkg/oam"
	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/util/intstr"
	"reflect"
	corev1alpha2 "servicetrait/api/v1alpha2"
)

// Reconcile error strings.
const (
	errNotServiceTrait = "object is not a service trait"
)

const LabelKey = "servicetrait.oam.crossplane.io"

var (
	serviceKind       = reflect.TypeOf(corev1.Service{}).Name()
	serviceAPIVersion = corev1.SchemeGroupVersion.String()
)

// ServiceInjector adds a Service object for the first Port on the first
// Container for the first Deployment observed in a workload translation.
func ServiceInjector(ctx context.Context, trait oam.Trait, objs []oam.Object) ([]oam.Object, error) {
	t, ok := trait.(*corev1alpha2.ServiceTrait)
	if !ok {
		return nil, errors.New(errNotServiceTrait)
	}

	if objs == nil {
		return nil, nil
	}

	for _, o := range objs {
		set, ok := o.(*appsv1.StatefulSet)
		if !ok {
			continue
		}

		// We don't add a Service if there are no containers for the StatefulSet.
		// This should never happen in practice.
		if len(set.Spec.Template.Spec.Containers) < 1 {
			continue
		}

		svc := &corev1.Service{
			TypeMeta: metav1.TypeMeta{
				Kind:       serviceKind,
				APIVersion: serviceAPIVersion,
			},
			ObjectMeta: metav1.ObjectMeta{
				Name:      set.GetName() + "-svc",
				Namespace: set.GetNamespace(),
				Labels: map[string]string{
					LabelKey: string(t.GetUID()),
				},
			},
			Spec: corev1.ServiceSpec{
				Selector: set.Spec.Selector.MatchLabels,
				Ports:    []corev1.ServicePort{},
			},
		}

		if t.Spec.Type != "" {
			svc.Spec.Type = t.Spec.Type
		} else {
			svc.Spec.Type = corev1.ServiceTypeLoadBalancer
		}

		if t.Spec.ClusterIP != "" {
			svc.Spec.ClusterIP = t.Spec.ClusterIP
		}

		if t.Spec.ExternalName != "" {
			svc.Spec.ExternalName = t.Spec.ExternalName
		}

		// We only add a single Service for the StatefulSet, even if multiple
		// ports or no ports are defined on the first container. This is to
		// exclude the need for implementing garbage collection in the
		// short-term in the case that ports are modified after creation.
		if len(set.Spec.Template.Spec.Containers[0].Ports) > 0 {
			svc.Spec.Ports = []corev1.ServicePort{
				{
					Name:       set.GetName(),
					Port:       set.Spec.Template.Spec.Containers[0].Ports[0].ContainerPort,
					TargetPort: intstr.FromInt(int(set.Spec.Template.Spec.Containers[0].Ports[0].ContainerPort)),
				},
			}
			if t.Spec.Ports.Port != 0 {
				svc.Spec.Ports[0].Port = t.Spec.Ports.Port
			}
			if t.Spec.Ports.NodePort != 0 {
				svc.Spec.Ports[0].NodePort = t.Spec.Ports.NodePort
			}
		}
		objs = append(objs, svc)
		break
	}

	return objs, nil
}
