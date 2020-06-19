package controllers

import (
	"context"
	"github.com/crossplane/crossplane-runtime/pkg/test"
	"github.com/crossplane/oam-kubernetes-runtime/pkg/oam"
	"github.com/crossplane/oam-kubernetes-runtime/pkg/oam/fake"
	"github.com/google/go-cmp/cmp"
	"github.com/oam-dev/catalog/traits/serviceexpose/api/v1alpha2"
	"github.com/pkg/errors"
	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/types"
	"reflect"
	"testing"
)

var (
	workloadName      = "test-workload"
	workloadNamespace = "test-namespace"
	workloadUID       = "a-very-unique-identifier-workload"

	traitName      = "test-trait"
	traitNamespace = "test-namespace"
	traitUID       = "a-very-unique-identifier-trait"

	workloadLabelKey = "test-labelkey"
	serviceName      = "test-serviceName"
)

var (
	deploymentKind       = reflect.TypeOf(appsv1.Deployment{}).Name()
	deploymentAPIVersion = appsv1.SchemeGroupVersion.String()

	statefulsetKind       = reflect.TypeOf(appsv1.StatefulSet{}).Name()
	statefulsetAPIVersion = appsv1.SchemeGroupVersion.String()
)

type serviceModifier func(*corev1.Service)

func sWithDeployment() serviceModifier {
	return func(s *corev1.Service) {
		s.Spec.Selector = map[string]string{
			workloadLabelKey: workloadUID,
		}
	}
}

func sWithStatefulSet(name string) serviceModifier {
	return func(s *corev1.Service) {
		s.Spec.Selector = map[string]string{
			workloadLabelKey: workloadUID,
		}
		s.Name = name
	}
}

func service(mod ...serviceModifier) *corev1.Service {
	s := &corev1.Service{
		TypeMeta: metav1.TypeMeta{
			Kind:       serviceKind,
			APIVersion: serviceAPIVersion,
		},
		ObjectMeta: metav1.ObjectMeta{
			Name:      traitName,
			Namespace: traitNamespace,
			Labels: map[string]string{
				LabelKey: traitUID,
			},
		},
	}

	for _, m := range mod {
		m(s)
	}

	return s
}

type deploymentModifier func(*appsv1.Deployment)

func deployment(mod ...deploymentModifier) *appsv1.Deployment {
	d := &appsv1.Deployment{
		TypeMeta: metav1.TypeMeta{
			Kind:       deploymentKind,
			APIVersion: deploymentAPIVersion,
		},
		ObjectMeta: metav1.ObjectMeta{
			Name:      workloadName,
			Namespace: workloadNamespace,
		},
		Spec: appsv1.DeploymentSpec{
			Selector: &metav1.LabelSelector{
				MatchLabels: map[string]string{
					workloadLabelKey: workloadUID,
				},
			},
			Template: corev1.PodTemplateSpec{
				ObjectMeta: metav1.ObjectMeta{
					Labels: map[string]string{
						workloadLabelKey: workloadUID,
					},
				},
			},
		},
	}

	for _, m := range mod {
		m(d)
	}

	return d
}

type statefulsetModifier func(*appsv1.StatefulSet)

func stsWithServiceName(name string) statefulsetModifier {
	return func(sts *appsv1.StatefulSet) {
		sts.Spec.ServiceName = name
	}
}

func statefulset(mod ...statefulsetModifier) *appsv1.StatefulSet {
	sts := &appsv1.StatefulSet{
		TypeMeta: metav1.TypeMeta{
			Kind:       statefulsetKind,
			APIVersion: statefulsetAPIVersion,
		},
		ObjectMeta: metav1.ObjectMeta{
			Name:      workloadName,
			Namespace: workloadNamespace,
		},
		Spec: appsv1.StatefulSetSpec{
			Selector: &metav1.LabelSelector{
				MatchLabels: map[string]string{
					workloadLabelKey: workloadUID,
				},
			},
			Template: corev1.PodTemplateSpec{
				ObjectMeta: metav1.ObjectMeta{
					Labels: map[string]string{
						workloadLabelKey: workloadUID,
					},
				},
			},
		},
	}

	for _, m := range mod {
		m(sts)
	}

	return sts
}

func TestServiceInjector(t *testing.T) {
	type args struct {
		t oam.Trait
		o []oam.Object
	}

	type want struct {
		result []oam.Object
		err    error
	}

	cases := map[string]struct {
		reason string
		args   args
		want   want
	}{
		"NilObject": {
			reason: "Nil object should immediately return nil.",
			args: args{
				t: &v1alpha2.ServiceExpose{},
				o: nil,
			},
			want: want{},
		},
		"ErrorTraitNotServiceExpose": {
			reason: "Trait passed to modifier that is not a ServiceExpose should return error.",
			args: args{
				t: &fake.Trait{},
				o: []oam.Object{},
			},
			want: want{err: errors.New(errNotServiceExpose)},
		},
		"SuccessfulInjectServiceForDeployment": {
			reason: "A Deployment should have a service whose selector is same as it's MatchLabels.",
			args: args{
				t: &v1alpha2.ServiceExpose{
					ObjectMeta: metav1.ObjectMeta{
						Name:      traitName,
						Namespace: traitNamespace,
						UID:       types.UID(traitUID),
					},
				},
				o: []oam.Object{deployment()},
			},
			want: want{result: []oam.Object{
				deployment(),
				service(sWithDeployment()),
			}},
		},
		"SuccessfulInjectServiceForStatefulSet": {
			reason: "A StatefulSet should have a service whose selector and name are same as it's MatchLabels and ServiceName.",
			args: args{
				t: &v1alpha2.ServiceExpose{
					ObjectMeta: metav1.ObjectMeta{
						Name:      traitName,
						Namespace: traitNamespace,
						UID:       types.UID(traitUID),
					},
				},
				o: []oam.Object{statefulset(stsWithServiceName(serviceName))},
			},
			want: want{result: []oam.Object{
				statefulset(stsWithServiceName(serviceName)),
				service(sWithStatefulSet(serviceName)),
			}},
		},
	}

	for name, tc := range cases {
		t.Run(name, func(t *testing.T) {
			r, err := ServiceInjector(context.Background(), tc.args.t, tc.args.o)

			if diff := cmp.Diff(tc.want.err, err, test.EquateErrors()); diff != "" {
				t.Errorf("\nReason: %s\nServiceInjector(...): -want error, +got error:\n%s", tc.reason, diff)
			}

			if diff := cmp.Diff(tc.want.result, r); diff != "" {
				t.Errorf("\nReason: %s\nServiceInjector(...): -want, +got:\n%s", tc.reason, diff)
			}
		})
	}
}
