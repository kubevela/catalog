"crossplane-activation-policy": {
	type:        "component"
	description: "A Crossplane 2 ManagedResourceActivationPolicy: which providers' managed resources are switched on."
	annotations: {}
	labels: {}
	attributes: {
		workload: type: "autodetects.core.oam.dev"
		status: {
			healthPolicy: #"""
				_conditions: *context.output.status.conditions | []
				isHealth: len([for c in _conditions if c.type == "Healthy" && c.status == "True" {c}]) > 0
				"""#
			customStatus: #"""
				import "strings"

				_conditions: *context.output.status.conditions | []
				_healthy: [for c in _conditions if c.type == "Healthy" {c}]
				_activated: *context.output.status.activated | []
				message: [
					for c in _healthy if c.status == "True" if len(_activated) == 1 {"Activated 1 managed resource"},
					for c in _healthy if c.status == "True" if len(_activated) > 1 {"Activated \(len(_activated)) managed resources"},
					for c in _healthy if c.status == "True" {"Nothing matches \(strings.Join(context.output.spec.activate, ", ")) yet: is its provider installed?"},
					for c in _healthy if c.message != _|_ if c.message != "" {c.message},
					for c in _healthy if c.reason != _|_ {c.reason},
					"Waiting for Crossplane",
				][0]
				"""#
			details: #"""
				import "strings"

				if context.output.status.activated != _|_ if len(context.output.status.activated) > 0 {
					activated: strings.Join(context.output.status.activated, ", ")
				}
				"""#
		}
	}
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
