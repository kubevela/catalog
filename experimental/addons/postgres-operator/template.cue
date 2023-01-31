package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	spec: {
		components: [
			{
				name: "ns-postgres-operator"
				type: "k8s-objects"
				properties: objects: [{
					kind: "Namespace"
					apiVersion: "v1"
					metadata:
						name: "postgres-operator"
				}]
			},
			{
				name: "postgres-operator"
				type: "helm"
				properties:	{
					repoType: "helm"
					url: "https://opensource.zalando.com/postgres-operator/charts/postgres-operator"
					chart: "postgres-operator-charts/postgres-operator"
					version: "1.8.2"
				}
			},
		]
		policies: [
			{
				type: "shared-resource"
				name: "postgres-operator-ns"
				properties: rules: [{
					selector: resourceTypes: ["Namespace"]
				}]
			},
			{
				type: "topology"
				name: "deploy-postgres-operator"
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
