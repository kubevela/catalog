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
			workflow,
			additionalPrivileges,
		]
		policies: [
			{
				type: "shared-resource"
				name: "shared-resource"
				properties: rules: [{
					selector: resourceTypes: ["CustomResourceDefinition", "ServiceAccount", "ClusterRoleBinding", "Role", "RoleBinding"]
				}]
			},
			{
				type: "take-over"
				name: "take-over-resource"
				properties: rules: [{
					selector: resourceTypes: ["CustomResourceDefinition", "ServiceAccount", "ClusterRoleBinding", "Role", "RoleBinding"]
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
			{
				type: "apply-once"
				name: "not-keep-resource"
				properties: {
					rules: [{
						selector: resourceTypes: ["CustomResourceDefinition", "ServiceAccount", "ClusterRoleBinding", "Role", "RoleBinding"]
						strategy: {
							path: ["*"]
						}
					}]
				}
			},
		]
	}
}
