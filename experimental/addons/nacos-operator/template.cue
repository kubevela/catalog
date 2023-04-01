package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	spec: {
		components: [
			{
				name: "ns-nacos-operator"
				type: "k8s-objects"
				properties: objects: [{
					kind:       "Namespace"
					apiVersion: "v1"
					metadata:
						name: parameter.namespace
				}]
			},
			nacosOperator,
		]
		policies: [
			{
				type: "shared-resource"
				name: "nacos-operator-ns"
				properties: rules: [{
					selector: resourceTypes: ["Namespace"]
				}]
			},
			{
				type: "topology"
				name: "deploy-nacos-operator"
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
