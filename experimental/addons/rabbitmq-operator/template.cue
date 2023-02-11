package main
output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	spec: {
		components: [
			{
				name: "ns-rabbitmq-operator"
				type: "k8s-objects"
				properties: objects: [{
					kind: "Namespace"
					apiVersion: "v1"
					metadata:
						name: parameter.namespace
				}]
			},
			{
				name: "rabbitmq-operator"
				type: "helm"
				properties:	{
					repoType: "helm"
					url: "https://charts.bitnami.com/bitnami"
					chart: "rabbitmq-cluster-operator"
					version: "3.2.2"
				}
			},
		]
		policies: [
			{
				type: "shared-resource"
				name: "rabbitmq-operator-ns"
				properties: rules: [{
					selector: resourceTypes: ["Namespace"]
				}]
			},
			{
				type: "topology"
				name: "deploy-rabbitmq-operator"
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
