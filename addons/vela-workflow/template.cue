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
				name: "shared-CRD"
				properties: rules: [{
					selector: resourceTypes: ["CustomResourceDefinition"]
				}]
			},
			{
				type: "take-over"
				name: "take-over-CRD"
				properties: rules: [{
					selector: resourceTypes: ["CustomResourceDefinition"]
				}]
			},
			{
				type: "garbage-collect"
				name: "not-gc-CRD-namespace"
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
				name: "not-keep-CRD"
				properties: {
					rules: [{
						selector: resourceTypes: ["CustomResourceDefinition"]
						strategy: {
							path: ["*"]
						}
					}]
				}
			},
		]
	}
}
