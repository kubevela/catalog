output: {
	type: "k8s-objects"
	properties: {
		objects: {
			apiVersion: "v1"
			kind:       "ConfigMap"
			metadata: {
				name:      "exampleinput"
				namespace: "default"
			}
			data: input: parameter.example
		}
	}
}
