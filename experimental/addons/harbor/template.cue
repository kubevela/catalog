package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	metadata: {
		name:      "addon-harbor"
		namespace: "vela-system"
	}
	spec: {
		components: [
			harbor,
		]
		policies: [{
			type: "topology"
			name: "deploy-topology"
			properties: {
				if parameter.clusters != _|_ {
					clusters: parameter.clusters
				}
				if parameter.clusters == _|_ {
					clusters: ["local"]
				}
			}
		}]
		workflow: steps: [{
			type: "deploy"
			name: "deploy-ck"
			properties: policies: ["deploy-topology"]
		}]
	}
}
