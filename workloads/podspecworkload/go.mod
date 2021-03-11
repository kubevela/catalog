module github.com/oam-dev/catalog/workloads/podspecworkload

go 1.13

require (
	github.com/crossplane/crossplane-runtime v0.10.0
	github.com/go-logr/logr v0.1.0
	github.com/oam-dev/kubevela v0.3.4-0.20210310084717-66c111be6c7f
	github.com/onsi/ginkgo v1.13.0
	github.com/onsi/gomega v1.10.3
	github.com/pkg/errors v0.9.1
	k8s.io/api v0.18.8
	k8s.io/apimachinery v0.18.8
	k8s.io/client-go v12.0.0+incompatible
	k8s.io/klog v1.0.0
	k8s.io/utils v0.0.0-20200603063816-c1c6865ac451
	sigs.k8s.io/controller-runtime v0.6.2
)

// clint-go had a buggy release, https://github.com/kubernetes/client-go/issues/749
replace k8s.io/client-go => k8s.io/client-go v0.18.5
