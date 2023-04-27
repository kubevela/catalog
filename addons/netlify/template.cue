output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	metadata: {
		name:      "netlify"
		namespace: "vela-system"
	}
	spec: {
		components: []
		policies: [{
			type: "topology"
			name: "deploy-netlify"
			properties: {
				if parameter.clusters != _|_ {
					clusters: parameter.clusters
				}
				if parameter.clusters == _|_ {
					clusterLabelSelector: {}
				}
			}
		}]
	}
}
