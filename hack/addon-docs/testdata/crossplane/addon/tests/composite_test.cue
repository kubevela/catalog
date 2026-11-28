import "vela/test"

_versions: [{name: "v1alpha1", schema: {type: "object", properties: spec: {type: "object", properties: size: type: "string"}}}]
_xrd: {names: {kind: "XBucket", plural: "xbuckets"}, group: "platform.example.com", versions: _versions}

"Crossplane 2: a namespaced XRD by default": test.#ComponentRender & {
	definition: "../variants/major/2/crossplane-xrd"
	context: name: "buckets"
	parameter: _xrd
	expect: output: {
		apiVersion: "apiextensions.crossplane.io/v2"
		kind:       "CompositeResourceDefinition"
		metadata: name: "xbuckets.platform.example.com"
		spec: {
			scope:       "Namespaced"
			claimNames?: _|_
			versions: [{name: "v1alpha1", served: true, referenceable: true, schema: openAPIV3Schema: _versions[0].schema}]
		}
	}
}

"Crossplane 2: a cluster-scoped XRD": test.#ComponentRender & {
	definition: "../variants/major/2/crossplane-xrd"
	context: name: "buckets"
	parameter: _xrd & {scope: "Cluster"}
	expect: output: spec: scope: "Cluster"
}

"Crossplane 2 takes claims only on a LegacyCluster XRD": test.#ComponentRender & {
	definition: "../variants/major/2/crossplane-xrd"
	context: name: "buckets"
	parameter: _xrd & {claimNames: {kind: "Bucket", plural: "buckets"}}
	expect: error: =~"claimNames needs scope LegacyCluster"
}

"Crossplane 2 keeps a 1.x claim API as a LegacyCluster XRD, written as v1": test.#ComponentRender & {
	definition: "../variants/major/2/crossplane-xrd"
	context: name: "buckets"
	parameter: _xrd & {scope: "LegacyCluster", claimNames: {kind: "Bucket", plural: "buckets"}}
	expect: output: {
		apiVersion: "apiextensions.crossplane.io/v1"
		spec: {scope: "LegacyCluster", claimNames: {kind: "Bucket", plural: "buckets"}}
	}
}

"Crossplane 2 health waits for Offered on a claim API": test.#ComponentStatus & {
	definition: "../variants/major/2/crossplane-xrd"
	context: name: "buckets"
	parameter: _xrd & {scope: "LegacyCluster", claimNames: {kind: "Bucket", plural: "buckets"}}
	observed: output: {spec: claimNames: {kind: "Bucket", plural: "buckets"}, status: conditions: [{type: "Established", status: "True"}]}
	expect: {healthy: false, message: "Waiting for Crossplane"}
}

"Crossplane 1: a v1 XRD, with a claim": test.#ComponentRender & {
	definition: "../variants/major/1/crossplane-xrd"
	context: name: "buckets"
	parameter: _xrd & {claimNames: {kind: "Bucket", plural: "buckets"}}
	expect: output: {
		apiVersion: "apiextensions.crossplane.io/v1"
		spec: {claimNames: {kind: "Bucket", plural: "buckets"}, scope?: _|_}
	}
}

"Crossplane 1 has no scope": test.#ComponentRender & {
	definition: "../variants/major/1/crossplane-xrd"
	context: name: "buckets"
	parameter: _xrd & {scope: "Namespaced"}
	expect: error: =~"scope"
}

"exactly one version is referenceable": test.#ComponentRender & {
	definition: "../variants/major/2/crossplane-xrd"
	context: name: "buckets"
	parameter: {names: _xrd.names, group: _xrd.group, versions: [_versions[0], {name: "v1", schema: {}}]}
	expect: error: =~"exactly one version must be referenceable"
}

"Crossplane 1: healthy once established and offered": test.#ComponentStatus & {
	definition: "../variants/major/1/crossplane-xrd"
	context: name: "buckets"
	parameter: _xrd & {claimNames: {kind: "Bucket", plural: "buckets"}}
	observed: output: status: conditions: [{type: "Established", status: "True"}, {type: "Offered", status: "True"}]
	expect: {healthy: true, message: "Established"}
}

"Crossplane 1: not healthy until the claim API is offered, saying why": test.#ComponentStatus & {
	definition: "../variants/major/1/crossplane-xrd"
	context: name: "buckets"
	parameter: _xrd & {claimNames: {kind: "Bucket", plural: "buckets"}}
	observed: output: status: conditions: [{type: "Established", status: "True"}, {type: "Offered", status: "False", reason: "OfferingFailed"}]
	expect: {healthy: false, message: "Offered: OfferingFailed"}
}

"Crossplane 2: healthy once established": test.#ComponentStatus & {
	definition: "../variants/major/2/crossplane-xrd"
	context: name: "buckets"
	parameter: _xrd
	observed: output: status: conditions: [{type: "Established", status: "True"}]
	expect: {healthy: true, message: "Established"}
}

"an activation policy": test.#ComponentRender & {
	definition: "../variants/major/2/crossplane-activation-policy"
	context: name: "aws-s3"
	parameter: activate: ["*.s3.aws.m.upbound.io"]
	expect: output: {apiVersion: "apiextensions.crossplane.io/v1alpha1", kind: "ManagedResourceActivationPolicy", metadata: name: "aws-s3", spec: activate: ["*.s3.aws.m.upbound.io"]}
}

"a pipeline Composition": test.#ComponentRender & {
	definition: "../definitions/crossplane-composition"
	context: name: "xbuckets"
	parameter: {
		compositeTypeRef: {apiVersion: "platform.example.com/v1alpha1", kind: "XBucket"}
		pipeline: [{step: "patch", function: "function-patch-and-transform", input: {apiVersion: "pt.fn.crossplane.io/v1beta1", kind: "Resources"}}]
	}
	expect: output: spec: {
		mode: "Pipeline"
		pipeline: [{step: "patch", functionRef: name: "function-patch-and-transform", input: kind: "Resources"}]
	}
}

"a Composition needs a step": test.#ComponentRender & {
	definition: "../definitions/crossplane-composition"
	context: name: "xbuckets"
	parameter: {compositeTypeRef: {apiVersion: "a/v1", kind: "X"}, pipeline: []}
	expect: error: =~"pipeline"
}
