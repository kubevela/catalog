package controllers

import (
	"context"
	"fmt"
	runtimev1alpha1 "github.com/crossplane/crossplane-runtime/apis/core/v1alpha1"
	"github.com/crossplane/crossplane-runtime/pkg/test"
	"github.com/crossplane/oam-controllers/pkg/oam/util"
	oamv1alpha2 "github.com/crossplane/oam-kubernetes-runtime/apis/core/v1alpha2"
	"github.com/crossplane/oam-kubernetes-runtime/pkg/oam/fake"
	"github.com/google/go-cmp/cmp"
	"github.com/oam-dev/catalog/traits/serviceexpose/api/v1alpha2"
	"github.com/pkg/errors"
	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"
	"k8s.io/apimachinery/pkg/runtime"
	"k8s.io/apimachinery/pkg/types"
	"reflect"
	ctrl "sigs.k8s.io/controller-runtime"
	"sigs.k8s.io/controller-runtime/pkg/client"
	"sigs.k8s.io/controller-runtime/pkg/manager"
	"sigs.k8s.io/controller-runtime/pkg/reconcile"
	"testing"
)

type svcParam func(*v1alpha2.ServiceExpose)

func withConditions(c ...runtimev1alpha1.Condition) svcParam {
	return func(svc *v1alpha2.ServiceExpose) {
		svc.SetConditions(c...)
	}
}

func svc(p ...svcParam) *v1alpha2.ServiceExpose {
	svc := &v1alpha2.ServiceExpose{}
	for _, fn := range p {
		fn(svc)
	}
	return svc
}

func TestServiceExposeReconciler_Reconcile(t *testing.T) {
	errBoom := errors.New("boom")
	log := ctrl.Log.WithName("serviceexppose")

	type args struct {
		m manager.Manager
	}
	type want struct {
		result reconcile.Result
		err    error
	}

	cases := map[string]struct {
		reason string
		args   args
		want   want
	}{
		"GetServiceExposeError": {
			reason: "Errors getting the ServiceExpose under reconciliation should be returned.",
			args: args{
				m: &fake.Manager{
					Client: &test.MockClient{
						MockGet: test.NewMockGetFn(errBoom),
					},
				},
			},
			want: want{
				err: errBoom,
			},
		},
	}

	for name, tc := range cases {
		t.Run(name, func(t *testing.T) {
			r := &ServiceExposeReconciler{
				Client: tc.args.m.GetClient(),
				Log:    log,
			}
			got, err := r.Reconcile(reconcile.Request{})

			if diff := cmp.Diff(tc.want.err, err, test.EquateErrors()); diff != "" {
				t.Errorf("\n%s\nr.Reconcile(...): -want error, +got error:\n%s", tc.reason, diff)
			}

			if diff := cmp.Diff(tc.want.result, got); diff != "" {
				t.Errorf("\n%s\nr.Reconcile(...): -want, +got:\n%s", tc.reason, diff)
			}
		})
	}
}

