metadata: {
	name:        "loki"
	alias:       "Loki"
	description: "Config the Loki connectors"
	sensitive:   false
	scope:       "system"
}

template: {
	parameter: {
		// +usage=the Prometheus server address
		url: string
	}
}
