package main

postDeploySteps: [
	if parameter.install {
		type: "collect-service-endpoints"
		name: "Get Grafana Endpoint"
		properties: {
			name:      const.name
			namespace: "vela-system"
			components: [grafana.name]
			portName: "port-3000"
			outer:    parameter.serviceType != "ClusterIP"
		}
		outputs: [{
			name:      "url"
			valueFrom: "value.url"
		}]
	},
	if parameter.install {
		type: "create-config"
		name: "Register Grafana Config"
		properties: {
			name:     parameter.configName
			template: "grafana"
			config: auth: {
				username: parameter.adminUser
				password: parameter.adminPassword
			}
		}
		inputs: [{
			from:         "url"
			parameterKey: "config.endpoint"
		}]
	},
	if !parameter.install {
		type: "deploy"
		name: "Deploy RoleAndBinding"
		properties: policies: ["grafana-kubernetes-role", "deploy-topology"]
	},
]
