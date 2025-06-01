package main
output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	spec: {
		components: [
			{
				name: "ns-solr-operator"
				type: "k8s-objects"
				properties: objects: [{
					kind: "Namespace"
					apiVersion: "v1"
					metadata:
						name: parameter.namespace
				}]
			},
			{
				name: "solr-operator"
				type: "helm"
				properties:	{
					repoType: "helm"
					url: "https://solr.apache.org/charts"
					chart: "solr-operator"
					version: "0.9.1"
				}
			},
		]
		policies: [
			{
				type: "shared-resource"
				name: "solr-operator-ns"
				properties: rules: [{
					selector: resourceTypes: ["Namespace"]
				}]
			},
			{
				type: "topology"
				name: "deploy-solr-operator"
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
