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
		metadata: name: context.name
		metadata: annotations: {
			"prometheus.io/port":   "\(parameter.port)"
			"prometheus.io/scrape": "true"
			"prometheus.io/path":   parameter.path
		}
		spec: {
			selector: "app.oam.dev/component": context.name
			ports: [{
				port:       parameter.port
				targetPort: parameter.port
			}]
			type: "ClusterIP"
		}
	}
	parameter: {
		// +usage=Specify the port to be scraped
		port: *8080 | int
		// +usage=Specify the path to be scraped
		path: *"/metrics" | string
	}
}
