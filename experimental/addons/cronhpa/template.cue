package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	spec: {
		components: [ {
			type: "k8s-objects"
			name: "cronhpa-rbac"
			properties: objects: [
				controllerClusterRole,
				controllerRoleBinding,
			]
		},
			{
				type: "k8s-objects"
				name: "cronhpa-CRD"
				properties: objects: [
					cronhpaCRD,
				]
			},
			cronController]
		policies: [{
			type: "topology"
			name: "deploy-topology"
			properties: {
				if parameter.clusters != _|_ {
					clusters: parameter.clusters
				}
				if parameter.clusters == _|_ {
					clusterLabelSelector: {}
				}
				namespace: parameter.namespace
			}
		}, {
			type: "garbage-collect"
			name: "not-gc-CRD"
			properties: {
				rules: [{
					selector: resourceTypes: ["CustomResourceDefinition"]
					strategy: "never"
				},
				]
			}
		}]
	}
}
