package controllers

import (
	"context"
	"encoding/json"
	"github.com/crossplane/oam-kubernetes-runtime/pkg/oam"
	corev1alpha2 "github.com/oam-dev/catalog/traits/experimental/servicetrait/api/v1alpha2"
	"github.com/pkg/errors"
	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"reflect"
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

// ServiceInjector adds a Service object for the workload the trait is pointing to
func ServiceInjector(ctx context.Context, trait oam.Trait, objs []oam.Object) ([]oam.Object, error) {
	t, ok := trait.(*corev1alpha2.ServiceTrait)
	if !ok {
		return nil, errors.New(errNotServiceTrait)
	}

	if objs == nil {
		return nil, nil
	}

	for _, o := range objs {
		svc := &corev1.Service{
			TypeMeta: metav1.TypeMeta{
				Kind:       serviceKind,
				APIVersion: serviceAPIVersion,
			},
			ObjectMeta: metav1.ObjectMeta{
				Name:      t.GetName(),
				Namespace: t.GetNamespace(),
				Labels: map[string]string{
					LabelKey: string(t.GetUID()),
				},
			},
			Spec: corev1.ServiceSpec{
				Ports:                    t.Spec.Template.Ports,
				ClusterIP:                t.Spec.Template.ClusterIP,
				Type:                     t.Spec.Template.Type,
				ExternalIPs:              t.Spec.Template.ExternalIPs,
				SessionAffinity:          t.Spec.Template.SessionAffinity,
				LoadBalancerIP:           t.Spec.Template.LoadBalancerIP,
				LoadBalancerSourceRanges: t.Spec.Template.LoadBalancerSourceRanges,
				ExternalName:             t.Spec.Template.ExternalName,
				ExternalTrafficPolicy:    t.Spec.Template.ExternalTrafficPolicy,
				HealthCheckNodePort:      t.Spec.Template.HealthCheckNodePort,
				PublishNotReadyAddresses: t.Spec.Template.PublishNotReadyAddresses,
				SessionAffinityConfig:    t.Spec.Template.SessionAffinityConfig,
				IPFamily:                 t.Spec.Template.IPFamily,
				TopologyKeys:             t.Spec.Template.TopologyKeys,
			},
		}

		// Determine whether the resource kind is Deployment or StatefulSet
		// If it's StatefulSet, service name must be same as StatefulSet.Spec.ServiceName
		if o.GetObjectKind().GroupVersionKind().Kind == KindDeployment {
			var deploy appsv1.Deployment
			bts, _ := json.Marshal(o)
			if err := json.Unmarshal(bts, &deploy); err != nil {
				return nil, errors.Wrap(err, "Failed to covert an unstructured obj to a deployment")
			}
			svc.Spec.Selector = deploy.Spec.Selector.MatchLabels
		} else if o.GetObjectKind().GroupVersionKind().Kind == KindStatefulSet {
			var set appsv1.StatefulSet
			bts, _ := json.Marshal(o)
			if err := json.Unmarshal(bts, &set); err != nil {
				return nil, errors.Wrap(err, "Failed to convert an unstructured obj to a statefulset")
			}
			svc.Spec.Selector = set.Spec.Selector.MatchLabels
			svc.Name = set.Spec.ServiceName
		}

		objs = append(objs, svc)
		break
	}

	return objs, nil
}
