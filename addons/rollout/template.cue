output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	metadata: {
		name:      "rollout"
		namespace: "vela-system"
	}
	spec: {
		components: []
		policies: [{
			type: "topology"
			name: "deploy-rollout"
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