func TestServiceExposeReconciler_fetchWorkload(t *testing.T) {
	ctx := context.Background()
	log := ctrl.Log.WithName("ServiceExposeReconciler_fetchWorkload")
	reconciler := &ServiceExposeReconciler{
		Log: log,
	}
	serviceExpose := &v1alpha2.ServiceExpose{
		TypeMeta: metav1.TypeMeta{
			APIVersion: v1alpha2.GroupVersion.String(),
			Kind:       reflect.TypeOf(v1alpha2.ServiceExpose{}).Name(),
		},
		Spec: v1alpha2.ServiceExposeSpec{
			WorkloadReference: runtimev1alpha1.TypedReference{
				APIVersion: "apiversion",
				Kind:       "Kind",
			},
		},
	}
	wl := oamv1alpha2.ContainerizedWorkload{
		TypeMeta: metav1.TypeMeta{
			APIVersion: oamv1alpha2.SchemeGroupVersion.String(),
			Kind:       oamv1alpha2.ContainerizedWorkloadGroupKind,
		},
	}
	uwl, _ := util.Object2Unstructured(wl)
	workloadErr := fmt.Errorf("workload errr")
	updateErr := fmt.Errorf("update errr")

	type fields struct {
		getFunc         test.ObjectFn
		patchStatusFunc test.MockStatusPatchFn
	}
	type want struct {
		wl     *unstructured.Unstructured
		result ctrl.Result
		err    error
	}
	cases := map[string]struct {
		fields fields
		want   want
	}{
		"FetchWorkload fails when getWorkload fails": {
			fields: fields{
				getFunc: func(obj runtime.Object) error {
					return workloadErr
				},
				patchStatusFunc: func(_ context.Context, obj runtime.Object, patch client.Patch,
					_ ...client.PatchOption) error {
					return nil
				},
			},
			want: want{
				wl:     nil,
				result: util.ReconcileWaitResult,
				err:    nil,
			},
		},
		"FetchWorkload fail and update fails when getWorkload fails": {
			fields: fields{
				getFunc: func(obj runtime.Object) error {
					return workloadErr
				},
				patchStatusFunc: func(_ context.Context, obj runtime.Object, patch client.Patch,
					_ ...client.PatchOption) error {
					return updateErr
				},
			},
			want: want{
				wl:     nil,
				result: util.ReconcileWaitResult,
				err:    errors.Wrap(updateErr, util.ErrUpdateStatus),
			},
		},
		"FetchWorkload succeeds when getWorkload succeeds": {
			fields: fields{
				getFunc: func(obj runtime.Object) error {
					o, _ := obj.(*unstructured.Unstructured)
					*o = *uwl
					return nil
				},
				patchStatusFunc: func(_ context.Context, obj runtime.Object, patch client.Patch,
					_ ...client.PatchOption) error {
					return updateErr
				},
			},
			want: want{
				wl:     uwl,
				result: ctrl.Result{},
				err:    nil,
			},
		},
	}

	for name, tc := range cases {
		t.Run(name, func(t *testing.T) {
			tclient := test.NewMockClient()
			tclient.MockGet = test.NewMockGetFn(nil, tc.fields.getFunc)
			tclient.MockStatusPatch = tc.fields.patchStatusFunc
			reconciler.Client = tclient
			gotWL, result, err := reconciler.fetchWorkload(ctx, reconciler.Log, serviceExpose)
			if diff := cmp.Diff(tc.want.err, err, test.EquateErrors()); diff != "" {
				t.Errorf("\nfetchWorkload(...): -want error, +got error:\n%s", diff)
			}
			if diff := cmp.Diff(tc.want.result, result); diff != "" {
				t.Errorf("\nfetchWorkload(...): -want result, +got result:\n%s", diff)
			}
			if diff := cmp.Diff(tc.want.wl, gotWL); diff != "" {
				t.Errorf("\nfetchWorkload(...): -want workload, +got workload:\n%s", diff)
			}
		})
	}
}

type resourceModifier func(*unstructured.Unstructured)

func resWithAPIVersion(apiversion string) resourceModifier {
	return func(un *unstructured.Unstructured) {
		un.SetAPIVersion(apiversion)
	}
}

func resource(mod ...resourceModifier) *unstructured.Unstructured {
	deploy := &appsv1.Deployment{
		TypeMeta: metav1.TypeMeta{
			Kind: reflect.TypeOf(appsv1.Deployment{}).Name(),
		},
		ObjectMeta: metav1.ObjectMeta{
			Name: "test-resource",
			UID:  types.UID("test-uid"),
		},
		Spec: appsv1.DeploymentSpec{
			Selector: &metav1.LabelSelector{
				MatchLabels: map[string]string{
					"test": "test",
				},
			},
		},
	}
	res, _ := util.Object2Unstructured(deploy)

	for _, m := range mod {
		m(res)
	}

	return res
}

