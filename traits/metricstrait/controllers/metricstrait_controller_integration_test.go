package controllers

import (
	"context"
	"reflect"
	"time"

	monitoringv1 "github.com/coreos/prometheus-operator/pkg/apis/monitoring/v1"

	runtimev1alpha1 "github.com/crossplane/crossplane-runtime/apis/core/v1alpha1"
	"github.com/crossplane/oam-kubernetes-runtime/pkg/oam/util"
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/types"
	"k8s.io/apimachinery/pkg/util/intstr"
	"sigs.k8s.io/controller-runtime/pkg/client"
	logf "sigs.k8s.io/controller-runtime/pkg/log"

	"metricstrait/api/v1alpha1"
)

var (
	metricsTraitKind       = reflect.TypeOf(v1alpha1.MetricsTrait{}).Name()
	metricsTraitAPIVersion = v1alpha1.SchemeGroupVersion.String()
	deploymentKind         = reflect.TypeOf(appsv1.Deployment{}).Name()
	deploymentAPIVersion   = appsv1.SchemeGroupVersion.String()
)

var _ = Describe("Metrics Trait Integration Test", func() {
	ctx := context.Background()
	namespace := "metricstrait-integration-test"

	ns := corev1.Namespace{
		ObjectMeta: metav1.ObjectMeta{
			Name: namespace,
		},
	}
	BeforeEach(func() {
		logf.Log.Info("Set up resources before an integration test")
		// delete the namespace with all its resources
		Expect(k8sClient.Delete(ctx, &ns, client.PropagationPolicy(metav1.DeletePropagationForeground))).
			Should(SatisfyAny(Succeed(), &util.NotFoundMatcher{}))
		logf.Log.Info("make sure all the resources are removed")
		objectKey := client.ObjectKey{
			Name: namespace,
		}
		res := &corev1.Namespace{}
		Eventually(
			// gomega has a bug that can't take nil as the actual input, so has to make it a func
			func() error {
				return k8sClient.Get(ctx, objectKey, res)
			},
			time.Second*30, time.Millisecond*500).Should(&util.NotFoundMatcher{})
		// recreate it
		Eventually(
			func() error {
				return k8sClient.Create(ctx, &ns)
			},
			time.Second*3, time.Millisecond*300).Should(SatisfyAny(Succeed(), &util.AlreadyExistMatcher{}))
	})

	AfterEach(func() {
		logf.Log.Info("Clean up resources after an integration test")
		Expect(k8sClient.Delete(ctx, &ns, client.PropagationPolicy(metav1.DeletePropagationForeground))).Should(Succeed())
	})

	It("Test with deployment as workload", func() {
		By("Create the deployment as the workload")
		labelKey := "standard.oam.dev"
		workloadName := "oam-test-deployment"
		podPort := 4848
		workload := &appsv1.Deployment{
			TypeMeta: metav1.TypeMeta{
				Kind:       deploymentKind,
				APIVersion: deploymentAPIVersion,
			},
			ObjectMeta: metav1.ObjectMeta{
				Name:      workloadName,
				Namespace: ns.Name,
			},
			Spec: appsv1.DeploymentSpec{
				Selector: &metav1.LabelSelector{
					MatchLabels: map[string]string{
						labelKey: workloadName,
					},
				},
				Template: corev1.PodTemplateSpec{
					ObjectMeta: metav1.ObjectMeta{
						Labels: map[string]string{
							labelKey: workloadName,
						},
					},
					Spec: corev1.PodSpec{
						Containers: []corev1.Container{
							{
								Name:    "container-name",
								Image:   "containerImage",
								Command: []string{"containerCommand"},
								Args:    []string{"containerArguments"},
								Ports: []corev1.ContainerPort{
									{
										ContainerPort: int32(podPort),
									},
								},
							},
						},
					},
				},
			},
		}
		Expect(k8sClient.Create(ctx, workload)).ToNot(HaveOccurred())

		By("Create the metrics trait pointing to the workload")
		targetPort := intstr.FromInt(podPort)
		label := map[string]string{"trait": "metricsTrait"}
		metricsTrait := v1alpha1.MetricsTrait{
			TypeMeta: metav1.TypeMeta{
				Kind:       metricsTraitKind,
				APIVersion: metricsTraitAPIVersion,
			},
			ObjectMeta: metav1.ObjectMeta{
				Name:      "metrics-trait-it-success",
				Namespace: ns.Name,
				Labels:    label,
			},
			Spec: v1alpha1.MetricsTraitSpec{
				MetricsEndPoint: v1alpha1.Endpoint{
					TargetPort: &targetPort,
				},
				WorkloadReference: runtimev1alpha1.TypedReference{
					APIVersion: deploymentAPIVersion,
					Kind:       deploymentKind,
					Name:       workloadName,
				},
			},
		}
		Expect(k8sClient.Create(ctx, &metricsTrait)).ToNot(HaveOccurred())
		By("Check that we have created the service")
		createdService := corev1.Service{}
		Eventually(
			func() error {
				return k8sClient.Get(ctx,
					types.NamespacedName{Namespace: ns.Name, Name: "oam-" + workload.GetName()},
					&createdService)
			},
			time.Second*30, time.Millisecond*500).Should(BeNil())
		logf.Log.Info("get the created service", "service ports", createdService.Spec.Ports)
		By("Check that we have created the serviceMonitor in the pre-defined namespace")
		var serviceMonitor monitoringv1.ServiceMonitor
		Eventually(
			func() error {
				return k8sClient.Get(ctx,
					types.NamespacedName{Namespace: serviceMonitorNSName, Name: metricsTrait.GetName()},
					&serviceMonitor)
			},
			time.Second*30, time.Millisecond*500).Should(BeNil())
		logf.Log.Info("get the created serviceMonitor", "service end ports", serviceMonitor.Spec.Endpoints)
	})
})
