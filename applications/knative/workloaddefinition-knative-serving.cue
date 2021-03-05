output: {
	apiVersion: "serving.knative.dev/v1"
	kind:       "Service"
	spec: {
		template:
			spec:
				containers: [{
					image: parameter.image
					env:   parameter.env
				}]
	}
}
parameter: {
	image: string
	env?: [...{
		// +usage=Environment variable name
		name: string
		// +usage=The value of the environment variable
		value?: string
		// +usage=Specifies a source the value of this var should come from
		valueFrom?: {
			// +usage=Selects a key of a secret in the pod's namespace
			secretKeyRef: {
				// +usage=The name of the secret in the pod's namespace to select from
				name: string
				// +usage=The key of the secret to select from. Must be a valid secret key
				key: string
			}
		}
	}]
}
