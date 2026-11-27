"crossplane-runtime-config": {
	type:        "trait"
	description: "Runs a Crossplane Provider or Function's pods with its own service account, replicas, resources and flags, through a DeploymentRuntimeConfig made for it."
	annotations: {}
	labels: {}
	attributes: {
		appliesToWorkloads: ["providers.pkg.crossplane.io", "functions.pkg.crossplane.io"]
		podDisruptive: true
		// A trait's status sees only its own outputs, not the package it patches, so the package's health is on its component.
		status: {
			customStatus: #"""
				message: "The package runs with runtime config \(context.name)"
				"""#
			details: #"""
				runtimeConfig: context.name
				"""#
		}
	}
}

template: {
	_ref: {apiVersion: "pkg.crossplane.io/v1beta1", kind: "DeploymentRuntimeConfig", name: context.name}
	_pods: parameter.replicas != _|_ || parameter.resources != _|_ || parameter.args != _|_ || parameter.nodeSelector != _|_

	errs: [
		if context.output.spec.runtimeConfigRef != _|_ {
			"runtimeConfig names \(context.output.spec.runtimeConfigRef.name) already: drop it, or this trait"
		},
	]

	outputs: "runtime-config": {
		apiVersion: _ref.apiVersion
		kind:       _ref.kind
		metadata: name: _ref.name
		spec: {
			if _pods {
				deploymentTemplate: spec: {
					// The Deployment schema requires a selector; Crossplane fills in its own.
					selector: {}
					if parameter.replicas != _|_ {replicas: parameter.replicas}
					template: spec: {
						if parameter.nodeSelector != _|_ {nodeSelector: parameter.nodeSelector}
						// Crossplane merges settings into the package's container by this name.
						containers: [{
							name: "package-runtime"
							if parameter.args != _|_ {args: parameter.args}
							if parameter.resources != _|_ {resources: parameter.resources}
						}]
					}
				}
			}
			if parameter.serviceAccount != _|_ {
				serviceAccountTemplate: metadata: {
					if parameter.serviceAccount.name != _|_ {name: parameter.serviceAccount.name}
					if parameter.serviceAccount.annotations != _|_ {annotations: parameter.serviceAccount.annotations}
				}
			}
		}
	}

	patch: {
		if context.output.spec.runtimeConfigRef == _|_ {spec: runtimeConfigRef: _ref}
	}

	#Resources: {
		// +usage=CPU, in cores or millicores, e.g. 500m
		// +ui:label=CPU
		cpu?: string & =~"^[0-9]+(\\.[0-9]+)?m?$" | number & >=0
		// +usage=Memory, e.g. 512Mi
		// +ui:label=Memory
		memory?: string & =~"^[0-9]+(\\.[0-9]+)?([KMGTPE]i|[kMGTPE])?$"
	}

	parameter: {
		// +usage=The service account the package's pods run as. Its annotations carry a cloud role, e.g. eks.amazonaws.com/role-arn for IRSA
		// +ui:label=Service Account
		serviceAccount?: {
			// +usage=Name of the service account, if not the one Crossplane makes for the package
			// +ui:label=Name
			name?: string
			// +usage=Annotations on the service account
			// +ui:label=Annotations
			annotations?: [string]: string
		}
		// +usage=Replicas of the package's Deployment
		// +ui:label=Replicas
		replicas?: int & >=1
		// +usage=CPU and memory requests and limits for the package's container
		// +ui:label=Resources
		resources?: {
			// +usage=What the container is guaranteed
			// +ui:label=Requests
			requests?: #Resources
			// +usage=The most the container may use
			// +ui:label=Limits
			limits?: #Resources
		}
		// +usage=Extra flags for the package's container, e.g. --debug or --poll=10m
		// +ui:label=Args
		args?: [...string]
		// +usage=Node labels the package's pods must run on
		// +ui:label=Node Selector
		nodeSelector?: [string]: string
	}
}
