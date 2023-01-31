"grafana-access": {
	alias: ""
	annotations: {}
	attributes: podDisruptive: false
	description: "The access credential for grafana."
	attributes: workload: type: "autodetects.core.oam.dev"
	type: "component"
}

template: {
	parameter: {
		// +usage=The name of the grafana instance.
		name: string
		// +usage=The endpoint of the grafana instance.
		endpoint: string
		// +usage=The username for access grafana
		username?: string
		// +usage=The password for access grafana
		password?: string
		// +usage=The usage for access grafana
		token?: string
	}
	output: {
		apiVersion: "o11y.prism.oam.dev/v1alpha1"
		kind:       "Grafana"
		metadata: name: parameter.name
		metadata: annotations: "app.oam.dev/last-applied-configuration": "-"
		spec: {
			endpoint: parameter.endpoint
			access: {
				if parameter.username != _|_ && parameter.password != _|_ {
					username: parameter.username
					password: parameter.password
				}
				if parameter.token != _|_ {
					token: parameter.token
				}
			}
		}
	}
}
