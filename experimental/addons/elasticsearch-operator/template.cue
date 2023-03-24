package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	spec: {
		components: [
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
					name: "apply-crds"
					type: "apply-component"
					properties: {
						component: "olm-crds"
					}
				},
				{
					name: "apply-olm-resources"
					type: "apply-component"
					dependsOn: ["apply-crds"]
					properties: {
						component: "olm-resources"
					}
				},
				{
					name: "apply-es-operator"
					type: "apply-component"
					dependsOn: ["apply-olm-resources"]
					properties: {
						component: "elasticsearch"
					}
				},
			]
		}
	}
}
