"crossplane-composition": {
	type:        "component"
	description: "A Crossplane Composition: the pipeline of functions that builds a composite resource."
	annotations: {}
	labels: {}
	attributes: workload: type: "autodetects.core.oam.dev"
}

template: {
	output: {
		apiVersion: "apiextensions.crossplane.io/v1"
		kind:       "Composition"
		metadata: name: context.name
		spec: {
			compositeTypeRef: parameter.compositeTypeRef
			// Pipeline is the mode both majors run; Crossplane 2 removed the native patch-and-transform Resources mode.
			mode: "Pipeline"
			pipeline: [for s in parameter.pipeline {
				step: s.step
				functionRef: name: s.function
				if s.input != _|_ {input: s.input}
			}]
		}
	}

	parameter: {
		// +usage=The composite resource this Composition builds, as its XRD defines it
		// +ui:label=Composite Type
		compositeTypeRef: {
			// +ui:label=API Version
			apiVersion: string
			// +ui:label=Kind
			kind: string
		}
		// +usage=Steps run in order, each calling a Function
		// +ui:rowKey=step
		// +ui:itemLabel=step
		// +ui:label=Pipeline
		pipeline: [...{
			// +usage=Name of the step
			// +ui:label=Step
			step: string
			// +usage=Name of the Function, as installed with crossplane-function
			// +ui:placeholder=function-patch-and-transform
			// +ui:label=Function
			function: string
			// +usage=The function's input
			// +ui:label=Input
			input?: {...}
		}] & [_, ...]
	}
}
