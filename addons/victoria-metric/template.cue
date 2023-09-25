package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	spec: {
		components: []
		policies: [{
			type: "override"
			name: "vm-namespace"
			properties: selector: ["namespace"]
		},{
			type: "override"
			name: "vm-agent"
			properties: selector: ["vm-agent"]
		},{
			type: "override"
			name: "vm-cluster"
			properties: selector: ["vm-cluster"]
		}]
		workflow: steps: [{
			type: "deploy"
			name: "deploy-namespace"
			properties: policies: ["vm-namespace"]
		}, {
			type: "deploy"
			name: "deploy-cluster"
			properties: policies: ["vm-cluster"]
		}, {
			type: "deploy"
			name: "deploy-agent"
			properties: policies: ["vm-agent"]
		}, {
			type: "create-config"
			name: "prometheus-server-register"
			properties: {
				name:     "vm-cluster"
				template: "prometheus-server"
				config: {
					url: "http://victoria-metrics-cluster-vmselect.vm-system:8481/select/0/prometheus"
				}
			}
		}]
	}
}
