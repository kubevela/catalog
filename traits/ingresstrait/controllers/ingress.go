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
	obj oam.Object, svcInfo *corev1alpha2.InternalBackend) (*corev1.Service, *v1beta1.Ingress, error) {
	t, ok := trait.(*corev1alpha2.IngressTrait)
	if !ok {
		return nil, nil, errors.New(errNotIngressTrait)
	}

	var svc *corev1.Service
	if svcInfo.ServiceName == "" {
		var err error
		svc, svcInfo, err = ServiceInjector(ctx, t, obj)
		if err != nil {
			return nil, nil, err
		}
		r.Log.Info("serviceInfo is nil, so we should create a service", "serviceInfo", svcInfo)
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
		},
	}

	for i, r := range t.Spec.Rules {
		ingress.Spec.Rules = append(ingress.Spec.Rules, v1beta1.IngressRule{
			Host: r.Host,
		})
		http := v1beta1.HTTPIngressRuleValue{}
		for j, p := range svcInfo.ServicePort {
			http.Paths = append(http.Paths, v1beta1.HTTPIngressPath{
				Path: r.Paths[j].Path,
				Backend: v1beta1.IngressBackend{
					ServiceName: svcInfo.ServiceName,
					ServicePort: p,
				},
			})
		}
		ingress.Spec.Rules[i].HTTP = &http
	}

	return svc, ingress, nil
}

func ServiceInjector(ctx context.Context, t *corev1alpha2.IngressTrait, obj oam.Object) (*corev1.Service, *corev1alpha2.InternalBackend, error) {
	var svcInfo corev1alpha2.InternalBackend

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
		},
	}

	// Determine whether the resource kind is Deployment or StatefulSet
	// If it's StatefulSet, service name must be same as StatefulSet.Spec.ServiceName
	if obj.GetObjectKind().GroupVersionKind().Kind == KindDeployment {
		var deploy appsv1.Deployment
		bts, _ := json.Marshal(obj)
		if err := json.Unmarshal(bts, &deploy); err != nil {
			return nil, nil, errors.Wrap(err, "Failed to covert an unstructured obj to a deployment")
		}

		for _, c := range deploy.Spec.Template.Spec.Containers {
			for _, p := range c.Ports {
				s.Spec.Ports = append(s.Spec.Ports, corev1.ServicePort{
					Name:       p.Name,
					Port:       p.ContainerPort,
					TargetPort: intstr.FromInt(int(p.ContainerPort)),
					Protocol:   p.Protocol,
				})
			}
		}

		s.Spec.Selector = deploy.Spec.Selector.MatchLabels
	} else if obj.GetObjectKind().GroupVersionKind().Kind == KindStatefulSet {
		var set appsv1.StatefulSet
		bts, _ := json.Marshal(obj)
		if err := json.Unmarshal(bts, &set); err != nil {
			return nil, nil, errors.Wrap(err, "Failed to convert an unstructured obj to a statefulset")
		}

		for _, c := range set.Spec.Template.Spec.Containers {
			for _, p := range c.Ports {
				s.Spec.Ports = append(s.Spec.Ports, corev1.ServicePort{
					Name:       p.Name,
					Port:       p.ContainerPort,
					TargetPort: intstr.FromInt(int(p.ContainerPort)),
					Protocol:   p.Protocol,
				})
			}
		}

		s.Spec.Selector = set.Spec.Selector.MatchLabels
		s.Name = set.Spec.ServiceName
	}

	for _, r := range t.Spec.Rules {
		length := len(s.Spec.Ports)
		for i, p := range r.Paths {
			// If workload is StatefulSet, s.Name should be statefulset.serviceName, we can't change it
			if p.Backend.ServiceName != "" && s.Name == t.GetName() {
				s.Name = p.Backend.ServiceName
			}
			if p.Backend.ServicePort.IntVal != 0 && i < length {
				s.Spec.Ports[i].Port = p.Backend.ServicePort.IntVal
			}
		}
	}

	// get serviceName and servicePorts information from service to ingress
	svcInfo = corev1alpha2.InternalBackend{}
	svcInfo.ServiceName = s.GetName()
	for _, p := range s.Spec.Ports {
		svcInfo.ServicePort = append(svcInfo.ServicePort, intstr.FromInt(int(p.Port)))
	}

	return s, &svcInfo, nil
}
