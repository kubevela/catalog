package controllers

import (
	"context"
	"encoding/json"
	"github.com/crossplane/oam-kubernetes-runtime/pkg/oam"
	corev1alpha2 "github.com/oam-dev/catalog/traits/ingresstrait/api/v1alpha2"
	"github.com/pkg/errors"
	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
	"k8s.io/api/networking/v1beta1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/util/intstr"
	"reflect"
)

// Reconcile error strings.
const (
	errNotIngressTrait = "object is not a ingress trait"
)

const (
	LabelKey        = "ingresstrait.oam.crossplane.io"
	KindStatefulSet = "StatefulSet"
	KindDeployment  = "Deployment"
)

var (
	serviceKind       = reflect.TypeOf(corev1.Service{}).Name()
	serviceAPIVersion = corev1.SchemeGroupVersion.String()

	ingressKind       = reflect.TypeOf(v1beta1.Ingress{}).Name()
	ingressAPIVersion = v1beta1.SchemeGroupVersion.String()
)

// IngressInjector adds a Ingress object for the resources observed in a workload translation.
func (r *IngressTraitReconciler) IngressInjector(ctx context.Context, trait oam.Trait,
	objs []oam.Object, svcInfo *v1beta1.IngressBackend) ([]oam.Object, error) {
	t, ok := trait.(*corev1alpha2.IngressTrait)
	if !ok {
		return nil, errors.New(errNotIngressTrait)
	}

	nilStruct := v1beta1.IngressBackend{}
	if *svcInfo == nilStruct {
		r.Log.Info("serviceInfo is nil, we'll create a service")
		var err error
		objs, svcInfo, err = ServiceInjector(ctx, t, objs)
		if err != nil {
			return nil, err
		}
	} else {
		r.Log.Info("serviceInfo is not nil", "serviceInfo", svcInfo)
	}

	ingress := &v1beta1.Ingress{
		TypeMeta: metav1.TypeMeta{
			Kind:       ingressKind,
			APIVersion: ingressAPIVersion,
		},
		ObjectMeta: metav1.ObjectMeta{
			Name:      t.GetName(),
			Namespace: t.GetNamespace(),
			Labels: map[string]string{
				LabelKey: string(t.GetUID()),
			},
		},
		Spec: v1beta1.IngressSpec{
			IngressClassName: t.Spec.IngressClassName,
			Backend:          t.Spec.DefaultBackend,
			TLS:              t.Spec.TLS,
			Rules: []v1beta1.IngressRule{
				{
					Host: t.Spec.Rules[0].Host,
					IngressRuleValue: v1beta1.IngressRuleValue{
						HTTP: &v1beta1.HTTPIngressRuleValue{
							Paths: []v1beta1.HTTPIngressPath{
								{
									Path:    t.Spec.Rules[0].Paths[0].Path,
									Backend: *svcInfo,
								},
							},
						},
					},
				},
			},
		},
	}

	objs = append(objs, ingress)

	return objs, nil
}

func ServiceInjector(ctx context.Context, t *corev1alpha2.IngressTrait, objs []oam.Object) ([]oam.Object, *v1beta1.IngressBackend, error) {
	var svcInfo v1beta1.IngressBackend

	for _, o := range objs {
		s := &corev1.Service{
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
				Ports: []corev1.ServicePort{},
				Type:  corev1.ServiceTypeLoadBalancer,
			},
		}

		// Determine whether the resource kind is Deployment or StatefulSet
		// If it's StatefulSet, service name must be same as StatefulSet.Spec.ServiceName
		if o.GetObjectKind().GroupVersionKind().Kind == KindDeployment {
			var deploy appsv1.Deployment
			bts, _ := json.Marshal(o)
			if err := json.Unmarshal(bts, &deploy); err != nil {
				return nil, nil, errors.Wrap(err, "Failed to covert an unstructured obj to a deployment")
			}

			if len(deploy.Spec.Template.Spec.Containers) < 1 {
				continue
			}

			if len(deploy.Spec.Template.Spec.Containers[0].Ports) > 0 {
				s.Spec.Ports = []corev1.ServicePort{
					{
						Name:       deploy.GetName(),
						Port:       deploy.Spec.Template.Spec.Containers[0].Ports[0].ContainerPort,
						TargetPort: intstr.FromInt(int(deploy.Spec.Template.Spec.Containers[0].Ports[0].ContainerPort)),
						Protocol:   corev1.ProtocolTCP,
					},
				}
			}

			s.Spec.Selector = deploy.Spec.Selector.MatchLabels
		} else if o.GetObjectKind().GroupVersionKind().Kind == KindStatefulSet {
			var set appsv1.StatefulSet
			bts, _ := json.Marshal(o)
			if err := json.Unmarshal(bts, &set); err != nil {
				return nil, nil, errors.Wrap(err, "Failed to convert an unstructured obj to a statefulset")
			}

			if len(set.Spec.Template.Spec.Containers) < 1 {
				continue
			}

			if len(set.Spec.Template.Spec.Containers[0].Ports) > 0 {
				s.Spec.Ports = []corev1.ServicePort{
					{
						Name:       set.GetName(),
						Port:       set.Spec.Template.Spec.Containers[0].Ports[0].ContainerPort,
						TargetPort: intstr.FromInt(int(set.Spec.Template.Spec.Containers[0].Ports[0].ContainerPort)),
						Protocol:   corev1.ProtocolTCP,
					},
				}
			}

			s.Spec.Selector = set.Spec.Selector.MatchLabels
			s.Name = set.Spec.ServiceName
		}

		svcInfo = v1beta1.IngressBackend{
			ServiceName: s.Name,
			ServicePort: intstr.FromInt(int(s.Spec.Ports[0].Port)),
		}

		objs = append(objs, s)

		break
	}

	return objs, &svcInfo, nil
}
