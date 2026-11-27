import "vela/test"

_runtime: {
	definition: "../definitions/crossplane-runtime-config"
	context: {name: "provider-aws-s3", namespace: "vela-system"}
	workload: {
		apiVersion: "pkg.crossplane.io/v1"
		kind:       "Provider"
		metadata: name: "provider-aws-s3"
		spec: package: "xpkg.crossplane.io/crossplane-contrib/provider-aws-s3:v2.10.0"
	}
}

"a runtime config named after the package, and the package pointed at it": test.#TraitRender & _runtime & {
	parameter: args: ["--debug"]
	expect: {
		outputs: "runtime-config": {
			apiVersion: "pkg.crossplane.io/v1beta1"
			kind:       "DeploymentRuntimeConfig"
			metadata: name: "provider-aws-s3"
			spec: deploymentTemplate: spec: {
				selector: {}
				template: spec: containers: [{name: "package-runtime", args: ["--debug"]}]
			}
		}
		output: spec: runtimeConfigRef: {apiVersion: "pkg.crossplane.io/v1beta1", kind: "DeploymentRuntimeConfig", name: "provider-aws-s3"}
	}
}

"a service account with a cloud role, and nothing else": test.#TraitRender & _runtime & {
	parameter: serviceAccount: annotations: "eks.amazonaws.com/role-arn": "arn:aws:iam::123456789012:role/crossplane-s3"
	expect: outputs: "runtime-config": spec: {
		serviceAccountTemplate: metadata: annotations: "eks.amazonaws.com/role-arn": "arn:aws:iam::123456789012:role/crossplane-s3"
		deploymentTemplate?: _|_
	}
}

"a service account of a given name": test.#TraitRender & _runtime & {
	parameter: serviceAccount: name: "crossplane-s3"
	expect: outputs: "runtime-config": spec: serviceAccountTemplate: metadata: name: "crossplane-s3"
}

"replicas, resources and node placement go on the package's pods": test.#TraitRender & _runtime & {
	parameter: {
		replicas: 2
		resources: {requests: {cpu: "100m", memory: "256Mi"}, limits: memory: "1Gi"}
		nodeSelector: pool: "system"
	}
	expect: outputs: "runtime-config": spec: deploymentTemplate: spec: {
		selector: {}
		replicas: 2
		template: spec: {
			nodeSelector: pool: "system"
			containers: [{
				name: "package-runtime"
				resources: {requests: {cpu: "100m", memory: "256Mi"}, limits: memory: "1Gi"}
				args?: _|_
			}]
		}
	}
}

"refuses a package that already names a runtime config": test.#TraitRender & _runtime & {
	workload: spec: runtimeConfigRef: {apiVersion: "pkg.crossplane.io/v1beta1", kind: "DeploymentRuntimeConfig", name: "shared"}
	parameter: args: ["--debug"]
	expect: error: =~"runtimeConfig names shared already: drop it, or this trait"
}

"refuses no replicas": test.#TraitRender & _runtime & {
	parameter: replicas: 0
	expect: error: =~"parameter.replicas: invalid value 0"
}

"refuses memory that is not a quantity": test.#TraitRender & _runtime & {
	parameter: resources: limits: memory: "1 GB"
	expect: error: =~"parameter.resources.limits.memory: invalid value \"1 GB\""
}

_runtimeStatus: {
	definition: "../definitions/crossplane-runtime-config"
	context: {name: "provider-aws-s3", namespace: "vela-system"}
	parameter: args: ["--debug"]
}

"names the runtime config, leaving the package's health to its component": test.#TraitStatus & _runtimeStatus & {
	workload: {apiVersion: "pkg.crossplane.io/v1", kind: "Provider", metadata: name: "provider-aws-s3"}
	expect: {
		healthy: true
		message: "The package runs with runtime config provider-aws-s3"
		details: runtimeConfig: "provider-aws-s3"
	}
}
