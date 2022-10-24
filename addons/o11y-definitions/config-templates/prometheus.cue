metadata: {
	name:        "prometheus-server"
	alias:       "Prometheus Server"
	description: "Config the Prometheus server connectors"
	sensitive:   false
	scope:       "system"
}

template: {
	parameter: {
		// +usage=the Prometheus server address
		url: string
		// +usage=the Auth config for the Prometheus
		auth?: {
			username: string
			password: string
		}
	}
}
