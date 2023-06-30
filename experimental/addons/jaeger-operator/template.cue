package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	spec: {
		components: [
			{
				name: "ns-jaeger-operator"
				type: "k8s-objects"
				properties: objects: [{
					kind:       "Namespace"
					apiVersion: "v1"
					metadata:
						name: parameter.namespace
				}]
			},
			{
				name: "jaeger-operator"
				type: "helm"
				properties:	{
					repoType: "helm"
					url: "https://jaegertracing.github.io/helm-charts"
					chart: "jaeger-operator"
					version: "2.43.0"
					targetNamespace: parameter.namespace
				}
			},
		]
		policies: [
			{
				type: "shared-resource"
				name: "jaeger-operator-ns"
				properties: rules: [{
					selector: resourceTypes: ["Namespace"]
				}]
			},
			{
				type: "topology"
				name: "deploy-jaeger-operator"
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
