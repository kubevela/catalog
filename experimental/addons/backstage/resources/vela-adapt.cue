package main

adaptor: {
	type: "webservice"
	name: "backstage-plugin-vela"
	properties: {
		image: "wonderflow/backstage-plugin-kubevela:v0.3"
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
