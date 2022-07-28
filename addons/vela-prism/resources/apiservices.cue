package main

apiServices: {
	type: "k8s-objects"
	name: "vela-prism-apiservices"
	properties: objects: [{
		apiVersion: "apiregistration.k8s.io/v1"
		kind:       "APIService"
		metadata: name: "v1alpha1.prism.oam.dev"
		spec: {
			version:              "v1alpha1"
			group:                "prism.oam.dev"
			groupPriorityMinimum: 2000
			versionPriority:      10
			service: {
				name:      "vela-prism"
				namespace: parameter.namespace
				port:      9443
			}
		}
	}, {
		apiVersion: "apiregistration.k8s.io/v1"
		kind:       "APIService"
		metadata: name: "v1alpha1.o11y.prism.oam.dev"
		spec: {
			version:              "v1alpha1"
			group:                "o11y.prism.oam.dev"
			groupPriorityMinimum: 2000
			versionPriority:      10
			service: {
				name:      "vela-prism"
				namespace: parameter.namespace
				port:      9443
			}
		}
	}]
}
