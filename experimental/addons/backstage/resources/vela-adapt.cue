package main

adaptor: {
	type: "webservice"
	name: "backstage-plugin-vela"
	properties: {
		image: "oamdev/backstage-plugin-kubevela@sha256:a97cfd2d94968e32962f5c1a6d7cee3c4e4b874654d577675c14706d7e821d71"
		if parameter["serviceType"] != _|_ {
			exposeType: parameter["serviceType"]
		}
		ports: [
			{
				port:     8080
				protocol: "TCP"
				expose:   true
			},
		]
	}
	traits: [{
		type: "service-account"
		properties: {
			name:   "vela-app-read"
			create: true
			privileges: [ for p in _clusterPrivileges {
				scope: "cluster"
				{p}
			}]
		}
	}, {
		type: "resource"
		properties: {
			cpu:    parameter["cpu"]
			memory: parameter["memory"]
		}
	}]
}

_clusterPrivileges: [{
	apiGroups: ["core.oam.dev"]
	resources: ["applications"]
	verbs: ["list", "watch"]
}]
