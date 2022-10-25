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
