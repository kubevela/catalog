package test_test

import (
	"context"
	oamv1alpha2 "github.com/crossplane/oam-kubernetes-runtime/apis/core/v1alpha2"
	"github.com/oam-dev/catalog/traits/serviceexpose/api/v1alpha2"
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/runtime"
	"k8s.io/apimachinery/pkg/util/intstr"
	"sigs.k8s.io/controller-runtime/pkg/client"
	logf "sigs.k8s.io/controller-runtime/pkg/log"
	"time"

	"github.com/crossplane/oam-controllers/pkg/oam/util"
)

var ctx = context.Background()
var namespace = "controller-test"
var lablel = map[string]string{"app": "test"}
var ns = corev1.Namespace{
	ObjectMeta: metav1.ObjectMeta{
		Name: namespace,
	},
}

var _ = Describe("ServiceExpose", func() {
	It("create a Service for StatefulSet", func() {
		// create a workload definition
		wd := oamv1alpha2.WorkloadDefinition{
			ObjectMeta: metav1.ObjectMeta{
				Name: "statefulsets.apps",
			},
			Spec: oamv1alpha2.WorkloadDefinitionSpec{
				Reference: oamv1alpha2.DefinitionReference{
					Name: "statefulsets.apps",
				},
			},
		}
		logf.Log.Info("Creating workload definition")
		// For some reason, WorkloadDefinition is created as a Cluster scope object
		Expect(k8sClient.Create(ctx, &wd)).Should(SatisfyAny(BeNil(), &util.AlreadyExistMatcher{}))
		// create a workload CR
		wlInstanceName := "example-appconfig-workload"
		wl := appsv1.StatefulSet{
			ObjectMeta: metav1.ObjectMeta{
				Name:      wlInstanceName,
				Namespace: namespace,
			},
			Spec: appsv1.StatefulSetSpec{
				ServiceName: "sts-test",
				Selector: &metav1.LabelSelector{
					MatchLabels: lablel,
				},
				Template: corev1.PodTemplateSpec{
					ObjectMeta: metav1.ObjectMeta{
						Labels: lablel,
					},
					Spec: corev1.PodSpec{
						Containers: []corev1.Container{
							{
								Name:  "nginx",
								Image: "nginx:1.17",
								Ports: []corev1.ContainerPort{
									{
										ContainerPort: 80,
										Name:          "web",
									},
								},
							},
						},
					},
				},
			},
		}
		// reflect workload gvk from scheme
		gvks, _, _ := scheme.ObjectKinds(&wl)
		wl.APIVersion = gvks[0].GroupVersion().String()
		wl.Kind = gvks[0].Kind
		// Create a component definition
		componentName := "example-sts"
		comp := oamv1alpha2.Component{
			ObjectMeta: metav1.ObjectMeta{
				Name:      componentName,
				Namespace: namespace,
			},
			Spec: oamv1alpha2.ComponentSpec{
				Workload: runtime.RawExtension{
					Object: &wl,
				},
			},
		}
		logf.Log.Info("Creating component", "Name", comp.Name, "Namespace", comp.Namespace)
		Expect(k8sClient.Create(ctx, &comp)).Should(BeNil())

		traitName := "sts-test"

		appConfig := newMockAppConfigServiceExpose(componentName, traitName)
		logf.Log.Info("Creating application config", "Name", appConfig.Name, "Namespace", appConfig.Namespace)
		Expect(k8sClient.Create(ctx, appConfig)).Should(BeNil())
		// Verification
		By("Checking statefulset is created")
		stsObjectKey := client.ObjectKey{
			Name:      wlInstanceName,
			Namespace: namespace,
		}
		sts := &appsv1.StatefulSet{}
		logf.Log.Info("Checking on statefulset", "Key", stsObjectKey)
		Eventually(
			func() error {
				return k8sClient.Get(ctx, stsObjectKey, sts)
			},
			time.Second*15, time.Millisecond*500).Should(BeNil())

		// Verification
		By("Checking service is created")
		svcObjectKey := client.ObjectKey{
			Name:      traitName,
			Namespace: namespace,
		}
		svc := &corev1.Service{}
		logf.Log.Info("Checking on service", "Key", svcObjectKey)
		Eventually(
			func() error {
				return k8sClient.Get(ctx, svcObjectKey, svc)
			},
			time.Second*15, time.Millisecond*500).Should(BeNil())
	})

	It("create a Service for Deployment", func() {
		// create a workload definition
		wd := oamv1alpha2.WorkloadDefinition{
			ObjectMeta: metav1.ObjectMeta{
				Name: "deployments.apps",
			},
			Spec: oamv1alpha2.WorkloadDefinitionSpec{
				Reference: oamv1alpha2.DefinitionReference{
					Name: "deployments.apps",
				},
			},
		}
		logf.Log.Info("Creating workload definition")
		// For some reason, WorkloadDefinition is created as a Cluster scope object
		Expect(k8sClient.Create(ctx, &wd)).Should(SatisfyAny(BeNil(), &util.AlreadyExistMatcher{}))
		// create a workload CR
		wlInstanceName := "example-appconfig-deployment"
		wl := appsv1.Deployment{
			ObjectMeta: metav1.ObjectMeta{
				Name:      wlInstanceName,
				Namespace: namespace,
			},
			Spec: appsv1.DeploymentSpec{
				Selector: &metav1.LabelSelector{
					MatchLabels: lablel,
				},
				Template: corev1.PodTemplateSpec{
					ObjectMeta: metav1.ObjectMeta{
						Labels: lablel,
					},
					Spec: corev1.PodSpec{
						Containers: []corev1.Container{
							{
								Name:  "nginx",
								Image: "nginx:1.17",
								Ports: []corev1.ContainerPort{
									{
										ContainerPort: 80,
										Name:          "web",
									},
								},
							},
						},
					},
				},
			},
		}
		// reflect workload gvk from scheme
		gvks, _, _ := scheme.ObjectKinds(&wl)
		wl.APIVersion = gvks[0].GroupVersion().String()
		wl.Kind = gvks[0].Kind
		// Create a component definition
		componentName := "example-deploy"
		comp := oamv1alpha2.Component{
			ObjectMeta: metav1.ObjectMeta{
				Name:      componentName,
				Namespace: namespace,
			},
			Spec: oamv1alpha2.ComponentSpec{
				Workload: runtime.RawExtension{
					Object: &wl,
				},
			},
		}
		logf.Log.Info("Creating component", "Name", comp.Name, "Namespace", comp.Namespace)
		Expect(k8sClient.Create(ctx, &comp)).Should(BeNil())

		traitName := "deploy-test"

		appConfig := newMockAppConfigServiceExpose(componentName, traitName)
		logf.Log.Info("Creating application config", "Name", appConfig.Name, "Namespace", appConfig.Namespace)
		Expect(k8sClient.Create(ctx, appConfig)).Should(BeNil())
		// Verification
		By("Checking deployment is created")
		deployObjectKey := client.ObjectKey{
			Name:      wlInstanceName,
			Namespace: namespace,
		}
		deploy := &appsv1.Deployment{}
		logf.Log.Info("Checking on deployment", "Key", deployObjectKey)
		Eventually(
			func() error {
				return k8sClient.Get(ctx, deployObjectKey, deploy)
			},
			time.Second*15, time.Millisecond*500).Should(BeNil())

		// Verification
		By("Checking service is created")
		svcObjectKey := client.ObjectKey{
			Name:      traitName,
			Namespace: namespace,
		}
		svc := &corev1.Service{}
		logf.Log.Info("Checking on service", "Key", svcObjectKey)
		Eventually(
			func() error {
				return k8sClient.Get(ctx, svcObjectKey, svc)
			},
			time.Second*15, time.Millisecond*500).Should(BeNil())
	})

	It("create a service for ContainerizedWorkload", func() {
		// create a workload definition
		wd := oamv1alpha2.WorkloadDefinition{
			ObjectMeta: metav1.ObjectMeta{
				Name: "containerizedworkloads.core.oam.dev",
			},
			Spec: oamv1alpha2.WorkloadDefinitionSpec{
				Reference: oamv1alpha2.DefinitionReference{
					Name: "containerizedworkloads.core.oam.dev",
				},
				ChildResourceKinds: []oamv1alpha2.ChildResourceKind{
					{
						APIVersion: appsv1.SchemeGroupVersion.String(),
						Kind:       util.KindDeployment,
					},
				},
			},
		}
		logf.Log.Info("Creating ContainerizedWorkload workload definition")
		// For some reason, WorkloadDefinition is created as a Cluster scope object
		Expect(k8sClient.Create(ctx, &wd)).Should(SatisfyAny(BeNil(), &util.AlreadyExistMatcher{}))

		// define a workload CR
		wlInstanceName := "example-appconfig-workload"
		wl := oamv1alpha2.ContainerizedWorkload{
			ObjectMeta: metav1.ObjectMeta{
				Name:      wlInstanceName,
				Namespace: namespace,
			},
			Spec: oamv1alpha2.ContainerizedWorkloadSpec{
				Containers: []oamv1alpha2.Container{
					{
						Name:  "nginx",
						Image: "nginx:1.17",
						Ports: []oamv1alpha2.ContainerPort{
							{
								Name: "web",
								Port: 80,
							},
						},
					},
				},
			},
		}
		// reflect workload gvk from scheme
		gvks, _, _ := scheme.ObjectKinds(&wl)
		wl.APIVersion = gvks[0].GroupVersion().String()
		wl.Kind = gvks[0].Kind
		// Create a component definition
		comp := oamv1alpha2.Component{
			ObjectMeta: metav1.ObjectMeta{
				Name:      "example-component",
				Namespace: namespace,
			},
			Spec: oamv1alpha2.ComponentSpec{
				Workload: runtime.RawExtension{
					Object: &wl,
				},
			},
		}
		logf.Log.Info("Creating component", "Name", comp.Name, "Namespace", comp.Namespace)
		Expect(k8sClient.Create(ctx, &comp)).Should(BeNil())

		traitName := "example-appconfig-trait"

		appConfig := newMockAppConfigServiceExpose(comp.GetName(), traitName)
		logf.Log.Info("Creating application config", "Name", appConfig.Name, "Namespace", appConfig.Namespace)
		Expect(k8sClient.Create(ctx, appConfig)).Should(BeNil())

		// Verification
		By("Checking deployment is created")
		deployObjectKey := client.ObjectKey{
			Name:      wlInstanceName,
			Namespace: namespace,
		}
		deploy := &appsv1.Deployment{}
		logf.Log.Info("Checking on deployment", "Key", deployObjectKey)
		Eventually(
			func() error {
				return k8sClient.Get(ctx, deployObjectKey, deploy)
			},
			time.Second*15, time.Millisecond*500).Should(BeNil())

		By("Checking service is created")
		svcObjectKey := client.ObjectKey{
			Name:      traitName,
			Namespace: namespace,
		}
		service := &corev1.Service{}
		logf.Log.Info("Checking on service", "Key", svcObjectKey)
		Eventually(
			func() error {
				return k8sClient.Get(ctx, svcObjectKey, service)
			},
			time.Second*15, time.Millisecond*500).Should(BeNil())
	})
})

