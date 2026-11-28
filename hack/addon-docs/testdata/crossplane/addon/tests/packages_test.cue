import "vela/test"

_provider: {definition: "../definitions/crossplane-provider", context: name: "nop"}

"a Provider from its package": test.#ComponentRender & _provider & {
	parameter: package: "xpkg.crossplane.io/crossplane-contrib/provider-nop:v0.4.0"
	expect: output: {
		apiVersion: "pkg.crossplane.io/v1"
		kind:       "Provider"
		metadata: name: "nop"
		spec: {
			package:                  "xpkg.crossplane.io/crossplane-contrib/provider-nop:v0.4.0"
			packagePullPolicy:        "IfNotPresent"
			revisionActivationPolicy: "Automatic"
			revisionHistoryLimit:     1
			runtimeConfigRef?:        _|_
		}
	}
}

"points the Provider at a runtime config": test.#ComponentRender & _provider & {
	parameter: {package: "p:1", runtimeConfig: "debug"}
	expect: output: spec: runtimeConfigRef: {apiVersion: "pkg.crossplane.io/v1beta1", kind: "DeploymentRuntimeConfig", name: "debug"}
}

"a Function from its package": test.#ComponentRender & {
	definition: "../definitions/crossplane-function"
	context: name:      "patch-and-transform"
	parameter: package: "xpkg.crossplane.io/crossplane-contrib/function-patch-and-transform:v0.8.2"
	expect: output: {
		apiVersion: "pkg.crossplane.io/v1"
		kind:       "Function"
		metadata: name: "patch-and-transform"
		spec: {
			package:                  "xpkg.crossplane.io/crossplane-contrib/function-patch-and-transform:v0.8.2"
			packagePullPolicy:        "IfNotPresent"
			revisionActivationPolicy: "Automatic"
			revisionHistoryLimit:     1
		}
	}
}

"a Function is healthy once installed and healthy": test.#ComponentStatus & {
	definition: "../definitions/crossplane-function"
	context: name:      "patch-and-transform"
	parameter: package: "f:1"
	observed: output: status: conditions: [{type: "Installed", status: "True"}, {type: "Healthy", status: "True"}]
	expect: {healthy: true, message: "Installed and healthy"}
}

"a Function is not healthy while its package is unhealthy, saying why": test.#ComponentStatus & {
	definition: "../definitions/crossplane-function"
	context: name:      "patch-and-transform"
	parameter: package: "f:1"
	observed: output: status: conditions: [{type: "Installed", status: "True"}, {type: "Healthy", status: "False", message: "cannot pull image"}]
	expect: {healthy: false, message: "Healthy: cannot pull image"}
}

"healthy once installed and healthy": test.#ComponentStatus & _provider & {
	parameter: package: "p:1"
	observed: output: status: conditions: [{type: "Installed", status: "True"}, {type: "Healthy", status: "True"}]
	expect: {healthy: true, message: "Installed and healthy"}
}

"not healthy while the package is unhealthy, saying why": test.#ComponentStatus & _provider & {
	parameter: package: "p:1"
	observed: output: status: conditions: [{type: "Installed", status: "True"}, {type: "Healthy", status: "False", reason: "UnhealthyPackageRevision", message: "cannot pull image"}]
	expect: {healthy: false, message: "Healthy: cannot pull image"}
}

"waiting before Crossplane reports anything": test.#ComponentStatus & _provider & {
	parameter: package: "p:1"
	observed: output: {}
	expect: {healthy: false, message: "Waiting for Crossplane"}
}

"not healthy while only installed": test.#ComponentStatus & _provider & {
	parameter: package: "p:1"
	observed: output: status: conditions: [{type: "Installed", status: "True"}]
	expect: {healthy: false, message: "Waiting for Crossplane"}
}
