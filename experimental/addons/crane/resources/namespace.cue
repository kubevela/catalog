output: {
	type: "k8s-objects"
	properties: {
		objects: [
			{
				apiVersion: "v1"
				kind:       "Namespace"
				metadata: name: "crane-system"
			},
		]
	}
}
