output: {
	type: "k8s-objects"
	properties: {
		objects: [{
			apiVersion: "core.oam.dev/v1beta1"
			kind: "Application"
			metadata: {
				name: "dex-config"
				namespace: "vela-system"
			}
			spec: {
				components: [{
					name: "dex-config"
					type: "dex-config"
					properties: {
						staticClients: [{
							id: "velaux"
							if parameter.velaux != _|_ {
								redirectURIS: [parameter.velaux + "/callback"]
							}
							name: "VelaUX"
							secret: "velaux-secret"
						}]
						enablePasswordDB: true
						if parameter.velaux != _|_ {
							issuer: parameter.velaux + "/dex"
						}
						storage: type: "memory"
						web: http: "0.0.0.0:5556"
					}
				}]
			}
		}]
	}
}
