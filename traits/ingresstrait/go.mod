module ingresstrait

go 1.13

require (
	github.com/crossplane/crossplane-runtime v0.8.0
	github.com/crossplane/oam-controllers v0.0.0-00010101000000-000000000000
	github.com/crossplane/oam-kubernetes-runtime v0.0.1
	github.com/go-logr/logr v0.1.0
	github.com/onsi/ginkgo v1.11.0
	github.com/onsi/gomega v1.8.1
	github.com/pkg/errors v0.8.1
	k8s.io/api v0.18.2
	k8s.io/apimachinery v0.18.3
	k8s.io/client-go v0.18.2
	sigs.k8s.io/controller-runtime v0.6.0
)

replace github.com/crossplane/oam-controllers => github.com/crossplane/addon-oam-kubernetes-local v0.0.0-20200522083149-1bc0918a6ce9
