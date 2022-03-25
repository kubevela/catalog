output: {
	type: "dex-config"
	properties: {
		staticClients: [{
			id: "velaux"
			if parameter.redirectURI != _|_ {
				redirectURIS: [parameter.redirectURI]
			}
			name: "VelaUX"
			secret: "velaux-secret"
		}]
		enablePasswordDB: true
		if parameter.issuer != _|_ {
			issuer: parameter.issuer
		}
		storage: type: "memory"
		web: http: "0.0.0.0:5556"
	}
}
