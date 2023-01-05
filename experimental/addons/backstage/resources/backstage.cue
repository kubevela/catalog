package main

backstageapp: {
	type: "webservice"
	name: "backstage"
	properties: {
		image: parameter.image

		if parameter["serviceType"] != _|_ {
			exposeType: parameter["serviceType"]
		}
		ports: [
			{
				port:     7007
				protocol: "TCP"
				expose:   true
			},
		]
	}
	dependsOn: ["backstage-plugin-vela"]
}
