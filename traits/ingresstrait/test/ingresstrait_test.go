package test_test

import (
	"context"
	"github.com/crossplane/oam-controllers/pkg/oam/util"
	oamv1alpha2 "github.com/crossplane/oam-kubernetes-runtime/apis/core/v1alpha2"
	"github.com/oam-dev/catalog/traits/ingresstrait/api/v1alpha2"
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
	"k8s.io/api/networking/v1beta1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/runtime"
	"sigs.k8s.io/controller-runtime/pkg/client"
	logf "sigs.k8s.io/controller-runtime/pkg/log"
	"time"
)

var ctx = context.Background()
var namespace = "controller-test"
var lablel = map[string]string{"app": "test"}
var ns = corev1.Namespace{
	ObjectMeta: metav1.ObjectMeta{
		Name: namespace,
	},
}

var _ = Describe("IngressTrait", func() {
	It("create a Ingress for StatefulSet", func() {
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
				ServiceName: "test",
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

		appConfig := newMockAppConfigIngressTrait(componentName, traitName)
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
			Name:      "test",
			Namespace: namespace,
		}
		svc := &corev1.Service{}
		logf.Log.Info("Checking on service", "Key", svcObjectKey)
		Eventually(
			func() error {
				return k8sClient.Get(ctx, svcObjectKey, svc)
			},
			time.Second*15, time.Millisecond*500).Should(BeNil())

		// Verification
		By("Checking service is created")
		ingressObjectKey := client.ObjectKey{
			Name:      traitName,
			Namespace: namespace,
		}
		ingress := &v1beta1.Ingress{}
		logf.Log.Info("Checking on ingress", "Key", ingressObjectKey)
		Eventually(
			func() error {
				return k8sClient.Get(ctx, ingressObjectKey, ingress)
			},
			time.Second*15, time.Millisecond*500).Should(BeNil())
	})

	It("create a Ingress for ContainerizedWorkload", func() {
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
					{
						APIVersion: corev1.SchemeGroupVersion.String(),
						Kind:       util.KindService,
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

		appConfig := newMockAppConfigIngressTrait(comp.GetName(), traitName)
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
			Name:      wlInstanceName,
			Namespace: namespace,
		}
		service := &corev1.Service{}
		logf.Log.Info("Checking on service", "Key", svcObjectKey)
		Eventually(
			func() error {
				return k8sClient.Get(ctx, svcObjectKey, service)
			},
			time.Second*15, time.Millisecond*500).Should(BeNil())

		By("Checking ingress is created")
		ingressObjectKey := client.ObjectKey{
			Name:      traitName,
			Namespace: namespace,
		}
		ingress := &v1beta1.Ingress{}
		logf.Log.Info("Checking on ingress", "Key", ingressObjectKey)
		Eventually(
			func() error {
				return k8sClient.Get(ctx, ingressObjectKey, ingress)
			},
			time.Second*15, time.Millisecond*500).Should(BeNil())
	})
})

// Create IngressTrait CR and Applicationconfig
func newMockAppConfigIngressTrait(componentName string, traitName string) *oamv1alpha2.ApplicationConfiguration {
	// Create a IngressTrait CR
	itcr := v1alpha2.IngressTrait{
		ObjectMeta: metav1.ObjectMeta{
			Namespace: namespace,
			Name:      traitName,
		},
		Spec: v1alpha2.IngressTraitSpec{
			Rules: []v1alpha2.Rule{
				{
					Host: "nginx.oam.com",
					Paths: []v1alpha2.IngressPath{
						{
							Path: "/",
						},
					},
				},
			},
		},
	}
	// reflect trait gvk from scheme
	gvks, _, _ := scheme.ObjectKinds(&itcr)
	itcr.APIVersion = gvks[0].GroupVersion().String()
	itcr.Kind = gvks[0].Kind
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
								Object: &itcr,
							},
						},
					},
				},
			},
		},
	}
	return &appConfig
}
