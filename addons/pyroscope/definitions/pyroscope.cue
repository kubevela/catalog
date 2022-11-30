pyroscope: {
	attributes: {
		appliesToWorkloads: ["*"]
		podDisruptive: false
	}
	description: ""
	labels: {}
	type: "trait"
}

template: {
	// +patchStrategy=jsonMergePatch
	patch: spec: template: spec: containers: [{
		env: [
			{
				name:  "PYROSCOPE_SERVER_ADDRESS"
				value: parameter.server
			},
			{
				name: "PYROSCOPE_APP_NAME"
				if parameter.appName != _|_ {
					value: parameter.appName
				}
				if parameter.appName == _|_ {
					value: context.name
				}
			},
			{
				name:  "PYROSCOPE_LOGGER"
				value: parameter.logger
			}]
	}, ...]
	parameter: {
		server:   string
		appName?: string
		logger:   string
	}
}
