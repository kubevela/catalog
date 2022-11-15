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
	}
}
