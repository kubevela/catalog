package webhook

import (
	"sigs.k8s.io/controller-runtime/pkg/manager"
	"sigs.k8s.io/controller-runtime/pkg/webhook"
)
// +kubebuilder:webhook:verbs=create;update;delete,path=/validate-standard-oam-dev-v1alpha1-metricstrait,mutating=false,failurePolicy=fail,groups=standard.oam.dev,resources=metricstraits,versions=v1alpha1,name=vmetricstrait.kb.io
// +kubebuilder:webhook:path=/mutate-standard-oam-dev-v1alpha1-metricstrait,mutating=true,failurePolicy=fail,groups=standard.oam.dev,resources=metricstraits,verbs=create;update,versions=v1alpha1,name=mmetricstrait.kb.io

// Register will regsiter metrics trait to webhook
func Register(mgr manager.Manager) {
	server := mgr.GetWebhookServer()
	server.Register("/validate-standard-oam-dev-v1alpha1-metricstrait",
		&webhook.Admission{Handler: &ValidatingHandler{}})
	server.Register("/mutate-standard-oam-dev-v1alpha1-metricstrait",
		&webhook.Admission{Handler: &MutatingHandler{}})
}