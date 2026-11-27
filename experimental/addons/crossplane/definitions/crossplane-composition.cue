"crossplane-composition": {
	type:        "component"
	description: "A Crossplane Composition: the pipeline of functions that builds a composite resource."
	annotations: {}
	labels: {}
	attributes: {
		workload: type: "autodetects.core.oam.dev"
		// Crossplane reports a Composition's verdict on its CompositionRevision, which this definition does not render,
		// so there is no health to read: the message and details say what it builds.
		status: {
			customStatus: #"""
				import "strings"

				_steps: [for s in context.output.spec.pipeline {s.step}]
				_count: [if len(_steps) == 1 {"1 step"}, "\(len(_steps)) steps"][0]
				message: "Builds \(context.output.spec.compositeTypeRef.kind) in \(_count): \(strings.Join(_steps, ", "))"
				"""#
			details: #"""
				import "strings"

				composite: "\(context.output.spec.compositeTypeRef.apiVersion) \(context.output.spec.compositeTypeRef.kind)"
				functions: strings.Join([for s in context.output.spec.pipeline {s.functionRef.name}], ", ")
				"""#
		}
	}
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
			// +usage=API group and version of the composite, e.g. example.org/v1
			// +ui:label=API Version
			apiVersion: string
			// +usage=Kind of the composite, e.g. XDatabase
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
