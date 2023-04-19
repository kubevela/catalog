"postgres-expose": {
	alias: ""
	annotations: {}
	attributes: {
		workload: type: "autodetects.core.oam.dev"
	}
	description: "postgres expose trait"
	labels: {}
	type: "trait"
}

template: {
	outputs: expose: {
		kind:       "Service"
		apiVersion: "v1"
		spec: {
			type: parameter.type
			selector: {
				"application":  "spilo"
				"cluster-name": "postgres"
				"spilo-role":   "master"
				"team": "acid"
			}
			ports: [
				{
					port:       parameter.port
					targetPort: parameter.targetPort
				},
			]
		}
	}
	parameter: {
		type:       *"NodePort" | string
		port:       *5432 | int
		targetPort: *5432 | int
	}
}
