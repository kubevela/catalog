output: {
	type: "helm"
	properties: {
		chart:    "traefik"
		version:  "10.19.4"
		url:      "https://charts.kubevela.net/community"
		repoType: "helm"
		values: {
			experimental: {
				kubernetesGateway: {
					enabled:         true
					namespacePolicy: "All"
				}
			}
			ports: {
				traefik: {
					expose: parameter.exposeDashboard
				}
			}
			service: {
				type: parameter.serviceType
			}
			if parameter.autoscaling != _|_ {
				autoscaling: {
					enabled: parameter.autoscaling
				}
			}
			logs: {
				access: {
					enabled: parameter.accessLog
				}
			}
		}
	}
}
