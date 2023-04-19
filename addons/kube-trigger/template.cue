package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	metadata: {
		namespace: const.namespace
	}
	spec: {
		components: [
			crd,
			deployment,
			additionalPrivileges,
			resourceTopology,
		]
		policies: [
			{
				type: "shared-resource"
				name: "shared-resource"
				properties: rules: [{
					selector: resourceTypes: ["CustomResourceDefinition", "ServiceAccount", "ClusterRoleBinding", "Role", "RoleBinding", "Deployment"]
				}]
			},
			{
				type: "take-over"
				name: "take-over-resource"
				properties: rules: [{
					selector: resourceTypes: ["CustomResourceDefinition", "ServiceAccount", "ClusterRoleBinding", "Role", "RoleBinding", "Deployment"]
				}]
			},
			{
				type: "garbage-collect"
				name: "not-gc-CRD"
				properties: {
					rules: [{
						selector: resourceTypes: ["CustomResourceDefinition"]
						strategy: "never"
					},
					]
				}
			},
		]
	}
}
