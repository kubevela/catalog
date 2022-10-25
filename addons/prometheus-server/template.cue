package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	metadata: {
		name:      const.name
		namespace: "vela-system"
	}
	spec: {
		components: [
			o11yNamespace,
			prometheusConfig,
			prometheusServer,
			if parameter.storage != _|_ {prometheusStorage},
			if parameter.thanos {thanosQuery},
		]
		policies: commonPolicies + [{
			type: "override"
			name: "component-prometheus"
			properties: selector: [o11yNamespace.name, "prometheus-config", "prometheus-storage", "prometheus-server"]
		}, {
			type: "override"
			name: "component-thanos"
			properties: selector: ["thanos-query"]
		}]
		workflow: steps: [{
			type: "deploy"
			name: "deploy-prometheus"
			properties: policies: ["component-prometheus", "topology-distributed"]
		}, {
			type: "deploy"
			name: "deploy-thanos"
			properties: policies: ["component-thanos", "topology-centralized"]
		}] + postDeploySteps
	}
}
