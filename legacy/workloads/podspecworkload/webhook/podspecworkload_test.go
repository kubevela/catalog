package webhook

import (
	"testing"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	v1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/utils/pointer"

	"github.com/oam-dev/catalog/workloads/podspecworkload/api/v1alpha1"
)

func TestPodSpecWorkload(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "PodSpecWorkload Suite")
}

var _ = Describe("Test PodSpecWorkload", func() {
	var baseCase v1alpha1.PodSpecWorkload

	BeforeEach(func() {
		baseCase = v1alpha1.PodSpecWorkload{
			ObjectMeta: metav1.ObjectMeta{
				Name: "mutate-hook",
			},
			Spec: v1alpha1.PodSpecWorkloadSpec{},
		}
	})

	It("Test with fill in all default", func() {
		cw := baseCase
		want := baseCase
		want.Spec.Replicas = pointer.Int32Ptr(1)
		DefaultPodSpecWorkload(&cw)
		Expect(cw).Should(BeEquivalentTo(want))
	})

	It("Test only fill in empty fields", func() {
		cw := baseCase
		cw.Spec.Replicas = pointer.Int32Ptr(10)
		want := cw
		DefaultPodSpecWorkload(&cw)
		Expect(cw).Should(BeEquivalentTo(want))
	})

	It("Test validate valid trait", func() {
		cw := baseCase
		cw.ObjectMeta.Namespace = "default"
		cw.Spec.Replicas = pointer.Int32Ptr(5)
		cw.Spec.PodSpec.Containers = []v1.Container{
			{
				Name:  "test",
				Image: "test",
			},
		}
		Expect(ValidateCreate(&cw).ToAggregate()).NotTo(HaveOccurred())
		Expect(ValidateUpdate(&cw, nil).ToAggregate()).NotTo(HaveOccurred())
		Expect(ValidateDelete(&cw).ToAggregate()).NotTo(HaveOccurred())
	})

	It("Test validate invalid trait", func() {
		cw := baseCase
		cw.Spec.Replicas = pointer.Int32Ptr(-5)
		Expect(ValidateCreate(&cw).ToAggregate()).To(HaveOccurred())
		Expect(ValidateUpdate(&cw, nil).ToAggregate()).To(HaveOccurred())
		Expect(len(ValidateCreate(&cw))).Should(Equal(3))
		// add namespace
		cw.ObjectMeta.Namespace = "default"
		Expect(len(ValidateCreate(&cw))).Should(Equal(2))
		// get valid replica
		cw.Spec.Replicas = pointer.Int32Ptr(5)
		Expect(len(ValidateCreate(&cw))).Should(Equal(1))
	})
})
