"crossplane-function": {
	type:        "component"
	description: "A Crossplane Function package, installed from its OCI image."
	annotations: {}
	labels: {}
	attributes: {
		workload: type: "autodetects.core.oam.dev"
		status: {
			healthPolicy: #"""
				_conditions: *context.output.status.conditions | []
				isHealth: len([for c in _conditions if (c.type == "Installed" || c.type == "Healthy") && c.status == "True" {c}]) == 2
				"""#
			customStatus: #"""
				_conditions: *context.output.status.conditions | []
				_down: [for c in _conditions if (c.type == "Installed" || c.type == "Healthy") && c.status != "True" {c}]
				message: [
					for c in _down if c.message != _|_ if c.message != "" {"\(c.type): \(c.message)"},
					for c in _down if c.reason != _|_ {"\(c.type): \(c.reason)"},
					if len([for c in _conditions if (c.type == "Installed" || c.type == "Healthy") && c.status == "True" {c}]) == 2 {"Installed and healthy"},
					"Waiting for Crossplane",
				][0]
				"""#
		}
	}
}

template: {
	output: {
		apiVersion: "pkg.crossplane.io/v1"
		kind:       "Function"
		metadata: name: context.name
		spec: {
			package: parameter.package
			if parameter.runtimeConfig != _|_ {
				runtimeConfigRef: {apiVersion: "pkg.crossplane.io/v1beta1", kind: "DeploymentRuntimeConfig", name: parameter.runtimeConfig}
			}
			packagePullPolicy:        parameter.packagePullPolicy
			revisionActivationPolicy: parameter.revisionActivationPolicy
			revisionHistoryLimit:     parameter.revisionHistoryLimit
		}
	}

	parameter: {
		// +usage=OCI image of the package, e.g. xpkg.crossplane.io/crossplane-contrib/function-patch-and-transform:v0.8.2
		// +ui:placeholder=xpkg.crossplane.io/crossplane-contrib/function-patch-and-transform:v0.8.2
		// +ui:label=Package
		package: string
		// +usage=Name of a DeploymentRuntimeConfig for the package's pods
		// +ui:advanced
		// +ui:label=Runtime Config
		runtimeConfig?: string
		// +usage=When to pull the package image
		// +ui:advanced
		// +ui:label=Package Pull Policy
		packagePullPolicy: *"IfNotPresent" | "Always" | "Never"
		// +usage=Automatic activates each new revision; Manual keeps the current one active until you set the new revision's desiredState to Active
		// +ui:advanced
		// +ui:label=Revision Activation Policy
		revisionActivationPolicy: *"Automatic" | "Manual"
		// +usage=Inactive revisions to keep
		// +ui:advanced
		// +ui:label=Revision History Limit
		revisionHistoryLimit: *1 | int & >=0
	}
}
