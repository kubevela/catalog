module github.com/oam-dev/catalog/traits/metrichpatrait

go 1.13

require (
	cloud.google.com/go v0.55.0 // indirect
	github.com/crossplane/crossplane-runtime v0.9.0
	github.com/crossplane/oam-kubernetes-runtime v0.0.3
	github.com/emicklei/go-restful v2.9.5+incompatible // indirect
	github.com/go-logr/logr v0.1.0
	github.com/go-openapi/jsonreference v0.19.3 // indirect
	github.com/go-openapi/spec v0.19.7 // indirect
	github.com/gogo/protobuf v1.3.1 // indirect
	github.com/imdario/mergo v0.3.9 // indirect
	github.com/kedacore/keda v1.4.1
	github.com/kr/pretty v0.2.0 // indirect
	github.com/mailru/easyjson v0.7.0 // indirect
	github.com/onsi/ginkgo v1.12.0
	github.com/onsi/gomega v1.9.0
	github.com/pkg/errors v0.9.1
	github.com/prometheus/client_golang v1.5.1 // indirect
	github.com/prometheus/client_model v0.2.0 // indirect
	github.com/prometheus/common v0.7.0 // indirect
	github.com/prometheus/procfs v0.0.6 // indirect
	go.uber.org/zap v1.14.1 // indirect
	golang.org/x/crypto v0.0.0-20200414173820-0848c9571904 // indirect
	golang.org/x/net v0.0.0-20200324143707-d3edc9973b7e // indirect
	golang.org/x/tools v0.0.0-20200403190813-44a64ad78b9b // indirect
	gopkg.in/check.v1 v1.0.0-20190902080502-41f04d3bba15 // indirect
	k8s.io/api v0.18.2
	k8s.io/apimachinery v0.18.3
	k8s.io/client-go v12.0.0+incompatible
	k8s.io/kube-openapi v0.0.0-20200121204235-bf4fb3bd569c // indirect
	k8s.io/utils v0.0.0-20200324210504-a9aa75ae1b89 // indirect
	sigs.k8s.io/controller-runtime v0.6.0
)

replace github.com/crossplane/oam-controllers => github.com/crossplane/addon-oam-kubernetes-local v0.0.0-20200522083149-1bc0918a6ce9

// replace github.com/kedacore/keda => /Users/roy/go/src/github.com/kedacore/keda

// Required deps for operator-sdk v0.11.0 <-> kubernetes-incubator/custom-metrics-apiserver on kubernetes-1.14.1
replace (
	github.com/kubernetes-incubator/custom-metrics-apiserver => github.com/kubernetes-incubator/custom-metrics-apiserver v0.0.0-20190703094830-abe433176c52
	github.com/prometheus/client_golang => github.com/prometheus/client_golang v0.9.2
	github.com/ugorji/go => github.com/ugorji/go v1.1.7

	k8s.io/kube-openapi => k8s.io/kube-openapi v0.0.0-20190228160746-b3a7cee44a30
	sigs.k8s.io/structured-merge-diff => sigs.k8s.io/structured-merge-diff v0.0.0-20190302045857-e85c7b244fd2

)

// Pinned to kubernetes-1.14.1
replace (
	k8s.io/api => k8s.io/api v0.0.0-20190409021203-6e4e0e4f393b
	k8s.io/apiextensions-apiserver => k8s.io/apiextensions-apiserver v0.0.0-20190409022649-727a075fdec8
	k8s.io/apimachinery => k8s.io/apimachinery v0.0.0-20190404173353-6a84e37a896d
	k8s.io/apiserver => k8s.io/apiserver v0.0.0-20190409021813-1ec86e4da56c
	k8s.io/client-go => k8s.io/client-go v11.0.1-0.20190409021438-1a26190bd76a+incompatible
	k8s.io/cloud-provider => k8s.io/cloud-provider v0.0.0-20190409023720-1bc0c81fa51d
	k8s.io/metrics => k8s.io/metrics v0.0.0-20190409022812-850dadb8b49c
)

replace (
	github.com/coreos/prometheus-operator => github.com/coreos/prometheus-operator v0.31.1
	// Pinned to v2.10.0 (kubernetes-1.14.1) so https://proxy.golang.org can
	// resolve it correctly.
	github.com/prometheus/prometheus => github.com/prometheus/prometheus v1.8.2-0.20190525122359-d20e84d0fb64
	sigs.k8s.io/controller-runtime => sigs.k8s.io/controller-runtime v0.2.2
)

replace github.com/operator-framework/operator-sdk => github.com/operator-framework/operator-sdk v0.11.0
