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
			prism,
			additionalPrivileges,
			apiServices,
		]
		policies: [{
			type: "topology"
			name: "topology"
			properties: {
				clusters: ["local"]
			}
		}, {
			type: "override"
			name: "override-core"
			properties: selector: ["vela-prism"]
		}, {
			type: "override"
			name: "override-prehook"
			properties: selector: ["vela-prism-apiservices", "vela-prism-additional-privileges"]
		}]
		workflow: steps: [{
			type: "deploy"
			name: "deploy-prehook"
			properties: policies: ["topology", "override-prehook"]
		}, {
			type: "deploy"
			name: "deploy-core"
			properties: policies: ["topology", "override-core"]
		}]
	}
}
