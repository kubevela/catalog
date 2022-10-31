"prometheus-scrape": {
	alias: ""
	annotations: {}
	attributes: podDisruptive: false
	description: "Expose port and allow prometheus to scrape the service."
	labels: "ui-hidden": "true"
	type: "trait"
}

template: {
	outputs: service: {
		apiVersion: "v1"
		kind:       "Service"
		metadata: name: context.name + "-prometheus-scrape"
		metadata: annotations: {
			"prometheus.io/port":   "\(parameter.port)"
			"prometheus.io/scrape": "true"
			"prometheus.io/path":   parameter.path
		}
		spec: {
			if parameter.selector != _|_ {
				selector: parameter.selector
			}
			if parameter.selector == _|_ {
				selector: "app.oam.dev/component": context.name
			}
			ports: [{
				port:       parameter.port
				targetPort: parameter.port
			}]
			type: parameter.type
		}
	}
	parameter: {
		// +usage=Specify the port to be scraped
		port: *8080 | int
		// +usage=Specify the path to be scraped
		path: *"/metrics" | string
		selector?: [string]: string
		type: *"ClusterIP" | string
	}
}
