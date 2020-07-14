module github.com/oam-dev/catalog/traits/cronhpatrait

go 1.13

require (
	github.com/AliyunContainerService/kubernetes-cronhpa-controller v1.3.0
	github.com/crossplane/crossplane-runtime v0.9.0
	github.com/crossplane/oam-kubernetes-runtime v0.0.3
	github.com/go-logr/logr v0.1.0
	github.com/onsi/ginkgo v1.11.0
	github.com/onsi/gomega v1.8.1
	github.com/pkg/errors v0.9.1
	k8s.io/api v0.18.2
	k8s.io/apimachinery v0.18.2
	k8s.io/client-go v0.18.2
	sigs.k8s.io/controller-runtime v0.6.0
)
