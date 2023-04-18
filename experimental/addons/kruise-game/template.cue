package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	spec: {
		components: [
			{
				name: "kruise"
				type: "helm"
				properties: {
					repoType: "helm"
					url:      "https://openkruise.github.io/charts/"
					chart:    "kruise"
					version:  "1.4.0"
				}
			},
			{
				name: "kruise-game"
				type: "helm"
				properties: {
					repoType: "helm"
					url:      "https://openkruise.github.io/charts/"
					chart:    "kruise-game"
					version:  "0.2.1"
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

		workflow: {
			steps: [
				{
					name: "kruise-step"
					type: "apply-component"
					properties: {
						component: "kruise"
					}
				},
				{
					name: "kruise-game-step"
					type: "apply-component"
					dependsOn: ["kruise-step"]
					properties: {
						component: "kruise-game"
					}
				},
			]
		}
	}
}
