package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	spec: {
		components: [proxy, apiService, topo]
		policies: [{
			type: "topology"
			name: "topology"
			properties: {
				clusters: ["local"]
			}
		}]
	}
}
