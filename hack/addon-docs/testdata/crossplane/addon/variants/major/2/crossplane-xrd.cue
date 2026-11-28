"crossplane-xrd": {
	type:        "component"
	description: "A Crossplane CompositeResourceDefinition (Crossplane 2): a new composite API and its schema."
	annotations: {}
	labels: {}
	attributes: {
		workload: type: "autodetects.core.oam.dev"
		status: {
			healthPolicy: #"""
				_conditions: *context.output.status.conditions | []
				_wanted: ["Established", if context.output.spec.claimNames != _|_ {"Offered"}]
				isHealth: len([for w in _wanted for c in _conditions if c.type == w && c.status == "True" {c}]) == len(_wanted)
				"""#
			customStatus: #"""
				_conditions: *context.output.status.conditions | []
				_wanted: ["Established", if context.output.spec.claimNames != _|_ {"Offered"}]
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
		// Crossplane 2 serves LegacyCluster, the 1.x shape with claims, only from the v1 API.
		apiVersion: [if parameter.scope == "LegacyCluster" {"apiextensions.crossplane.io/v1"}, "apiextensions.crossplane.io/v2"][0]
		kind: "CompositeResourceDefinition"
		// Crossplane requires <plural>.<group>.
		metadata: name: "\(parameter.names.plural).\(parameter.group)"
		spec: {
			group: parameter.group
			names: parameter.names
			scope: parameter.scope
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
		if parameter.claimNames != _|_ && parameter.scope != "LegacyCluster" {"claimNames needs scope LegacyCluster: Crossplane 2 offers claims only on the 1.x shape of XRD; a Namespaced composite is used directly in its namespace"},
	]

	parameter: {
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
		// +usage=Namespaced composites live beside the Applications that use them; Cluster ones are cluster-wide; LegacyCluster keeps a 1.x claim API
		// +ui:label=Scope
		scope: *"Namespaced" | "Cluster" | "LegacyCluster"
		// +usage=Claim kind and plural; only with scope LegacyCluster, the 1.x shape kept for existing claim APIs
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
