package controllers_test

import (
	"context"
	"fmt"
	"github.com/crossplane/crossplane-runtime/pkg/test"
	"github.com/crossplane/oam-controllers/pkg/oam/util"
	"github.com/crossplane/oam-kubernetes-runtime/apis/core/v1alpha2"
	"github.com/oam-dev/catalog/traits/serviceexpose/controllers"
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	"github.com/pkg/errors"
	appsv1 "k8s.io/api/apps/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"
	"k8s.io/apimachinery/pkg/runtime"
	"k8s.io/apimachinery/pkg/types"
	ctrl "sigs.k8s.io/controller-runtime"
	logf "sigs.k8s.io/controller-runtime/pkg/log"
	"testing"
)

func TestDetermineWorkloadType(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "DetermineWorkloadType Suite")
}

var _ = Describe("Helper", func() {
	// Test common variables
	ctx := context.Background()
	log := ctrl.Log.WithName("ServiceExposeReconciler")

	appsAPIVersion := appsv1.SchemeGroupVersion.String()
	unsupportedAPIVersion := "unsupported apiversion"
	namespace := "test"
	workloadName := "oamWorkload"
	workloadKind := "ContainerizedWorkload"
	workloadAPIVersion := v1alpha2.SchemeGroupVersion.String()
	workloadDefinitionName := "containerizedworkloads.core.oam.dev"
	var workloadUID types.UID = "oamWorkloadUID"
	// workload CR
	workload := v1alpha2.ContainerizedWorkload{
		ObjectMeta: metav1.ObjectMeta{
			Name:      workloadName,
			Namespace: namespace,
			UID:       workloadUID,
		},
		TypeMeta: metav1.TypeMeta{
			APIVersion: workloadAPIVersion,
			Kind:       workloadKind,
		},
	}
	unstructuredWorkload, _ := util.Object2Unstructured(workload)
	// deployment resources pointing to the workload
	deployment := unstructured.Unstructured{}
	deployment.SetOwnerReferences([]metav1.OwnerReference{
		{
			UID: workloadUID,
		},
	})
	// workload Definition
	workloadDefinition := v1alpha2.WorkloadDefinition{
		ObjectMeta: metav1.ObjectMeta{
			Name: workloadDefinitionName,
		},
		Spec: v1alpha2.WorkloadDefinitionSpec{
			Reference: v1alpha2.DefinitionReference{
				Name: workloadDefinitionName,
			},
		},
	}
	crkl := []v1alpha2.ChildResourceKind{
		{
			Kind:       "Deployment",
			APIVersion: "apps/v1",
		},
	}
	getErr := fmt.Errorf("get failed")
	// workload is k8s native resource
	var native unstructured.Unstructured
	native.SetAPIVersion(appsAPIVersion)
	// cannot get workload's apiversion
	var none unstructured.Unstructured
	none.SetAPIVersion("")
	// trait doesn't support this apiversion
	var unsupported unstructured.Unstructured
	unsupported.SetAPIVersion(unsupportedAPIVersion)

	BeforeEach(func() {
		logf.Log.Info("Set up resources before a unit test")
	})

	AfterEach(func() {
		logf.Log.Info("Clean up resources after a unit test")
	})

	It("Test determine workload type", func() {
		type fields struct {
			getFunc  test.ObjectFn
			listFunc test.ObjectFn
		}

		type args struct {
			w *unstructured.Unstructured
		}

		type want struct {
			res []*unstructured.Unstructured
			err error
		}

		cases := map[string]struct {
			fields fields
			args   args
			want   want
		}{
			"Workload deployment is K8S native resources": {
				args: args{
					w: &native,
				},
				want: want{
					res: []*unstructured.Unstructured{&native},
				},
			},
			"Workload is oam CR": {
				fields: fields{
					getFunc: func(obj runtime.Object) error {
						o, _ := obj.(*v1alpha2.WorkloadDefinition)
						w := workloadDefinition
						w.Spec.ChildResourceKinds = crkl
						*o = w
						return nil
					},
					listFunc: func(o runtime.Object) error {
						l := o.(*unstructured.UnstructuredList)
						if l.GetKind() != util.KindDeployment {
							return getErr
						}
						l.Items = []unstructured.Unstructured{deployment}
						return nil
					},
				},
				args: args{
					w: unstructuredWorkload,
				},
				want: want{
					res: []*unstructured.Unstructured{&deployment},
				},
			},
			"Failed to get the workload APIVersion": {
				args: args{
					w: &none,
				},
				want: want{
					err: errors.Errorf(fmt.Sprint("failed to get the workload APIVersion")),
				},
			},
			"This trait doesn't support this APIVersion": {
				args: args{
					w: &unsupported,
				},
				want: want{
					err: errors.Errorf(fmt.Sprint("This trait doesn't support this APIVersion", unsupported.GetAPIVersion())),
				},
			},
		}

		for name, tc := range cases {
			tclient := test.MockClient{
				MockGet:  test.NewMockGetFn(nil, tc.fields.getFunc),
				MockList: test.NewMockListFn(nil, tc.fields.listFunc),
			}

			got, err := controllers.DetermineWorkloadType(ctx, log, &tclient, tc.args.w)
			By(fmt.Sprint("Running test: ", name))
			Expect(tc.want.err).Should(util.BeEquivalentToError(err))
			Expect(tc.want.res).Should(Equal(got))
		}
	})
})
