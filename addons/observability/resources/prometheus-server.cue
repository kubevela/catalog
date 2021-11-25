// install Prometheus
output: {
	type: "helm"
	properties: {
		chart:    "prometheus"
		version:  "14.4.1"
		repoType: "helm"
		// original url: https://prometheus-community.github.io/helm-charts
		url:             "https://charts.kubevela.net/addons"
		targetNamespace: "vela-system"
		releaseName:     "prometheus"
		values: {
			alertmanager: persistentVolume: {
				enabled:      parameter["alertmanager-pvc-enabled"]
				storageClass: parameter["alertmanager-pvc-class"]
				size:         parameter["alertmanager-pvc-size"]
			}
			server: persistentVolume: {
				enabled:      parameter["server-pvc-enabled"]
				storageClass: parameter["server-pvc-class"]
				size:         parameter["server-pvc-size"]
			}
		}
	}
	traits: [
		{
			//# register Prometheus datasource to Grafana
			type: "register-grafana-datasource"
			properties: {
				grafanaServiceName:        "grafana"
				grafanaServiceNamespace:   "vela-system"
				credentialSecret:          "grafana"
				credentialSecretNamespace: "vela-system"
				name:                      "prometheus"
				service:                   "prometheus-server"
				namespace:                 "vela-system"
				type:                      "prometheus"
				access:                    "proxy"
			}
		},
	]
}
