package controllers

import (
	"context"
	"errors"
	"github.com/crossplane/oam-kubernetes-runtime/pkg/oam"
	corev1alpha2 "ingresstrait/api/v1alpha2"
	appsv1 "k8s.io/api/apps/v1"
	"k8s.io/api/networking/v1beta1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/util/intstr"
	"reflect"
)

// Reconcile error strings.
const (
	errNotIngressTrait = "object is not a service trait"
)

var (
	ingressKind       = reflect.TypeOf(v1beta1.Ingress{}).Name()
	ingressAPIVersion = v1beta1.SchemeGroupVersion.String()
)

// IngressInjector adds a Ingress object for the StatefulSet observed in a workload translation.
func IngressInjector(ctx context.Context, trait oam.Trait, objs []oam.Object) ([]oam.Object, error) {
	it, ok := trait.(*corev1alpha2.IngressTrait)
	if !ok {
		return nil, errors.New(errNotIngressTrait)
	}

	if objs == nil {
		return nil, nil
	}

	for _, o := range objs {
		set, ok := o.(*appsv1.StatefulSet)
		if !ok {
			continue
		}

		ingress := &v1beta1.Ingress{
			TypeMeta: metav1.TypeMeta{
				Kind:       ingressKind,
				APIVersion: ingressAPIVersion,
			},
			ObjectMeta: metav1.ObjectMeta{
				Name:      it.GetName(),
				Namespace: set.GetNamespace(),
			},
			Spec: v1beta1.IngressSpec{
				TLS: []v1beta1.IngressTLS{},
				Rules: []v1beta1.IngressRule{
					{
						IngressRuleValue: v1beta1.IngressRuleValue{
							HTTP: &v1beta1.HTTPIngressRuleValue{
								Paths: []v1beta1.HTTPIngressPath{
									{
										Path: "/",
										Backend: v1beta1.IngressBackend{
											ServiceName: set.GetName() + "-svc",
											ServicePort: intstr.FromInt(int(set.Spec.Template.Spec.Containers[0].Ports[0].ContainerPort)),
										},
									},
								},
							},
						},
					},
				},
			},
		}

		for i, t := range it.Spec.TLS {
			for _, h := range t.Hosts {
				ingress.Spec.TLS[i].Hosts = append(ingress.Spec.TLS[i].Hosts, h)
			}
			if t.SecretName != "" {
				ingress.Spec.TLS[i].SecretName = t.SecretName
			}
		}

		for j, r := range it.Spec.Rules {
			if r.Host != "" {
				ingress.Spec.Rules[j].Host = r.Host
			}
			for k, p := range r.IngressRuleValue.HTTP.Paths {
				if p.Path != "" {
					ingress.Spec.Rules[j].IngressRuleValue.HTTP.Paths[k].Path = p.Path
				}
				if p.PathType != nil {
					ingress.Spec.Rules[j].IngressRuleValue.HTTP.Paths[k].PathType = p.PathType
				}
				if p.Backend.ServiceName != "" {
					ingress.Spec.Rules[j].IngressRuleValue.HTTP.Paths[k].Backend.ServiceName = p.Backend.ServiceName
				}
				if p.Backend.ServicePort != (intstr.IntOrString{}) {
					ingress.Spec.Rules[j].IngressRuleValue.HTTP.Paths[k].Backend.ServicePort = p.Backend.ServicePort
				}
			}
		}

		objs = append(objs, ingress)
		break
	}

	return objs, nil
}
