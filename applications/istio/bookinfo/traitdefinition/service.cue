outputs: service: {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		name:   parameter.name
		labels: parameter.labels
	}
	spec: {
		if parameter["ports"] != _|_ {
			ports: parameter.ports
		}
		selector: parameter.labels
	}
}
parameter: {
	ports?: [...{
		port: int
		name: string
	}]
	labels: [string]: string
	name: string
}
