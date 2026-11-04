package main

import "list"

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	metadata: {
		name:      const.name
		namespace: "vela-system"
	}
	spec: {
		components: list.Concat([[
				o11yNamespace,
				loki,
				lokiConfig,
				if parameter.storage != _|_ {lokiStorage},
		], agentComponents])

		policies: list.Concat([commonPolicies, [{
			type: "override"
			name: "loki-components"
			properties: selector: [
				o11yNamespace.name,
				lokiConfig.name,
				loki.name,
				if parameter.storage != _|_ {lokiStorage.name},
			]
		}], agentPolicies])

		workflow: steps: list.Concat([[{
			type: "deploy"
			name: "deploy-ns"
			properties: policies: ["topology-distributed", "o11y-namespace"]
		}], lokiSteps, agentWorkflowSteps])
	}
}
