module github.com/oam-dev/catalog/traits/routetrait

go 1.13

require (
	github.com/crossplane/crossplane-runtime v0.10.0
	github.com/go-logr/logr v0.1.0
	github.com/oam-dev/kubevela v0.3.4-0.20210310084717-66c111be6c7f
	github.com/onsi/ginkgo v1.13.0
	github.com/onsi/gomega v1.10.3
	github.com/pkg/errors v0.9.1
	github.com/stretchr/testify v1.7.0
	github.com/wonderflow/cert-manager-api v1.0.3
	k8s.io/api v0.18.8
	k8s.io/apimachinery v0.18.8
	k8s.io/client-go v12.0.0+incompatible
	k8s.io/utils v0.0.0-20200603063816-c1c6865ac451
	sigs.k8s.io/controller-runtime v0.6.2
	sigs.k8s.io/controller-tools v0.2.4 // indirect
)

// clint-go had a buggy release, https://github.com/kubernetes/client-go/issues/749
replace k8s.io/client-go => k8s.io/client-go v0.18.5
