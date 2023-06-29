output: {
	type: "helm"
	properties: {
		chart:      "traefik"
		version:    "10.19.4"
		url:        "https://charts.kubevela.net/community"
		repoType:   "helm"
		upgradeCRD: parameter.upgradeCRD
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
			if parameter.entryPoints != _|_ {
				ports: {
					for entry in parameter.entryPoints {
						"\(entry.name)": {
							expose:      true
							port:        entry.port
							exposedPort: entry.port
							protocol:    entry.protocol
						}
					}
				}
			}
		}
	}
}
