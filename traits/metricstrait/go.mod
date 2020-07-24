module metricstrait

go 1.13

require (
	github.com/coreos/prometheus-operator v0.40.0
	github.com/crossplane/crossplane-runtime v0.9.0
	github.com/crossplane/oam-kubernetes-runtime v0.0.4
	github.com/go-logr/logr v0.1.0
	github.com/onsi/ginkgo v1.11.0
	github.com/onsi/gomega v1.8.1
	github.com/pkg/errors v0.9.1
	k8s.io/apimachinery v0.18.5
	k8s.io/client-go v12.0.0+incompatible
	k8s.io/kube-openapi v0.0.0-20200410145947-bcb3869e6f29 // indirect
	sigs.k8s.io/controller-runtime v0.6.0
)

// clint-go had a buggy release, https://github.com/kubernetes/client-go/issues/749
replace k8s.io/client-go => k8s.io/client-go v0.18.5
