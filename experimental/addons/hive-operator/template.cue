package main
output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	spec: {
		components: [
			{
				name: "ns-hive-operator"
				type: "k8s-objects"
				properties: objects: [{
					kind: "Namespace"
					apiVersion: "v1"
					metadata:
						name: parameter.namespace
				}]
			},
			{
				name: "commons-operator"
				type: "helm"
				properties:	{
					repoType: "helm"
					url: "https://repo.stackable.tech/repository/helm-stable/"
					chart: "commons-operator"
					version: "23.1.0"
				}
			},
			{
				name: "secret-operator"
				type: "helm"
				properties:	{
					repoType: "helm"
					url: "https://repo.stackable.tech/repository/helm-stable/"
					chart: "secret-operator"
					version: "23.1.0"
				}
			},
			{
				name: "hive-operator"
				type: "helm"
				properties:	{
					repoType: "helm"
					url: "https://repo.stackable.tech/repository/helm-stable/"
					chart: "hive-operator"
					version: "23.1.0"
				}
			},
		]
		policies: [
			{
				type: "shared-resource"
				name: "hive-operator-ns"
				properties: rules: [{
					selector: resourceTypes: ["Namespace"]
				}]
			},
			{
				type: "topology"
				name: "deploy-hive-operator"
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
