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

package webhooks

import (
	"k8s.io/apimachinery/pkg/runtime"
	ctrl "sigs.k8s.io/controller-runtime"
	logf "sigs.k8s.io/controller-runtime/pkg/log"

	"sigs.k8s.io/controller-runtime/pkg/webhook"
	"sigs.k8s.io/controller-runtime/pkg/webhook/admission"

	"metricstrait/api/v1alpha1"
)

// log is for logging in this package.
var metricstraitlog = logf.Log.WithName("metricstrait-resource")

type MetricsTraitWebHook struct {
	v1alpha1.MetricsTrait
}

func (r *MetricsTraitWebHook) SetupWebhookWithManager(mgr ctrl.Manager) error {
	return ctrl.NewWebhookManagedBy(mgr).
		For(r).
		Complete()
}

// EDIT THIS FILE!  THIS IS SCAFFOLDING FOR YOU TO OWN!

// +kubebuilder:webhook:path=/mutate-standard-oam-dev-v1alpha1-metricstrait,mutating=true,failurePolicy=fail,groups=standard.oam.dev,resources=metricstraits,verbs=create;update,versions=v1alpha1,name=mmetricstrait.kb.io

var _ webhook.Defaulter = &MetricsTraitWebHook{}

// Default implements webhook.Defaulter so a webhook will be registered for the type
func (r *MetricsTraitWebHook) Default() {
	metricstraitlog.Info("default", "name", r.Name)
	var trueVar bool = true
	if r.Spec.ScrapeService.Enabled == nil {
		metricstraitlog.Info("default enabled as true")
		r.Spec.ScrapeService.Enabled = &trueVar
	}
}

// TODO(user): change verbs to "verbs=create;update;delete" if you want to enable deletion validation.
// +kubebuilder:webhook:verbs=create;update,path=/validate-standard-oam-dev-v1alpha1-metricstrait,mutating=false,failurePolicy=fail,groups=standard.oam.dev,resources=metricstraits,versions=v1alpha1,name=vmetricstrait.kb.io

var _ webhook.Validator = &MetricsTraitWebHook{}

// ValidateCreate implements webhook.Validator so a webhook will be registered for the type
func (r *MetricsTraitWebHook) ValidateCreate() error {
	metricstraitlog.Info("validate create", "name", r.Name)

	return nil
}

// ValidateUpdate implements webhook.Validator so a webhook will be registered for the type
func (r *MetricsTraitWebHook) ValidateUpdate(old runtime.Object) error {
	metricstraitlog.Info("validate update", "name", r.Name)

	// TODO(user): fill in your validation logic upon object update.
	return nil
}

// ValidateDelete implements webhook.Validator so a webhook will be registered for the type
func (r *MetricsTraitWebHook) ValidateDelete() error {
	metricstraitlog.Info("validate delete", "name", r.Name)
	return nil
}

// Register will regsiter application configuration validation to webhook
func Register(mgr ctrl.Manager) {
	server := mgr.GetWebhookServer()
	webhook := MetricsTraitWebHook{}
	server.Register("/validate-standard-oam-dev-v1alpha1-metricstrait", admission.DefaultingWebhookFor(&webhook))
	server.Register("/mutate-standard-oam-dev-v1alpha1-metricstrait", admission.ValidatingWebhookFor(&webhook))
}
