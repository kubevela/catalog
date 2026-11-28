"sample-app": {
	type:        "component"
	description: "Runs the sample app as a Deployment."
	annotations: {}
	labels: {}
	attributes: workload: definition: {
		apiVersion: "apps/v1"
		kind:       "Deployment"
	}
}

template: {
	output: {
		apiVersion: "apps/v1"
		kind:       "Deployment"
		metadata: name: parameter.secretName
		spec: replicas: parameter.replicas
	}
	parameter: {
		// +usage=Image to run
		image: string
		// +usage=Secret the app reads its keys from
		secretName: *"\(context.name)-keys" | string
		// +usage=Replicas to run
		replicas: *1 | int
		// +immutable
		// +usage=Storage class for its volume, set when it is first deployed
		storageClass?: string
		// +usage=Ports to expose
		ports?: [...{
			// +usage=Port number
			port: int
			// +usage=Protocol
			protocol: *"TCP" | "UDP"
		}]
	}
}
