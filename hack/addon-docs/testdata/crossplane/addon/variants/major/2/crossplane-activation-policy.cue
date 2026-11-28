"crossplane-activation-policy": {
	type:        "component"
	description: "A Crossplane 2 ManagedResourceActivationPolicy: which providers' managed resources are switched on."
	annotations: {}
	labels: {}
	attributes: workload: type: "autodetects.core.oam.dev"
}

template: {
	output: {
		apiVersion: "apiextensions.crossplane.io/v1alpha1"
		kind:       "ManagedResourceActivationPolicy"
		metadata: name: context.name
		spec: activate: parameter.activate
	}

	parameter: {
		// +usage=ManagedResourceDefinitions to activate, by name or wildcard, e.g. *.s3.aws.m.upbound.io
		// +ui:label=Activate
		activate: [string, ...string]
	}
}
