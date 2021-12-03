output: {
	type: "webservice"
	properties: {
		image: parameter["repo"] + "oamdev/velaux:" + parameter["version"]
		ports: [
			{
				port:     80
				protocol: "TCP"
				expose:   true
			},
		]
		env: [
			{
				name:  "KUBEVELA_API_URL"
				value: "apiserver-cue.vela-system:8000"
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
}
