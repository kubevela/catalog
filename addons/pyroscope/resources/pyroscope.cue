output: {
		type: "helm"
		properties: {
				repoType: "helm"
				url:      "https://pyroscope-io.github.io/helm-chart"
				chart:    "pyroscope"
				version:  "0.2.48"
				targetNamespace: "vela-system"
				releaseName:     "pyroscope"
				values: {
						image: {
								repository: parameter["image.repository"]
								tag: parameter["image.tag"]
								pullPolicy: parameter["image.pullPolicy"]
						}
						imagePullSecrets: parameter["imagePullSecrets"]
						ingress: {
								enabled: parameter["ingress.enabled"]
								hosts: parameter["ingress.hosts"]
								rules: parameter["ingress.rules"]
								tls: parameter["ingress.tls"]
						}
						persistence: {
								accessModes: parameter["persistence.accessModes"]
								enabled: parameter["persistence.enabled"]
								finalizers: parameter["persistence.finalizers"]
								size: parameter["persistence.size"]
						}
						pyroscopeConfigs: parameter["pyroscopeConfigs"]
						rbac: {
								create: parameter["rbac.create"]
								clusterRoleBinding: {
									name: parameter["rbac.clusterRoleBinding.name"]
								}
								clusterRole: {
									name: parameter["rbac.clusterRole.name"]
									extraRules: parameter["rbac.clusterRole.extraRules"]
								}
						}
						service: {
								port: parameter["service.port"]
								type: parameter["service.type"]
						}
						serviceAccount: {
							create: parameter["serviceAccount.create"]
							name: parameter["serviceAccount.name"]
						}
				}
		}
}