func TestServiceExposeReconciler_createService(t *testing.T) {
	ctx := context.Background()
	log := ctrl.Log.WithName("ServiceExposeReconciler_fetchWorkload")
	reconciler := &ServiceExposeReconciler{
		Log: log,
	}
	errBoom := errors.New("boom")
	errUnexpectedStatus := errors.New("unexpected status")

	serviceExpose := v1alpha2.ServiceExpose{
		TypeMeta: metav1.TypeMeta{
			APIVersion: v1alpha2.GroupVersion.String(),
			Kind:       reflect.TypeOf(v1alpha2.ServiceExpose{}).Name(),
		},
		ObjectMeta: metav1.ObjectMeta{
			Name:      traitName,
			Namespace: traitNamespace,
			Labels: map[string]string{
				LabelKey: traitUID,
			},
			UID: types.UID(traitUID),
		},
		Spec: v1alpha2.ServiceExposeSpec{
			WorkloadReference: runtimev1alpha1.TypedReference{
				APIVersion: "apiversion",
				Kind:       "Kind",
			},
		},
	}

	service := corev1.Service{
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
		Spec: corev1.ServiceSpec{
			Selector: map[string]string{
				"test": "test",
			},
		},
	}

	type fields struct {
		statusUpdate test.MockStatusUpdateFn
		scheme       *runtime.Scheme
	}
	type args struct {
		t   v1alpha2.ServiceExpose
		res []*unstructured.Unstructured
	}
	type want struct {
		svc *corev1.Service
		err error
	}

	cases := map[string]struct {
		fields fields
		args   args
		want   want
	}{
		"Resources is empty": {
			fields: fields{
				statusUpdate: test.NewMockStatusUpdateFn(nil, func(obj runtime.Object) error {
					want := svc(withConditions(runtimev1alpha1.ReconcileError(errors.Wrap(errBoom, errLocateResources))))
					if diff := cmp.Diff(want, obj.(*v1alpha2.ServiceExpose)); diff != "" {
						t.Errorf("\nclient.Status().Update(): -want, +got:\n%s", diff)
						return errUnexpectedStatus
					}
					return nil
				}),
			},
			args: args{
				t:   serviceExpose,
				res: nil,
			},
			want: want{
				err: nil,
			},
		},
		"Failed to render a service": {
			fields: fields{
				statusUpdate: test.NewMockStatusUpdateFn(nil, func(obj runtime.Object) error {
					want := svc(withConditions(runtimev1alpha1.ReconcileError(errors.Wrap(errBoom, errRenderService))))
					if diff := cmp.Diff(want, obj.(*v1alpha2.ServiceExpose)); diff != "" {
						t.Errorf("\nclient.Status().Update(): -want, +got:\n%s", diff)
					}
					return nil
				}),
				scheme: fake.SchemeWith(&corev1.Service{}),
			},
			args: args{
				t:   serviceExpose,
				res: []*unstructured.Unstructured{resource(resWithAPIVersion(appsAPIVersion))},
			},
			want: want{
				svc: nil,
				err: nil,
			},
		},
		"Successfully create a service": {
			fields: fields{
				scheme: fake.SchemeWith(&v1alpha2.ServiceExpose{}, &corev1.Service{}),
			},
			args: args{
				t:   serviceExpose,
				res: []*unstructured.Unstructured{resource(resWithAPIVersion(appsAPIVersion))},
			},
			want: want{
				svc: &service,
			},
		},
	}

	for name, tc := range cases {
		t.Run(name, func(t *testing.T) {
			tclient := test.NewMockClient()
			tclient.MockStatusUpdate = tc.fields.statusUpdate
			reconciler.Scheme = tc.fields.scheme
			reconciler.Client = tclient
			if name == "Successfully create a service" {
				if err := ctrl.SetControllerReference(&serviceExpose, &service, reconciler.Scheme); err != nil {
					t.FailNow()
				}
			}

			got, err := reconciler.createService(ctx, tc.args.t, tc.args.res)
			if diff := cmp.Diff(tc.want.err, err, test.EquateErrors()); diff != "" {
				t.Errorf("\ncreateService(...): -want error, +got error:\n%s", diff)
			}
			if diff := cmp.Diff(tc.want.svc, got); diff != "" {
				t.Errorf("\ncreateService(...): -want error, +got error:\n%s", diff)
			}
		})
	}
}
