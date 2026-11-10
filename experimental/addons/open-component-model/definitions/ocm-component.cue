"ocm-component": {
	type:        "component"
	description: "Resolves an OCM component version from an OCM repository."
	labels: {}
	annotations: {}
	attributes: {
		workload: type: "autodetects.core.oam.dev"
		status: {
			healthPolicy: #"""
				_ready: [ for o in [context.output, context.outputs.repository] {
					*false | bool
					if o.status.conditions != _|_ {
						len([ for c in o.status.conditions if c.type == "Ready" && c.status == "True" {c}]) > 0
					}
				}]
				isHealth: len([ for r in _ready if !r {r}]) == 0
				"""#
			customStatus: #"""
				message: *"Resolving" | string
				if context.output.status.component.version != _|_ {
					message: context.output.status.component.component + ":" + context.output.status.component.version
				}
				"""#
		}
	}
}

template: {
	output: {
		apiVersion: "delivery.ocm.software/v1alpha1"
		kind:       "Component"
		metadata: name: context.name
		spec: {
			repositoryRef: name: context.name
			component:       parameter.component
			semver:          parameter.semver
			downgradePolicy: parameter.downgradePolicy
			interval:        parameter.interval
			if parameter.semverFilter != _|_ {
				semverFilter: parameter.semverFilter
			}
			if parameter.ocmConfig != _|_ {
				ocmConfig: parameter.ocmConfig
			}
		}
	}

	outputs: repository: {
		apiVersion: "delivery.ocm.software/v1alpha1"
		kind:       "Repository"
		metadata: name: context.name
		spec: {
			repositorySpec: parameter.repository
			interval:       parameter.interval
			if parameter.ocmConfig != _|_ {
				ocmConfig: parameter.ocmConfig
			}
		}
	}

	parameter: {
		// +usage=The OCM repository specification, for example {type: "OCIRegistry", baseUrl: "ghcr.io/my-org"}
		repository: {...}
		// +usage=The name of the OCM component, for example "ocm.software/my-app"
		component: string
		// +usage=The semver constraint the component version must match, for example ">=1.0.0"
		semver: string
		// +usage=A regex that further filters the versions matching the semver constraint
		semverFilter?: string
		// +usage=Whether the component may be downgraded to a lower version
		downgradePolicy: *"Deny" | "Allow"
		// +usage=How often the repository is checked for new component versions
		interval: *"10m" | string
		// +usage=References to secrets or config maps with OCM configuration, such as credentials
		ocmConfig?: [...{...}]
	}
}
