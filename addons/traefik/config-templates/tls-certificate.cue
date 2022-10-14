"config-tls-certificate": {
	annotations: {
		"alias.config.oam.dev": "TLS Certificate"
		"scope.config.oam.dev": "project"
	}
	attributes: workload: definition: {
		apiVersion: "v1"
		kind:       "Secret"
	}
	description: "This component definition is designed to manage the TLS certificate"
	labels: {
		"ui-hidden":                    "true"
		"catalog.config.oam.dev":       "velacore-config"
		"multi-cluster.config.oam.dev": "true"
		"type.config.oam.dev":          "tls-certificate"
	}
	type: "component"
}

metadata: {
	name:       "tls-certificate"
	alias:      "TLS Certificate"
	definition: "Manage the TLS certificate"
	scope:      "project"
	sensitive:  true
}

template: {
	output: {
		apiVersion: "v1"
		kind:       "Secret"
		metadata: {
			name:      context.name
			namespace: context.namespace
		}
		data: {
			"tls.crt": parameter.cert
			"tls.key": parameter.key
		}
	}
	parameter: {
		// +usage=The certificate public key encrypted by base64
		cert: string
		// +usage=The certificate privite key encrypted by base64
		key: string
	}
}
