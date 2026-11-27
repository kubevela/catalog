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

"a Provider from its repository and version, on the Crossplane registry": test.#ComponentRender & _provider & {
	parameter: {repository: "crossplane-contrib/provider-nop", version: "v0.4.0"}
	expect: output: spec: package: "xpkg.crossplane.io/crossplane-contrib/provider-nop:v0.4.0"
}

"a Provider from a mirror": test.#ComponentRender & _provider & {
	parameter: {registry: "registry.example.com/crossplane", repository: "crossplane-contrib/provider-nop", version: "v0.4.0"}
	expect: output: spec: package: "registry.example.com/crossplane/crossplane-contrib/provider-nop:v0.4.0"
}

"a Function from its repository and version": test.#ComponentRender & {
	definition: "../definitions/crossplane-function"
	context: name: "patch-and-transform"
	parameter: {repository: "crossplane-contrib/function-patch-and-transform", version: "v0.8.2"}
	expect: output: spec: package: "xpkg.crossplane.io/crossplane-contrib/function-patch-and-transform:v0.8.2"
}

"refuses a package given both ways": test.#ComponentRender & _provider & {
	parameter: {package: "p:1", repository: "crossplane-contrib/provider-nop", version: "v0.4.0"}
	expect: error: =~"give package, or repository and version, not both"
}

"refuses a package given neither way": test.#ComponentRender & _provider & {
	parameter: {}
	expect: error: =~"give package, or repository and version"
}

"refuses a repository without a version": test.#ComponentRender & _provider & {
	parameter: repository: "crossplane-contrib/provider-nop"
	expect: error: =~"repository needs a version"
}

"refuses a registry beside a full package": test.#ComponentRender & _provider & {
	parameter: {package: "p:1", registry: "registry.example.com"}
	expect: error: =~"registry applies to repository and version: put it in package instead"
}

"the Provider's details name what is running": test.#ComponentStatus & _provider & {
	parameter: {repository: "crossplane-contrib/provider-nop", version: "v0.4.0"}
	observed: output: status: {
		conditions: [{type: "Installed", status: "True"}, {type: "Healthy", status: "True"}]
		resolvedPackage: "mirror.example.com/crossplane-contrib/provider-nop:v0.4.0"
		currentRevision: "provider-nop-ac3468a09df9"
	}
	expect: details: {package: "mirror.example.com/crossplane-contrib/provider-nop:v0.4.0", revision: "provider-nop-ac3468a09df9"}
}

"before Crossplane reports, the details name the package asked for": test.#ComponentStatus & _provider & {
	parameter: {repository: "crossplane-contrib/provider-nop", version: "v0.4.0"}
	expect: details: {package: "xpkg.crossplane.io/crossplane-contrib/provider-nop:v0.4.0", revision?: _|_}
}

"the Function's details name what is running": test.#ComponentStatus & {
	definition: "../definitions/crossplane-function"
	context: name: "patch-and-transform"
	parameter: package: "xpkg.crossplane.io/crossplane-contrib/function-patch-and-transform:v0.8.2"
	observed: output: status: {
		conditions: [{type: "Installed", status: "True"}, {type: "Healthy", status: "True"}]
		resolvedPackage: "xpkg.crossplane.io/crossplane-contrib/function-patch-and-transform:v0.8.2"
		currentRevision: "patch-and-transform-1a2b3c"
	}
	expect: details: {package: "xpkg.crossplane.io/crossplane-contrib/function-patch-and-transform:v0.8.2", revision: "patch-and-transform-1a2b3c"}
}
