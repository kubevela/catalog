/*


Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package controllers

import (
	"fmt"
	"testing"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	"k8s.io/apimachinery/pkg/api/resource"
	"k8s.io/apimachinery/pkg/runtime"
	"k8s.io/apimachinery/pkg/runtime/schema"

	"github.com/crossplane/crossplane-runtime/apis/core/v1alpha1"
	"github.com/crossplane/crossplane-runtime/pkg/test"
	"github.com/crossplane/oam-controllers/pkg/oam/util"
	oamcore "github.com/crossplane/oam-kubernetes-runtime/apis/core/v1alpha2"
	hpav1alpha2 "github.com/oam-dev/catalog/traits/hpatrait/api/v1alpha2"
	appsv1 "k8s.io/api/apps/v1"
	v1 "k8s.io/api/core/v1"
	metadatav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"
	runtimeschema "k8s.io/apimachinery/pkg/runtime/schema"
	ctrl "sigs.k8s.io/controller-runtime"
	logf "sigs.k8s.io/controller-runtime/pkg/log"
	"sigs.k8s.io/controller-runtime/pkg/reconcile"
)

func TestHPATraitController(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "HorizontalPodAutoscalerTrait Suite")
}

var _ = Describe("HPATrait Controller Test", func() {
	schema := runtime.NewScheme()
	oamcore.SchemeBuilder.AddToScheme(schema)
	hpav1alpha2.AddToScheme(schema)

	var (
		mclient    = test.NewMockClient()
		log        = ctrl.Log.WithName("hpatrait-test")
		reconciler = &HorizontalPodAutoscalerTraitReconciler{
			mclient,
			log,
			schema,
		}
		mockErr = fmt.Errorf("mocked error")
	)
	BeforeEach(func() {
		logf.Log.Info("Set up mock client before an test")
		mclient = test.NewMockClient()
		reconciler.Client = mclient
	})

	AfterEach(func() {
		logf.Log.Info("Clean up resources after an unit test")
	})

	Context("When client cannot get hpatrait", func() {
		It("returns empty result & error except NotFoundError", func() {
			mclient.MockGet = test.NewMockGetFn(mockErr)
			got, err := reconciler.Reconcile(reconcile.Request{})

			Expect(got).To(Equal(ctrl.Result{}))
			Expect(err).To(Equal(mockErr))
		})
	})

	Context("When reconciler cannot fetch workload", func() {
		It("retruns reconcile-wait result and non-nil error from fetchWorkload", func() {
			mclient.MockGet = test.NewMockGetFn(nil, func(o runtime.Object) error {
				if _, ok := o.(*hpav1alpha2.HorizontalPodAutoscalerTrait); ok {
					o = newMockHPATrait()
					return nil
				}
				if _, ok := o.(*unstructured.Unstructured); ok {
					return mockErr
				}
				return nil
			})

			mclient.MockStatusPatch = test.NewMockStatusPatchFn(mockErr)

			got, err := reconciler.Reconcile(reconcile.Request{})
			Expect(got).To(Equal(util.ReconcileWaitResult))
			Expect(err).ShouldNot(BeNil())
		})
	})

	Context("When DetermineWorkloadType raises error ", func() {
		It("returns reconcile-wait result and non-nil error", func() {
			mclient.MockGet = test.NewMockGetFn(nil, func(o runtime.Object) error {
				if _, ok := o.(*hpav1alpha2.HorizontalPodAutoscalerTrait); ok {
					o = newMockHPATrait()
					return nil
				}
				if _, ok := o.(*unstructured.Unstructured); ok {
					var unsupportWL unstructured.Unstructured
					unsupportWL.SetGroupVersionKind(runtimeschema.GroupVersionKind{
						Group:   "",
						Version: "",
						Kind:    "unknown",
					})
					o = &unsupportWL
					return nil
				}
				return nil
			})

			mclient.MockStatusPatch = test.NewMockStatusPatchFn(mockErr)

			got, err := reconciler.Reconcile(reconcile.Request{})
			Expect(got).To(Equal(util.ReconcileWaitResult))
			Expect(err).ShouldNot(BeNil())
		})

	})

	Context("When reconciler gets ContainerizedWorkload worload", func() {
		It("renders HPA", func() {
			mclient.MockGet = test.NewMockGetFn(nil, func(obj runtime.Object) error {
				if o, ok := obj.(*hpav1alpha2.HorizontalPodAutoscalerTrait); ok {
					*o = *newMockHPATrait()
				}
				if o, ok := obj.(*unstructured.Unstructured); ok {
					*o = *newMockContainerizedWorkload()
				}
				if o, ok := obj.(*oamcore.WorkloadDefinition); ok {
					*o = *newMockWorkloadDefition()
				}
				return nil
			})

			mclient.MockList = test.NewMockListFn(nil, func(obj runtime.Object) error {
				if _, ok := obj.(*unstructured.UnstructuredList); ok {
					o, _ := obj.(*unstructured.UnstructuredList)
					*o = *newMockUnstructuredList()
					return nil
				}
				return nil
			})

			mclient.MockPatch = test.NewMockPatchFn(nil)
			mclient.MockStatusUpdate = test.NewMockStatusUpdateFn(nil)
			mclient.MockDelete = test.NewMockDeleteFn(nil)

			got, err := reconciler.Reconcile(reconcile.Request{})
			Expect(got).To(Equal(reconcile.Result{}))
			Expect(err).Should(BeNil())
		})

	})

})

func newMockHPATrait() *hpav1alpha2.HorizontalPodAutoscalerTrait {
	var minReplicas, CPUUtilPerct *int32
	minReplicas = new(int32)
	CPUUtilPerct = new(int32)
	*minReplicas = 2
	*CPUUtilPerct = 50
	return &hpav1alpha2.HorizontalPodAutoscalerTrait{
		TypeMeta: metadatav1.TypeMeta{
			Kind:       "HorizontalPodAutoscalerTrait",
			APIVersion: "core.oam.dev/v1alpha2",
		},
		ObjectMeta: metadatav1.ObjectMeta{
			Name: "mockHPATrait",
		},
		Spec: hpav1alpha2.HorizontalPodAutoscalerTraitSpec{
			MinReplicas:                    minReplicas,
			MaxReplicas:                    5,
			TargetCPUUtilizationPercentage: CPUUtilPerct,
			WorkloadReference: v1alpha1.TypedReference{
				APIVersion: "",
				Kind:       "",
				Name:       "",
				UID:        "",
			},
		},
		Status: hpav1alpha2.HorizontalPodAutoscalerTraitStatus{
			ConditionedStatus: v1alpha1.ConditionedStatus{
				Conditions: nil,
			},
			Resources: nil,
		},
	}
}

func newMockContainerizedWorkload() *unstructured.Unstructured {
	r, _ := util.Object2Unstructured(&oamcore.ContainerizedWorkload{
		TypeMeta: metadatav1.TypeMeta{
			Kind:       "ContainerizedWorkload",
			APIVersion: "core.oam.dev/v1alpha2",
		},
		ObjectMeta: metadatav1.ObjectMeta{
			Name:         "cw",
			GenerateName: "",
			Namespace:    "ns",
			SelfLink:     "",
			UID:          "mockCWUID",
		},
		Spec: oamcore.ContainerizedWorkloadSpec{
			OperatingSystem: nil,
			CPUArchitecture: nil,
			Containers:      nil,
		},
		Status: oamcore.ContainerizedWorkloadStatus{
			ConditionedStatus: v1alpha1.ConditionedStatus{
				Conditions: nil,
			},
			Resources: []v1alpha1.TypedReference{
				{
					APIVersion: "apps/v1",
					Kind:       "Deployment",
					Name:       "mockDeploy",
					UID:        "",
				},
			},
		},
	})
	return r
}

func newMockWorkloadDefition() *oamcore.WorkloadDefinition {
	return &oamcore.WorkloadDefinition{
		TypeMeta: metadatav1.TypeMeta{
			Kind:       "WorkloadDefinition",
			APIVersion: "",
		},
		ObjectMeta: metadatav1.ObjectMeta{},
		Spec: oamcore.WorkloadDefinitionSpec{
			Reference: oamcore.DefinitionReference{
				Name: "",
			},
			ChildResourceKinds: []oamcore.ChildResourceKind{
				{
					APIVersion: "",
					Kind:       "",
					Selector: map[string]string{
						"": "",
					},
				},
			},
		},
	}
}

func newMockUnsupportWorkload() *unstructured.Unstructured {
	var uwl unstructured.Unstructured
	uwl.SetGroupVersionKind(schema.GroupVersionKind{
		Group:   "",
		Version: "",
		Kind:    "",
	})
	return &uwl
}

func newMockUnstructuredList() *unstructured.UnstructuredList {
	var deployment appsv1.Deployment
	deployment.APIVersion = "apps/v1"
	deployment.Kind = "Deployment"
	deployment.Spec.Template = v1.PodTemplateSpec{
		Spec: v1.PodSpec{
			Containers: []v1.Container{
				{
					Resources: v1.ResourceRequirements{
						Requests: v1.ResourceList{
							"CPU": resource.Quantity{},
						},
					},
				},
			},
		},
	}
	deployment.OwnerReferences = []metadatav1.OwnerReference{
		{
			APIVersion:         "",
			Kind:               "",
			Name:               "",
			UID:                "mockCWUID",
			Controller:         nil,
			BlockOwnerDeletion: nil,
		},
	}

	deployUnsctruct, _ := util.Object2Unstructured(deployment)

	return &unstructured.UnstructuredList{
		Object: map[string]interface{}{
			"": nil,
		},
		Items: []unstructured.Unstructured{*deployUnsctruct},
	}
}
