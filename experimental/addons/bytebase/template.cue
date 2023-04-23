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
						bytebase: {
							option: {
								port:           parameter.bytebasePort,
								"external-url": parameter.externalURL,
								pg:             parameter.postgresURL
							},
							version: parameter.version
						}
					}
				}
			},
			{
				name: "svc-bytebase"
				type: "k8s-objects"
				properties: objects: [{
					apiVersion: "v1"
					kind: "Service"
					metadata:{
						name: "bytebase-nodeport-entrypoint"
						namespace: parameter.namespace
					}
					spec: {
						type: "NodePort"
						selector: {
							app: "bytebase"
						}
						ports: [
							{
								protocol: "TCP"
								port: 8080
								targetPort: parameter.bytebasePort
							}
						]
					}
				}]
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
