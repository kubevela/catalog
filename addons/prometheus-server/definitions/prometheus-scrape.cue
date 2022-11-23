"prometheus-scrape": {
	alias: ""
	annotations: {}
	attributes: {
		podDisruptive: false
		appliesToWorkloads: ["*"]
	}
	description: "Expose port and allow prometheus to scrape the service."
	type:        "trait"
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
		// +usage=Specify the selector of the service. In most cases, you don't need to set it.
		selector?: [string]: string
		// +usage=Specify the service type.
		type: *"ClusterIP" | string
	}
}
