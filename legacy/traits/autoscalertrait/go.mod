module github.com/oam-dev/catalog/traits/autoscalertrait

go 1.13

require (
	github.com/crossplane/crossplane-runtime v0.10.0
	github.com/go-logr/logr v0.1.0
	github.com/oam-dev/kubevela v0.3.4-0.20210310084717-66c111be6c7f
	github.com/onsi/ginkgo v1.13.0
	github.com/onsi/gomega v1.10.3
	github.com/pkg/errors v0.9.1
	github.com/wonderflow/keda-api v0.0.0-20201026084048-e7c39fa208e8
	k8s.io/apimachinery v0.18.8
	k8s.io/client-go v12.0.0+incompatible
	k8s.io/utils v0.0.0-20200603063816-c1c6865ac451
	sigs.k8s.io/controller-runtime v0.6.2
)

replace k8s.io/client-go => k8s.io/client-go v0.18.5
