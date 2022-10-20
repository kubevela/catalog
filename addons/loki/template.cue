package main

ns: {
	type: "k8s-objects"
	name: const.name + "-ns"
	properties: objects: [{
		apiVersion: "v1"
		kind:       "Namespace"
		metadata: name: parameter.namespace
	}]
}

comps: [ns,
	loki,
	lokiConfig,
	{if parameter.storage != _|_ {lokiStorage}},
] + agentComponents

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	metadata: {
		name:      const.name
		namespace: "vela-system"
	}
	spec: {
		components: [ for comp in comps if comp.name != _|_ {comp}]

		policies: [{
			type: "shared-resource"
			name: "namespace"
			properties: rules: [{selector: resourceTypes: ["Namespace"]}]
		}, {
			type: "garbage-collect"
			name: "ignore-recycle-pvc"
			properties: rules: [{
				selector: resourceTypes: ["PersistentVolumeClaim"]
				strategy: "never"
			}]
		}, {
			type: "topology"
			name: "deploy-multi-cluster"
			properties: {
				if parameter.clusters != _|_ {
					clusters: parameter.clusters
				}
				if parameter.clusters == _|_ {
					clusterLabelSelector: {}
				}
				namespace: parameter.namespace
			}
		}, {
			type: "topology"
			name: "deploy-multi-cluster-exclude-local"
			properties: {
				if parameter.clusters != _|_ {
					clusters: [ for c in parameter.clusters if c != "local" {c}]
				}
				if parameter.clusters == _|_ {
					clusterLabelSelector: {
						"cluster.core.oam.dev/control-plane": "false"
					}
				}
				namespace: parameter.namespace
				allowEmpty: true
			}
		}, {
			type: "topology"
			name: "deploy-local"
			properties: {
				clusters: ["local"]
				namespace: parameter.namespace
			}
		}, {
			type: "override"
			name: "ns-component"
			properties: selector: [const.name + "-ns"]
		}, {
			type: "override"
			name: "loki-components"
			properties: selector: [lokiConfig.name, loki.name] + [ if parameter.storage != _|_ {lokiStorage.name}]
		}] + agentPolicies

		workflow: steps: [{
			type: "deploy"
			name: "deploy-ns"
			properties: policies: ["deploy-multi-cluster", "ns-component"]
		}, {
			type: "deploy"
			name: "deploy-loki"
			properties: policies: ["deploy-local", "loki-components"]
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
			}]
		}, {
			type: "export-service"
			name: "export-service"
			properties: {
				name:      "loki"
				namespace: parameter.namespace
				topology:  "deploy-multi-cluster-exclude-local"
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
