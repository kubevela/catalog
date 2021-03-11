package webhook

import (
	"sigs.k8s.io/controller-runtime/pkg/manager"
	"sigs.k8s.io/controller-runtime/pkg/webhook"
)

func Register(mgr manager.Manager) {
	server := mgr.GetWebhookServer()
	server.Register("/validate-standard-oam-dev-v1alpha1-podspecworkload",
		&webhook.Admission{Handler: &ValidatingHandler{}})
	server.Register("/mutate-standard-oam-dev-v1alpha1-podspecworkload",
		&webhook.Admission{Handler: &MutatingHandler{}})
}