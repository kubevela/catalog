"ocm-resource": {
	type:        "component"
	description: "Resolves and verifies a resource of an OCM component version resolved by an ocm-component."
	labels: {}
	annotations: {}
	attributes: {
		workload: type: "autodetects.core.oam.dev"
		status: {
			healthPolicy: #"""
				isHealth: *false | bool
				if context.output.status.conditions != _|_ {
					isHealth: len([ for c in context.output.status.conditions if c.type == "Ready" && c.status == "True" {c}]) > 0
				}
				"""#
			customStatus: #"""
				message: *"Resolving" | string
				if context.output.status.resource.name != _|_ && context.output.status.component.version != _|_ {
					message: context.output.status.resource.name + " from " + context.output.status.component.component + ":" + context.output.status.component.version
				}
				"""#
		}
	}
}

template: {
	output: {
		apiVersion: "delivery.ocm.software/v1alpha1"
		kind:       "Resource"
		metadata: name: context.name
		spec: {
			componentRef: name: parameter.componentRef
			resource: byReference: {
				resource: parameter.resource
				if parameter.referencePath != _|_ {
					referencePath: parameter.referencePath
				}
			}
			verificationPolicy: parameter.verificationPolicy
			if parameter.additionalStatusFields != _|_ {
				additionalStatusFields: parameter.additionalStatusFields
			}
			if parameter.ocmConfig != _|_ {
				ocmConfig: parameter.ocmConfig
			}
		}
	}

	parameter: {
		// +usage=The name of the ocm-component in this application that resolves the component version
		componentRef: string
		// +usage=The identity of the resource in the component version, for example {name: "chart"}
		resource: {
			name: string
			[string]: string
		}
		// +usage=Identities of component references to follow to reach the resource
		referencePath?: [...{[string]: string}]
		// +usage=Whether to verify the resource digest
		verificationPolicy: *"Always" | "Never"
		// +usage=CEL expressions evaluated against the resource, published under status.additional, for example {image: "resource.access.imageReference"}
		additionalStatusFields?: {...}
		// +usage=References to secrets or config maps with OCM configuration, such as credentials
		ocmConfig?: [...{...}]
	}
}
