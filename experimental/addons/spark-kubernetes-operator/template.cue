package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	spec: {
		components: [
			{
				type: "k8s-objects"
				name: "spark-operator-ns"
				properties: objects: [{
					apiVersion: "v1"
					kind:       "Namespace"
					metadata: name: parameter.namespace
				}]
			},
			{
				type: "k8s-objects"
				name: "spark-cluster-ns"
				properties: objects: [{
					apiVersion: "v1"
					kind:       "Namespace"
					metadata: name: "spark-cluster"
				},
					{
						apiVersion: "v1"
						kind:       "ServiceAccount"
						metadata: {
							name:      "spark"
							namespace: "spark-cluster"
						}
					}]
			},
			{
				name: "spark-operator-helm"
				type: "helm"
				dependsOn: ["spark-operator-ns"]
				type: "helm"
				properties: {
					repoType:        "helm"
					url:             "https://googlecloudplatform.github.io/spark-on-k8s-operator/"
					chart:           "spark-operator"
					targetNamespace: parameter["namespace"]
					version:         "1.1.26"
					values: {
						image: {
							repository: parameter["imageRepository"]
							tag:        parameter["imageTag"]
						}

						serviceAccounts: {
							spark: {
								create: parameter["createSparkServiceAccount"]
							}
						}

						serviceAccounts: {
							sparkoperator: {
								name: "spark-kubernetes-operator"
							}
						}

						webhook: {
							enable: parameter["createWebhook"]
						}
					}
				}
			},
		]

		policies: [
			{
				name: "gc-dependency"
				type: "garbage-collect"
				properties: {
					order: "dependency"
				}
			},
			{
				type: "shared-resource"
				name: "shared-resource-via-namespace"
				properties: rules: [{
					selector: resourceTypes: ["Namespace"]
				}]
			},
			{
				type: "topology"
				name: "deploy-operator"
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
