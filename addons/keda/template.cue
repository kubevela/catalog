package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	spec: {
		components: [kedacore]
		policies: [{
			type: "topology"
			name: "deploy-topology"
			properties: {
				if parameter.clusters != _|_ {
					clusters: parameter.clusters
				}
				if parameter.clusters == _|_ {
					clusterLabelSelector: {}
				}
				namespace: "kube-system"
			}
		}]
		workflow: steps: [{
			type: "deploy"
			name: "deploy-keda"
			properties: policies: ["deploy-topology"]
		}]
	}
}
