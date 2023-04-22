package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	spec: {
		components: [
			{
				name: "ns-bytebase"
				type: "k8s-objects"
				properties: objects: [{
					kind:       "Namespace"
					apiVersion: "v1"
					metadata:
						name: parameter.namespace
				}]
			},
			{
				name: "bytebase"
				type: "helm"
				properties: {
					repoType:        "helm"
					url:             "https://bytebase.github.io/bytebase"
					chart:           "bytebase"
					version:         parameter.chartVersion
					targetNamespace: parameter.namespace
					values: {
						"bytebase.option.port":         parameter.bytebasePort
						"bytebase.option.external-url": parameter.externalURL
						"bytebase.option.pg":           parameter.postgresURL
						"bytebase.version":             parameter.version
					}
				}
			},
		]
		policies: [
			{
				type: "shared-resource"
				name: "bytebase-ns"
				properties: rules: [{
					selector: resourceTypes: ["Namespace"]
				}]
			},
			{
				type: "topology"
				name: "deploy-bytebase"
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
