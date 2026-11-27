"elasticsearch-cluster-expose": {
	annotations: {}
	attributes: {
		appliesToWorkloads: []
		conflictsWith: []
		podDisruptive:   false
		workloadRefPath: ""
	}
	description: "elasticsearch cluster expose trait."
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
		port: *9200 | int
		//+usage=targetPort number on which application is running in the resource.
		targetPort: *9200 | int
		//+usage=Port number on which application to expose.
		selector: *{
			"elasticsearch.k8s.elastic.co/statefulset-name": "elasticsearch-cluster-es-default"
		} | {...}
	}
}
