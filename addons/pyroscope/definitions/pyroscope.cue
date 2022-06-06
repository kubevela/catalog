pyroscope: {
        attributes: {
                appliesToWorkloads: ["*"]
                podDisruptive:   false
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
					name: "server"
					value: parameter.server
		 	},
		 	{
					name: "appName"
					if parameter.appName != _|_ {
 						value: parameter.appName
					}
					if parameter.appName == _|_ {
 						value: context.name
					}
		 	},
		 	{
					name: "logger"
					value: parameter.logger
		 	}]
	},...]
	parameter: {
		server: string
		appName?: string
		logger: string
	}
}