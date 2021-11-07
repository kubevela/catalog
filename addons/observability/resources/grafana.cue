output: {
	type: "helm"
	properties: {
		chart:    "grafana"
		version:  "6.14.1"
		repoType: "helm"
		// original url: https://grafana.github.io/helm-charts
		url:             "https://charts.kubevela.net/addons"
		targetNamespace: "observability"
		releaseName:     "grafana"
	}
	traits: [
		{
			type: "pure-ingress"
			properties:
				domain: parameter["grafana-domain"]
			http:
				"/": 80
		},
		{
			type: "import-grafana-dashboard"
			properties: {
				grafanaServiceName:        "grafana"
				grafanaServiceNamespace:   "observability"
				credentialSecret:          "grafana"
				credentialSecretNamespace: "observability"
				urls: [
					"https://charts.kubevela.net/addons/dashboards/kubevela_core_logging.json",
					"https://charts.kubevela.net/addons/dashboards/kubevela_core_monitoring.json",
					"https://charts.kubevela.net/addons/dashboards/kubevela_application_logging.json",
					"https://charts.kubevela.net/addons/dashboards/flux2/cluster.json", // fluxcd
				]
			}
		},
	]
}
