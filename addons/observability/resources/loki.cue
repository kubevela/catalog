// install loki
output: {
	type: "helm"
	properties: {
		chart:    "loki-stack"
		version:  "2.4.1"
		repoType: "helm"
		// original url: https://grafana.github.io/helm-charts
		url:             "https://charts.kubevela.net/addons"
		targetNamespace: "vela-system"
		releaseName:     "loki"
	}
	traits: [{
		type: "register-grafana-datasource" // register loki datasource to Grafana
		properties:
			grafanaServiceName: "grafana"
		grafanaServiceNamespace:   "observability"
		credentialSecret:          "grafana"
		credentialSecretNamespace: "observability"
		name:                      "loki"
		service:                   "loki"
		namespace:                 "observability"
		type:                      "loki"
		access:                    "proxy"
	}]
}
