package main
output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	spec: {
		components: [
			{
				name: "ns-hbase-operator"
				type: "k8s-objects"
				properties: objects: [{
					kind: "Namespace"
					apiVersion: "v1"
					metadata:
						name: parameter.namespace
				}]
			},
			{
				name: "hbase-operator"
				type: "helm"
				properties:	{
					repoType: "helm"
					url: "https://repo.stackable.tech/repository/helm-stable/stackable-stable"
					chart: "hbase-operator"
					version: "23.1.0"
				}
			},
			{
				name: "zookeeper-operator"
				type: "helm"
				properties:	{
					repoType: "helm"
					url: "https://repo.stackable.tech/repository/helm-stable/stackable-stable"
					chart: "zookeeper-operator"
					version: "23.1.0"
				}
			},
			{
				name: "hdfs-operator"
				type: "helm"
				properties:	{
					repoType: "helm"
					url: "https://repo.stackable.tech/repository/helm-stable/stackable-stable"
					chart: "hdfs-operator"
					version: "23.1.0"
				}
			},
			{
				name: "commons-operator"
				type: "helm"
				properties:	{
					repoType: "helm"
					url: "https://repo.stackable.tech/repository/helm-stable/stackable-stable"
					chart: "commons-operator"
					version: "23.1.0"
				}
			},
			{
				name: "secret-operator"
				type: "helm"
				properties:	{
					repoType: "helm"
					url: "https://repo.stackable.tech/repository/helm-stable/stackable-stable"
					chart: "secret-operator"
					version: "23.1.0"
				}
			},
		]
		policies: [
			{
				type: "shared-resource"
				name: "hbase-operator-ns"
				properties: rules: [{
					selector: resourceTypes: ["Namespace"]
				}]
			},
			{
				type: "topology"
				name: "deploy-hbase-operator"
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




