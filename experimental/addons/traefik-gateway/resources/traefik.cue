output: {
	type: "helm"
	name: "traefik-gateway"
	properties: {
		chart:    "traefik"
		version:  "10.24.1"
		url:      "https://helm.traefik.io/traefik"
		repoType: "helm"
		values: {
			experimental: {
				kubernetesGateway: {
					enabled: true
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
