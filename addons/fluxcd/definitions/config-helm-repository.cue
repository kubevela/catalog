"config-helm-repository": {
	type: "component"
	annotations: {
		"alias.config.oam.dev": "Helm Repository"
	}
	labels: {
		"catalog.config.oam.dev":       "velacore-config"
		"type.config.oam.dev":          "helm-repository"
		"multi-cluster.config.oam.dev": "true"
	}
	description: "Config information to authenticate helm chart repository"
	attributes: workload: type: "autodetects.core.oam.dev"
}

template: {
	output: {
		apiVersion: "v1"
		kind:       "Secret"
		metadata: {
			name:      context.name
			namespace: context.namespace
			labels: {
				"config.oam.dev/catalog":       "velacore-config"
				"config.oam.dev/type":          "helm-repository"
				"config.oam.dev/multi-cluster": "true"
				"config.oam.dev/identifier":    parameter.url
				"config.oam.dev/sub-type":      parameter.type
			}
		}
		type: "Opaque"

		stringData: url: parameter.url
	}

	parameter: {
		// +usage=Helm Chart repository url
		url: string
		// +usage=Config type
		type: *"https" | string
	}
}
