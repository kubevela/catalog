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
				loki,
				lokiConfig,
				if parameter.storage != _|_ {lokiStorage},
		] + agentComponents

		policies: commonPolicies + [{
			type: "override"
			name: "loki-components"
			properties: selector: [
				o11yNamespace.name,
				lokiConfig.name,
				loki.name,
				if parameter.storage != _|_ {lokiStorage.name},
			]
		}] + agentPolicies

		workflow: steps: [{
			type: "deploy"
			name: "deploy-ns"
			properties: policies: ["topology-distributed", "o11y-namespace"]
		}] + lokiSteps + agentWorkflowSteps
	}
}
