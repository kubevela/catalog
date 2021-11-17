type: helm
properties: {
	chart:    "kube-state-metrics"
	version:  "3.4.1"
	repoType: "helm"
	// original url: https://prometheus-community.github.io/helm-charts
	url:             "https://charts.kubevela.net/addons"
	targetNamespace: "vela-system"
	values: {
		image: {
			repository: "oamdev/kube-state-metrics"
			tag:        "v2.1.0"
		}
	}
}