// Create ServiceExpose CR and Applicationconfig
func newMockAppConfigServiceExpose(componentName string, traitName string) *oamv1alpha2.ApplicationConfiguration {
	// Create a serviceexpose CR
	secr := v1alpha2.ServiceExpose{
		ObjectMeta: metav1.ObjectMeta{
			Namespace: namespace,
			Name:      traitName,
		},
		Spec: v1alpha2.ServiceExposeSpec{
			Template: corev1.ServiceSpec{
				Selector: lablel,
				Type:     corev1.ServiceTypeNodePort,
				Ports: []corev1.ServicePort{
					{
						Port:       80,
						Name:       "web",
						TargetPort: intstr.FromInt(80),
					},
				},
			},
		},
	}
	// reflect trait gvk from scheme
	gvks, _, _ := scheme.ObjectKinds(&secr)
	secr.APIVersion = gvks[0].GroupVersion().String()
	secr.Kind = gvks[0].Kind
	// Create application configuration
	appConfig := oamv1alpha2.ApplicationConfiguration{
		ObjectMeta: metav1.ObjectMeta{
			Name:      "appconfig" + componentName,
			Namespace: namespace,
		},
		Spec: oamv1alpha2.ApplicationConfigurationSpec{
			Components: []oamv1alpha2.ApplicationConfigurationComponent{
				{
					ComponentName: componentName,
					Traits: []oamv1alpha2.ComponentTrait{
						{
							Trait: runtime.RawExtension{
								Object: &secr,
							},
						},
					},
				},
			},
		},
	}
	return &appConfig
}
