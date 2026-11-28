"crossplane-xrd": {
	type:        "component"
	description: "A Crossplane CompositeResourceDefinition (Crossplane 1): a new composite API and its schema."
	annotations: {}
	labels: {}
	attributes: {
		workload: type: "autodetects.core.oam.dev"
		status: {
			healthPolicy: #"""
				_conditions: *context.output.status.conditions | []
				_wanted: [ "Established", if context.output.spec.claimNames != _|_ {"Offered"}]
				isHealth: len([for w in _wanted for c in _conditions if c.type == w && c.status == "True" {c}]) == len(_wanted)
				"""#
			customStatus: #"""
				_conditions: *context.output.status.conditions | []
				_wanted: [ "Established", if context.output.spec.claimNames != _|_ {"Offered"}]
				_down: [for w in _wanted for c in _conditions if c.type == w && c.status != "True" {c}]
				message: [
					for c in _down if c.message != _|_ if c.message != "" {"\(c.type): \(c.message)"},
					for c in _down if c.reason != _|_ {"\(c.type): \(c.reason)"},
					if len([for w in _wanted for c in _conditions if c.type == w && c.status == "True" {c}]) == len(_wanted) {"Established"},
					"Waiting for Crossplane",
				][0]
				"""#
		}
	}
}

template: {
	output: {
		apiVersion: "apiextensions.crossplane.io/v1"
		kind:       "CompositeResourceDefinition"
		// Crossplane requires <plural>.<group>.
		metadata: name: "\(parameter.names.plural).\(parameter.group)"
		spec: {
			group: parameter.group
			names: parameter.names
			if parameter.claimNames != _|_ {claimNames: parameter.claimNames}
			versions: [for v in parameter.versions {
				name:          v.name
				served:        v.served
				referenceable: v.referenceable
				schema: openAPIV3Schema: v.schema
			}]
			if parameter.defaultComposition != _|_ {defaultCompositionRef: name: parameter.defaultComposition}
		}
	}

	errs: [
		if len([for v in parameter.versions if v.referenceable {v}]) != 1 {"exactly one version must be referenceable"},
		if parameter.scope != _|_ {"scope: Crossplane 1 composites are cluster-scoped; use claimNames for a namespaced claim"},
	]

	parameter: {
		// Refused: a field of the other major's XRD.
		// +ui:label=Scope
		scope?: _
		// +usage=API group of the composite, e.g. platform.example.com
		// +ui:label=Group
		group: string
		// +usage=Kind and plural of the composite
		// +ui:label=Names
		names: {
			// +ui:label=Kind
			kind: string
			// +ui:label=Plural
			plural: string
		}
		// +usage=Claim kind and plural, for a namespaced claim of the cluster-scoped composite
		// +ui:label=Claim Names
		claimNames?: {
			// +ui:label=Kind
			kind: string
			// +ui:label=Plural
			plural: string
		}
		// +usage=Versions of the API; exactly one is referenceable, the one Compositions are written against
		// +ui:label=Versions
		versions: [...{
			// +ui:label=Name
			name: string
			// +ui:label=Served
			served: *true | bool
			// +ui:label=Referenceable
			referenceable: *true | bool
			// +usage=OpenAPI v3 schema of the composite
			// +ui:label=Schema
			schema: {...}
		}] & [_, ...]
		// +usage=Composition used when a composite names none
		// +ui:label=Default Composition
		defaultComposition?: string
	}
}
