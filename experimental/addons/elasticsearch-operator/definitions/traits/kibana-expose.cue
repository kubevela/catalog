"kibana-expose": {
	annotations: {}
	attributes: {
		appliesToWorkloads: []
		conflictsWith: []
		podDisruptive:   false
		workloadRefPath: ""
	}
	description: "kibana expose trait."
	labels: {}
	type: "trait"
}

template: {
	outputs: service: {
		apiVersion: "v1"
		kind:       "Service"
		spec: {
			type: parameter.type
			ports: [
				{
					port:       parameter.port
					targetPort: parameter.targetPort
				},
			]
			selector: parameter.selector
		}
	}
	parameter: {
		//+usage=Port number on which application to expose.
		type: *"ClusterIP" | string
		//+usage=Port number on which application to expose.
		port: *5601 | int
		//+usage=targetPort number on which application is running in the resource.
		targetPort: *5601 | int
		//+usage=Port number on which application to expose.
		selector: *{
			"kibana.k8s.elastic.co/name": "kibana"
		} | {...}
	}
}
