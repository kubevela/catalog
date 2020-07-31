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

package v1alpha1

import (
	"fmt"

	"k8s.io/apimachinery/pkg/runtime"
	ctrl "sigs.k8s.io/controller-runtime"
	logf "sigs.k8s.io/controller-runtime/pkg/log"

	"sigs.k8s.io/controller-runtime/pkg/webhook"
	"sigs.k8s.io/controller-runtime/pkg/webhook/admission"
)

const (
	// SupportedFormat is the only metrics data format we support
	SupportedFormat = "prometheus"

	// SupportedScheme is the only scheme we support
	SupportedScheme = "http"

	// DefaultMetricsPath is the default metrics path we support
	DefaultMetricsPath = "/metrics"
)

// log is for logging in this package.
var metricstraitlog = logf.Log.WithName("metricstrait-resource")
var trueVar = true

// +kubebuilder:webhook:path=/mutate-standard-oam-dev-v1alpha1-metricstrait,mutating=true,failurePolicy=fail,groups=standard.oam.dev,resources=metricstraits,verbs=create;update,versions=v1alpha1,name=mmetricstrait.kb.io

var _ webhook.Defaulter = &MetricsTrait{}
// Default implements webhook.Defaulter so a webhook will be registered for the type
func (r *MetricsTrait) Default() {
	metricstraitlog.Info("default", "name", r.Name)
	if len(r.Spec.ScrapeService.Format) == 0 {
		metricstraitlog.Info("default format as prometheus")
		r.Spec.ScrapeService.Format = SupportedFormat
	}
	if len(r.Spec.ScrapeService.Path) == 0 {
		metricstraitlog.Info("default path as /metrics")
		r.Spec.ScrapeService.Path = DefaultMetricsPath
	}
	if len(r.Spec.ScrapeService.Scheme) == 0 {
		metricstraitlog.Info("default scheme as http")
		r.Spec.ScrapeService.Scheme = SupportedScheme
	}
	if r.Spec.ScrapeService.Enabled == nil {
		metricstraitlog.Info("default enabled as true")
		r.Spec.ScrapeService.Enabled = &trueVar
	}
}

// +kubebuilder:webhook:verbs=create;update;delete,path=/validate-standard-oam-dev-v1alpha1-metricstrait,mutating=false,failurePolicy=fail,groups=standard.oam.dev,resources=metricstraits,versions=v1alpha1,name=vmetricstrait.kb.io

var _ webhook.Validator = &MetricsTrait{}
// ValidateCreate implements webhook.Validator so a webhook will be registered for the type
func (r *MetricsTrait) ValidateCreate() error {
	metricstraitlog.Info("validate create", "name", r.Name)
	if len(r.Spec.ScrapeService.PortName) == 0 && r.Spec.ScrapeService.TargetPort == nil {
		return fmt.Errorf("both the portName and targetPort cannot be empty")
	} else if len(r.Spec.ScrapeService.PortName) > 0 && r.Spec.ScrapeService.TargetPort != nil {
		return fmt.Errorf("the portName and targetPort are mutually exclusive")
	} else if r.Spec.ScrapeService.TargetPort == nil && len(r.Spec.ScrapeService.TargetSelector) > 0 {
		return fmt.Errorf("the targetSelector cannot be set when the targetPort is not")
	}
	if r.Spec.ScrapeService.Format != SupportedFormat {
		return fmt.Errorf("the data format `%s` is not supported", r.Spec.ScrapeService.Format)
	}
	if r.Spec.ScrapeService.Scheme != SupportedScheme {
		return fmt.Errorf("the scheme `%s` is not supported", r.Spec.ScrapeService.Scheme)
	}
	return nil
}

// ValidateUpdate implements webhook.Validator so a webhook will be registered for the type
func (r *MetricsTrait) ValidateUpdate(old runtime.Object) error {
	metricstraitlog.Info("validate update", "name", r.Name)
	return r.ValidateCreate()
}

// ValidateDelete implements webhook.Validator so a webhook will be registered for the type
func (r *MetricsTrait) ValidateDelete() error {
	metricstraitlog.Info("validate delete", "name", r.Name)
	return nil
}

// RegisterWebhook will regsiter metrics trait to webhook
func RegisterWebhook(mgr ctrl.Manager) {
	server := mgr.GetWebhookServer()
	webhook := MetricsTrait{}
	server.Register("/mutate-standard-oam-dev-v1alpha1-metricstrait", admission.DefaultingWebhookFor(&webhook))
	server.Register("/validate-standard-oam-dev-v1alpha1-metricstrait", admission.ValidatingWebhookFor(&webhook))
}
