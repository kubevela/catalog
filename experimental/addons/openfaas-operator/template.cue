package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	spec: {
		components: [
			{
				name: "ns-openfaas-operator"
				type: "k8s-objects"
				properties: objects: [{
					kind: "Namespace"
					apiVersion: "v1"
					metadata:
						name: "openfaas-operator"
				}]
			},
			{
				name: "openfaas-operator"
				type: "helm"
				properties:	{
					repoType: "helm"
					url: "https://openfaas.github.io/faas-netes/"
					chart: "openfaas-operator"
					version: "0.16.4"
				}
			},
		]
		policies: [
			{
				type: "shared-resource"
				name: "openfaas-operator-ns"
				properties: rules: [{
					selector: resourceTypes: ["Namespace"]
				}]
			},
			{
				type: "topology"
				name: "deploy-openfaas-operator"
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