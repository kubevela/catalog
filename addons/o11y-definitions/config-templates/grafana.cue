metadata: {
	name:        "grafana"
	alias:       "Grafana"
	description: "Config the grafana server connectors"
	sensitive:   false
	scope:       "system"
}

template: {
	outputs: {
		"grafana": {
			apiVersion: "o11y.prism.oam.dev/v1alpha1"
			kind:       "Grafana"
			metadata: {
				name: context.name
			}
			spec: {
				endpoint: parameter.endpoint
				if parameter.auth != _|_ {
					access: {
						if parameter.auth.username != _|_ && parameter.auth.password != _|_ {
							username: parameter.auth.username
							password: parameter.auth.password
						}
						if parameter.auth.token != _|_ {
							token: parameter.auth.token
						}
					}
				}
			}
		}
	}
	parameter: {
		// +usage=The endpoint of the grafana instance.
		endpoint: string
		// +usage=the Auth config for the Grafana
		auth?: {
			// +usage=The username for access grafana
			username?: string
			// +usage=The password for access grafana
			password?: string
			// +usage=The usage for access grafana
			token?: string
		}
	}
}
