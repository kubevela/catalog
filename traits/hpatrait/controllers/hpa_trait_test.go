package controllers

import (
	"fmt"
	"time"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"

	oamv1alpha2 "github.com/crossplane/oam-kubernetes-runtime/apis/core/v1alpha2"
	appsv1 "k8s.io/api/apps/v1"
	autoscalingv1 "k8s.io/api/autoscaling/v1"
	corev1 "k8s.io/api/core/v1"
	resource "k8s.io/apimachinery/pkg/api/resource"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/runtime"
	"sigs.k8s.io/controller-runtime/pkg/client"
	logf "sigs.k8s.io/controller-runtime/pkg/log"

	"github.com/crossplane/oam-controllers/pkg/oam/util"
	coreoamdevv1alpha2 "github.com/oam-dev/catalog/traits/hpatrait/api/v1alpha2"
)

var _ = Describe("HPA Trait", func() {
	// ctx := context.Background()
	// // lablel := map[string]string{"app": "test"}
	// ns := corev1.Namespace{
	//     ObjectMeta: metav1.ObjectMeta{
	//         Name: namespace,
	//         // Labels: lablel,
	//     },
	// }
	// BeforeEach(func() {
	//     logf.Log.Info("Start to run a test, clean up previous resources")
	//     // delete the namespace with all its resources
	//     Expect(k8sClient.Delete(ctx, &ns, client.PropagationPolicy(metav1.DeletePropagationForeground))).
	//         Should(SatisfyAny(BeNil(), &util.NotFoundMatcher{}))
	//     logf.Log.Info("make sure all the resources are removed")
	//     objectKey := client.ObjectKey{
	//         Name: namespace,
	//     }
	//     res := &corev1.Namespace{}
	//     Eventually(
	//         // gomega has a bug that can't take nil as the actual input, so has to make it a func
	//         func() error {
	//             return k8sClient.Get(ctx, objectKey, res)
	//         },
	//         time.Second*30, time.Millisecond*500).Should(&util.NotFoundMatcher{})
	//     logf.Log.Info(fmt.Sprintf("namespace %v", res))
	//     // recreate it
	//     Eventually(
	//         func() error {
	//             return k8sClient.Create(ctx, &ns)
	//         },
	//         time.Second*3, time.Millisecond*300).Should(SatisfyAny(BeNil(), &util.AlreadyExistMatcher{}))
	//
	//     // Create HPA trait definition
	//     mt := oamv1alpha2.TraitDefinition{
	//         ObjectMeta: metav1.ObjectMeta{
	//             Name: "horizontalpodautoscalertraits.core.oam.dev",
	//         },
	//         Spec: oamv1alpha2.TraitDefinitionSpec{
	//             Reference: oamv1alpha2.DefinitionReference{
	//                 Name: "horizontalpodautoscalertraits.core.oam.dev",
	//             },
	//         },
	//     }
	//     logf.Log.Info("Creating trait definition")
	//     // For some reason, traitDefinition is created as a Cluster scope object
	//     Expect(k8sClient.Create(ctx, &mt)).Should(SatisfyAny(BeNil(), &util.AlreadyExistMatcher{}))
	// })
	// AfterEach(func() {
	//     logf.Log.Info("Clean up resources")
	//     // delete the namespace with all its resources
	//     Expect(k8sClient.Delete(ctx, &ns, client.PropagationPolicy(metav1.DeletePropagationForeground))).Should(BeNil())
	// })

	It("apply an application config with ContainerizedWorkload component", func() {
		// create a workload definition
		wd := oamv1alpha2.WorkloadDefinition{
			ObjectMeta: metav1.ObjectMeta{
				Name: "containerizedworkloads.core.oam.dev",
				// Labels: lablel,
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

		// define workload instance
		wlInstanceName := "php-apache"
		wl := oamv1alpha2.ContainerizedWorkload{
			ObjectMeta: metav1.ObjectMeta{
				Namespace: namespace,
				Name:      wlInstanceName,
			},
			Spec: oamv1alpha2.ContainerizedWorkloadSpec{
				Containers: []oamv1alpha2.Container{
					{
						Name:  wlInstanceName,
						Image: "k8s.gcr.io/hpa-example",
						Ports: []oamv1alpha2.ContainerPort{
							{
								Name: "pa",
								Port: 80,
							},
						},
						Resources: &oamv1alpha2.ContainerResources{
							CPU: oamv1alpha2.CPUResources{
								Required: *resource.NewMilliQuantity(1000, resource.DecimalSI),
							},
							Memory: oamv1alpha2.MemoryResources{
								Required: *resource.NewQuantity(500*1024*1024, resource.BinarySI),
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

		componentName := "test-containerizedworkload-component"
		// Create a component definition
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

		hpaTraitName := "test-containerizedworkload-hpatrait"

		appConfig := newMockedApplicationConfiguration(componentName, hpaTraitName)
		logf.Log.Info("Creating application config", "Detail", *appConfig)
		Expect(k8sClient.Create(ctx, appConfig)).Should(BeNil())

		// Verification

		By("Checking HPATrait is created")
		hpaTrait := &coreoamdevv1alpha2.HorizontalPodAutoscalerTrait{}
		hpaTraitObjectKey := client.ObjectKey{
			Name:      hpaTraitName,
			Namespace: namespace,
		}
		logf.Log.Info("Checking on HPATrait", "Key", hpaTraitObjectKey)
		Eventually(
			func() error {
				return k8sClient.Get(ctx, hpaTraitObjectKey, hpaTrait)
			},
			time.Second*15, time.Millisecond*500).Should(BeNil())

		By("Checking HPA is created")
		hpa := &autoscalingv1.HorizontalPodAutoscaler{}
		hpaObjectKey := client.ObjectKey{
			Name:      hpaTraitName, // hpa to be verified has the same name as hpa trait
			Namespace: namespace,
		}
		logf.Log.Info("Checking on HPA", "Key", hpaObjectKey)
		Eventually(
			func() error {
				return k8sClient.Get(ctx, hpaObjectKey, hpa)
			},
			time.Second*15, time.Millisecond*500).Should(BeNil())
	})

	It("apply an application config with Deployment component", func() {
		// create a workload definition
		wd := oamv1alpha2.WorkloadDefinition{
			ObjectMeta: metav1.ObjectMeta{
				Name: "deployments.apps",
				// Labels: lablel,
			},
			Spec: oamv1alpha2.WorkloadDefinitionSpec{
				Reference: oamv1alpha2.DefinitionReference{
					Name: "deployments.apps",
				},
			},
		}
		logf.Log.Info("Creating deployment workload definition")
		// For some reason, WorkloadDefinition is created as a Cluster scope object
		Expect(k8sClient.Create(ctx, &wd)).Should(SatisfyAny(BeNil(), &util.AlreadyExistMatcher{}))

		// define workload instance
		wlInstanceName := "php-apache-deployment"
		wl := appsv1.Deployment{
			ObjectMeta: metav1.ObjectMeta{
				Namespace: namespace,
				Name:      wlInstanceName,
			},
			Spec: appsv1.DeploymentSpec{
				Selector: &metav1.LabelSelector{
					MatchLabels: map[string]string{
						"app": "php-apache",
					},
				},
				Template: corev1.PodTemplateSpec{
					ObjectMeta: metav1.ObjectMeta{
						Labels: map[string]string{
							"app": "php-apache",
						},
					},
					Spec: corev1.PodSpec{
						Containers: []corev1.Container{
							{
								Name:  wlInstanceName,
								Image: "k8s.gcr.io/hpa-example",
								Ports: []corev1.ContainerPort{
									{
										Name:          "pa",
										ContainerPort: 80,
									},
								},
								Resources: corev1.ResourceRequirements{
									Requests: corev1.ResourceList{
										corev1.ResourceCPU:    *resource.NewMilliQuantity(1000, resource.DecimalSI),
										corev1.ResourceMemory: *resource.NewQuantity(500*1024*1024, resource.BinarySI),
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

		componentName := "test-deployment-component"
		// Create a component definition
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

		hpaTraitName := "test-deployment-hpatrait"

		appConfig := newMockedApplicationConfiguration(componentName, hpaTraitName)
		logf.Log.Info("Creating application config", "Name", appConfig.Name, "Namespace", appConfig.Namespace)
		Expect(k8sClient.Create(ctx, appConfig)).Should(BeNil())

		// Verification
		By("Checking HPATrait is created")
		hpaTrait := &coreoamdevv1alpha2.HorizontalPodAutoscalerTrait{}
		hpaTraitObjectKey := client.ObjectKey{
			Name:      hpaTraitName,
			Namespace: namespace,
		}
		logf.Log.Info("Checking on HPATrait", "Key", hpaTraitObjectKey)
		Eventually(
			func() error {
				return k8sClient.Get(ctx, hpaTraitObjectKey, hpaTrait)
			},
			time.Second*15, time.Millisecond*500).Should(BeNil())

		By("Checking HPA is created")
		hpa := &autoscalingv1.HorizontalPodAutoscaler{}
		hpaObjectKey := client.ObjectKey{
			Name:      hpaTraitName, // hpa to be verified has the same name as hpa trait
			Namespace: namespace,
		}
		logf.Log.Info("Checking on HPA", "Key", hpaObjectKey)
		Eventually(
			func() error {
				return k8sClient.Get(ctx, hpaObjectKey, hpa)
			},
			time.Second*15, time.Millisecond*500).Should(BeNil())
	})

	It("apply an application config with StatefulSet component", func() {
		// create a workload definition
		wd := oamv1alpha2.WorkloadDefinition{
			ObjectMeta: metav1.ObjectMeta{
				Name: "statefulsets.apps",
				// Labels: lablel,
			},
			Spec: oamv1alpha2.WorkloadDefinitionSpec{
				Reference: oamv1alpha2.DefinitionReference{
					Name: "statefulsets.apps",
				},
			},
		}
		logf.Log.Info("Creating StatefulSet workload definition")
		// For some reason, WorkloadDefinition is created as a Cluster scope object
		Expect(k8sClient.Create(ctx, &wd)).Should(SatisfyAny(BeNil(), &util.AlreadyExistMatcher{}))

		// define workload instance
		wlInstanceName := "php-apache"
		wl := appsv1.StatefulSet{
			ObjectMeta: metav1.ObjectMeta{
				Namespace: namespace,
				Name:      wlInstanceName,
			},
			Spec: appsv1.StatefulSetSpec{
				Selector: &metav1.LabelSelector{
					MatchLabels: map[string]string{
						"app": "php-apache",
					},
				},
				Template: corev1.PodTemplateSpec{
					ObjectMeta: metav1.ObjectMeta{
						Labels: map[string]string{
							"app": "php-apache",
						},
					},
					Spec: corev1.PodSpec{
						Containers: []corev1.Container{
							{
								Name:  wlInstanceName,
								Image: "k8s.gcr.io/hpa-example",
								Resources: corev1.ResourceRequirements{
									Requests: corev1.ResourceList{
										corev1.ResourceCPU:    *resource.NewMilliQuantity(1000, resource.DecimalSI),
										corev1.ResourceMemory: *resource.NewQuantity(500*1024*1024, resource.BinarySI),
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

		componentName := "test-statefulset-component"
		// Create a component definition
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

		hpaTraitName := "test-statefulset-hpatrait"

		appConfig := newMockedApplicationConfiguration(componentName, hpaTraitName)
		logf.Log.Info("Creating application config", "Name", appConfig.Name, "Namespace", appConfig.Namespace)
		Expect(k8sClient.Create(ctx, appConfig)).Should(BeNil())

		// Verification
		By("Checking deployment is created")
		objectKey := client.ObjectKey{
			Name:      wlInstanceName,
			Namespace: namespace,
		}
		deploy := &appsv1.Deployment{}
		logf.Log.Info("Checking on deployment", "Key", objectKey)
		Eventually(
			func() error {
				return k8sClient.Get(ctx, objectKey, deploy)
			},
			time.Second*15, time.Millisecond*500).Should(BeNil())
		By("Checking HPATrait is created")
		hpaTrait := &coreoamdevv1alpha2.HorizontalPodAutoscalerTrait{}
		hpaTraitObjectKey := client.ObjectKey{
			Name:      hpaTraitName,
			Namespace: namespace,
		}
		logf.Log.Info("Checking on HPATrait", "Key", hpaTraitObjectKey)
		Eventually(
			func() error {
				return k8sClient.Get(ctx, hpaTraitObjectKey, hpaTrait)
			},
			time.Second*15, time.Millisecond*500).Should(BeNil())

		By("Checking HPA is created")
		hpa := &autoscalingv1.HorizontalPodAutoscaler{}
		hpaObjectKey := client.ObjectKey{
			Name:      hpaTraitName, // hpa to be verified has the same name as hpa trait
			Namespace: namespace,
		}
		logf.Log.Info("Checking on HPA", "Key", hpaObjectKey)
		Eventually(
			func() error {
				return k8sClient.Get(ctx, hpaObjectKey, hpa)
			},
			time.Second*15, time.Millisecond*500).Should(BeNil())
	})

})

func newMockedApplicationConfiguration(componentName, hpaTraitName string) *oamv1alpha2.ApplicationConfiguration {
	// Create HorizontalPodAutoscalerTrait
	var maxReplicas int32 = 5
	var minReplicas int32 = 1
	var targetCPUUtilizationPercentage int32 = 50

	hpat := coreoamdevv1alpha2.HorizontalPodAutoscalerTrait{
		TypeMeta: metav1.TypeMeta{
			Kind:       "HorizontalPodAutoscalerTrait",
			APIVersion: "core.oam.dev/v1alpha2",
		},
		ObjectMeta: metav1.ObjectMeta{
			Namespace: namespace,
			Name:      hpaTraitName, // hpa to be verified has the same name as hpaTrait
		},
		Spec: coreoamdevv1alpha2.HorizontalPodAutoscalerTraitSpec{
			MinReplicas:                    &minReplicas,
			MaxReplicas:                    maxReplicas,
			TargetCPUUtilizationPercentage: &targetCPUUtilizationPercentage,
		},
	}

	// Create application configuration
	appConfig := &oamv1alpha2.ApplicationConfiguration{
		ObjectMeta: metav1.ObjectMeta{
			Name:      fmt.Sprint("test-appconfig-", componentName),
			Namespace: namespace,
		},
		Spec: oamv1alpha2.ApplicationConfigurationSpec{
			Components: []oamv1alpha2.ApplicationConfigurationComponent{
				{
					ComponentName: componentName,
					Traits: []oamv1alpha2.ComponentTrait{
						{
							Trait: runtime.RawExtension{
								Object: &hpat,
							},
						},
					},
				},
			},
		},
	}

	return appConfig
}
