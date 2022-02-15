output: {
	type: "webservice"
	properties: {
		if parameter["repo"] == _|_ {
			image: "oamdev/velaux:" + parameter["version"]
		}

		if parameter["repo"] != _|_ {
			image: parameter["repo"] + "/" + "oamdev/velaux:" + parameter["version"]
		}

		if parameter["imagePullSecrets"] != _|_ {
			imagePullSecrets: parameter["imagePullSecrets"]
		}

		ports: [
			{
				port:     80
				protocol: "TCP"
				expose:   true
			},
		]
		if parameter["serviceType"] != _|_ {
			exposeType: parameter["serviceType"]
		}
		env: [
			{
				name:  "KUBEVELA_API_URL"
				value: "apiserver.vela-system:8000"
			},
		]
	}
	if parameter["domain"] != _|_ {
		traits: [
			{
				type: "gateway"
				properties: {
					domain: parameter["domain"]
					http: {
						"/": 80
					}
					class: "nginx"
				}
			},
		]
	}
	dependsOn: ["apiserver"]
}
