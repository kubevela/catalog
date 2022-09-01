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
  {if parameter.agent == "promtail" {promtail}},
  {if parameter.agent == "promtail" {promtailConfig}},
  {if parameter.agent == "vector" {vector}},
  {if parameter.agent == "vector" {vectorConfig}},
  loki,
  lokiConfig,
  {if parameter.storage != _|_ {lokiStorage}}
]

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	metadata: {
		name:      const.name
		namespace: "vela-system"
	}
	spec: {
		components: [for comp in comps if comp.name != _|_ {comp}]

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
      name: "agent-components"
      if parameter.agent == "promtail" {
        properties: selector: [promtailConfig.name, promtail.name]
      }
      if parameter.agent == "vector" {
        properties: selector: [vectorConfig.name, vector.name]
      }
      if parameter.agent == "" {
        properties: selector: []
      }
    }, {
      type: "override"
      name: "loki-components"
      properties: selector: [lokiConfig.name, loki.name] + [if parameter.storage != _|_ {lokiStorage.name}]
    }]

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
        name: const.name
        namespace: "vela-system"
        components: [loki.name]
        port: 3100
      }
      outputs: [{
        name: "host"
        valueFrom: "value.endpoint.host"
      }]
    }, {
      type: "export-data"
      name: "export-data"
      properties: {
        name: "loki-endpoint"
        namespace: parameter.namespace
        topology: "deploy-multi-cluster"
      }
      inputs: [{
        from: "host"
        parameterKey: "data.host"
      }]
    }, {
      type: "deploy"
      name: "deploy-agent"
      properties: policies: ["deploy-multi-cluster", "agent-components"]
    }]
	}
}
