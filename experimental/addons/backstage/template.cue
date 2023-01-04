package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	metadata: {
		name:      parameter.name
		namespace: "vela-system"
	}
	spec: {
		components: [adaptor, backstage]
		policies: []
	}
}
