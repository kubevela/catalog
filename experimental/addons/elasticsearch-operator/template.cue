package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	spec: {
		components: [
			{
				name: "ns-elasticsearch-operator"
				type: "k8s-objects"
				properties: objects: [{
					kind:       "Namespace"
					apiVersion: "v1"
					metadata:
						name: parameter.namespace
				}]
			},
			CRDs,
			olmResources,
			esOperator,
		]
		policies: [
			{
				type: "shared-resource"
				name: "elasticsearch-operator-ns"
				properties: rules: [{
					selector: resourceTypes: ["Namespace"]
				}]
			},
			{
				type: "topology"
				name: "deploy-elasticsearch-operator"
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
		workflow: {
			steps: [
				{
					name: "create-ns"
					type: "apply-component"
					properties: {
						component: "ns-elasticsearch-operator"
					}
				},
				{
					name: "apply-crds"
					type: "apply-component"
					dependsOn: ["create-ns"]
					properties: {
						component: "olm-crds"
					}
				},
				{
					name: "apply-olm-resources"
					type: "apply-component"
					dependsOn: ["create-ns", "apply-crds"]
					properties: {
						component: "olm-resources"
					}
				},
				{
					name: "apply-es-operator"
					type: "apply-component"
					dependsOn: ["create-ns", "apply-crds", "apply-olm-resources"]
					properties: {
						component: "elasticsearch"
					}
				}
			]
		}

	}
}
