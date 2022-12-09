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
		}, {
			type: "garbage-collect"
			name: "not-gc-crd"
			properties: rules: [{
				selector: resourceTypes: ["CustomResourceDefinition"]
				strategy: "never"
			}]
		}, {
			type: "apply-once"
			name: "not-keep-crd"
			properties: rules: [{
				selector: resourceTypes: ["CustomResourceDefinition"]
				strategy: path: ["*"]
			}]
		}] + agentPolicies

		workflow: steps: [{
			type: "deploy"
			name: "deploy-ns"
			properties: policies: ["topology-distributed", "o11y-namespace"]
		}, {
			type: "deploy"
			name: "deploy-loki"
			properties: policies: ["topology-centralized", "loki-components"]
		}, {
			type: "collect-service-endpoints"
			name: "get-loki-endpoint"
			properties: {
				name:      const.name
				namespace: "vela-system"
				components: [loki.name]
				portName: "http"
				outer:    parameter.serviceType != "ClusterIP"
			}
			outputs: [{
				name:      "host"
				valueFrom: "value.endpoint.host"
			}, {
				name:      "port"
				valueFrom: "value.endpoint.port"
			}, {
				name:      "url"
				valueFrom: "value.url"
			}]
		}, {
			type: "create-config"
			name: "loki-server-register"
			properties: {
				name:     "loki-vela"
				template: "loki"
				config: {}
			}
			inputs: [{
				from:         "url"
				parameterKey: "config.url"
			}]
		}, {
			type: "export-service"
			name: "export-service"
			properties: {
				name:      "loki"
				namespace: parameter.namespace
				topology:  "topology-distributed-exclude-local"
				port:      3100
			}
			inputs: [{
				from:         "host"
				parameterKey: "ip"
			}, {
				from:         "port"
				parameterKey: "targetPort"
			}]
		}] + agentWorkflowSteps
	}
}
