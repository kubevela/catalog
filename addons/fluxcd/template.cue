package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	spec: {
		components: [
			{
				type: "k8s-objects"
				name: "fluxcd-ns"
				properties: objects: [{
					apiVersion: "v1"
					kind:       "Namespace"
					metadata: name: "flux-system"
				}]
			},
			helmController,
			imageAutomationController,
			imageReflectorController,
			kustomizeController,
			sourceController,
		]
		policies: [
			{
				type: "topology"
				name: "deploy-fluxcd-ns"
				properties: {
					namespace: "flux-system"
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
