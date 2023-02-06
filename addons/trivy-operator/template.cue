package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	spec: {
		components: [
			{
				type: "k8s-objects"
				name: "trivy-system-ns"
				properties: objects: [{
					apiVersion: "v1"
					kind:       "Namespace"
					metadata: name: parameter.namespace
				}]
			},
			aquaTrivyHelm,
		]
		policies: [
			{
				type: "shared-resource"
				name: "namespace"
				properties: rules: [{
					selector: resourceTypes: ["Namespace"]
				}]
			},
			{
				type: "topology"
				name: "deploy-trivy-system-ns"
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
			{
				type: "take-over"
				name: "take-over-CRD-namespace"
				properties: rules: [{
					selector: resourceTypes: ["CustomResourceDefinition", "Namespace"]
				}]
			},
			{
				type: "shared-resource"
				name: "shared-CRD-namespace"
				properties: rules: [{
					selector: resourceTypes: ["CustomResourceDefinition", "Namespace"]
				}]
			},
			{
				type: "garbage-collect"
				name: "not-gc-CRD-namespace"
				properties: {
					rules: [{
						selector: resourceTypes: ["CustomResourceDefinition", "Namespace"]
						strategy: "never"
					},
					]
				}
			},
			{
				type: "apply-once"
				name: "not-keep-CRD"
				properties: {
					rules: [{
						selector: resourceTypes: ["CustomResourceDefinition"]
						strategy: {
							path: ["*"]
						}
					},
					]
				}
			},
		]
	}
}
