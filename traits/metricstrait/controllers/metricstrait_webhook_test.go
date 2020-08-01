package controllers

import (
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"

	"metricstrait/api/v1alpha1"
)

var _ = Describe("Metrics Mutate Admission controller Test", func() {
	var trueVar = true
	var falseVar = false

	traitBase := v1alpha1.MetricsTrait{
		ObjectMeta: metav1.ObjectMeta{
			Name: "mutate-hook",
		},
		Spec: v1alpha1.MetricsTraitSpec{
			ScrapeService: v1alpha1.ScapeServiceEndPoint{
				PortName: "test",
			},
		},
	}

	It("Test with fill in all default", func() {
		trait := traitBase
		want := traitBase
		want.Spec.ScrapeService.Format = v1alpha1.SupportedFormat
		want.Spec.ScrapeService.Scheme = v1alpha1.SupportedScheme
		want.Spec.ScrapeService.Path = v1alpha1.DefaultMetricsPath
		want.Spec.ScrapeService.Enabled = &trueVar
		trait.Default()
		Expect(trait).Should(BeEquivalentTo(want))
	})

	It("Test only fill in empty fields", func() {
		trait := traitBase
		trait.Spec.ScrapeService.Path = "not default"
		want := trait
		want.Spec.ScrapeService.Format = v1alpha1.SupportedFormat
		want.Spec.ScrapeService.Scheme = v1alpha1.SupportedScheme
		want.Spec.ScrapeService.Enabled = &trueVar
		trait.Default()
		Expect(trait).Should(BeEquivalentTo(want))
	})

	It("Test not fill in enabled field", func() {
		trait := traitBase
		trait.Spec.ScrapeService.Enabled = &falseVar
		want := trait
		want.Spec.ScrapeService.Format = v1alpha1.SupportedFormat
		want.Spec.ScrapeService.Scheme = v1alpha1.SupportedScheme
		want.Spec.ScrapeService.Path = v1alpha1.DefaultMetricsPath
		want.Spec.ScrapeService.Enabled = &falseVar
		trait.Default()
		Expect(trait).Should(BeEquivalentTo(want))
	})
})
