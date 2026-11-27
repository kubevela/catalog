"crossplane-provider": {
	type:        "component"
	description: "A Crossplane Provider package, installed from its OCI image."
	annotations: {}
	labels: {}
	attributes: {
		workload: {
			definition: {
				apiVersion: "pkg.crossplane.io/v1"
				kind:       "Provider"
			}
			type: "providers.pkg.crossplane.io"
		}
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
			details: #"""
				"package": *context.output.status.resolvedPackage | context.output.spec.package
				if context.output.status.currentRevision != _|_ {revision: context.output.status.currentRevision}
				"""#
		}
	}
}

template: {
	_package: [
		if parameter.package != _|_ {parameter.package},
		if parameter.repository != _|_ if parameter.version != _|_ {
			"\(*parameter.registry | "xpkg.crossplane.io")/\(parameter.repository):\(parameter.version)"
		},
	]

	errs: [
		if parameter.package != _|_ && parameter.repository != _|_ {"give package, or repository and version, not both"},
		if parameter.package == _|_ && parameter.repository == _|_ {"give package, or repository and version"},
		if parameter.repository != _|_ && parameter.version == _|_ {"repository needs a version"},
		if parameter.version != _|_ && parameter.repository == _|_ {"version needs a repository"},
		if parameter.package != _|_ && parameter.registry != _|_ {"registry applies to repository and version: put it in package instead"},
	]

	output: {
		apiVersion: "pkg.crossplane.io/v1"
		kind:       "Provider"
		metadata: name: context.name
		spec: {
			if len(_package) == 1 {package: _package[0]}
			if parameter.runtimeConfig != _|_ {
				runtimeConfigRef: {apiVersion: "pkg.crossplane.io/v1beta1", kind: "DeploymentRuntimeConfig", name: parameter.runtimeConfig}
			}
			packagePullPolicy:        parameter.packagePullPolicy
			revisionActivationPolicy: parameter.revisionActivationPolicy
			revisionHistoryLimit:     parameter.revisionHistoryLimit
		}
	}

	parameter: {
		// +usage=Repository of the package on its registry, e.g. crossplane-contrib/provider-aws-s3
		// +ui:placeholder=crossplane-contrib/provider-aws-s3
		// +ui:label=Repository
		repository?: string
		// +usage=Version of the package, a tag such as v2.10.0
		// +ui:placeholder=v2.10.0
		// +ui:label=Version
		version?: string
		// +usage=Registry the repository is on, or a mirror of it. Default: xpkg.crossplane.io
		// +ui:advanced
		// +ui:placeholder=xpkg.crossplane.io
		// +ui:label=Registry
		registry?: string
		// +usage=The whole package reference instead of repository and version, e.g. xpkg.crossplane.io/crossplane-contrib/provider-aws-s3:v2.10.0, or one by digest
		// +ui:advanced
		// +ui:placeholder=xpkg.crossplane.io/crossplane-contrib/provider-aws-s3:v2.10.0
		// +ui:label=Package
		package?: string
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
