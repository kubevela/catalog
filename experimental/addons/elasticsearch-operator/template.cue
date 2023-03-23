package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	spec: {
		components: [
			{
				name: "ns-elasticsearch-operator"
				type: "k8s-objects"
				properties: objects: [{
					kind:       "Namespace"
					apiVersion: "v1"
					metadata:
						name: parameter.namespace
				}]
			},
			CRDs,
		]
		policies: [
			{
				type: "shared-resource"
				name: "elasticsearch-operator-ns"
				properties: rules: [{
					selector: resourceTypes: ["Namespace"]
				}]
			},
			{
				type: "topology"
				name: "deploy-elasticsearch-operator"
				properties: {
					namespace: parameter.namespace
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
