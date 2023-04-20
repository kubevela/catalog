package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	spec: {
		components: [
			{
				name: "kruise-game"
				type: "helm"
				properties: {
					repoType: "helm"
					url:      "https://openkruise.github.io/charts/"
					chart:    "kruise-game"
					version:  parameter.chartVersion
				}
			},
		]

		policies: [
			{
				type: "shared-resource"
				name: "kruise-game-ns"
				properties: rules: [{
					selector: resourceTypes: ["Namespace"]
				}]
			},
			{
				type: "topology"
				name: "deploy-kruise-game"
				properties: {
					if parameter.clusters != _|_ {
						clusters: parameter.clusters
					}
					if parameter.clusters == _|_ {
						clusterLabelSelector: {}
					}
				}
			},
		]
	}
}
