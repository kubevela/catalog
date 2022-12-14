package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	metadata: {
		name:      const.name
		namespace: "vela-system"
	}
	spec: {
		components: [
			o11yNamespace,
			processExporterConfig,
			processExporter,
		]
		policies: commonPolicies
	}
}
