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
	traits: [{
		type: "resource"
		properties: {
			cpu:    parameter.backstageapp["cpu"]
			memory: parameter.backstageapp["memory"]
		}
	}]
	dependsOn: ["backstage-plugin-vela"]
}
