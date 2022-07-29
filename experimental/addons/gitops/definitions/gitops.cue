gitops: {
	annotations: {}
	attributes: workload: definition: {
		apiVersion: "apps/v1"
		kind: "Deployment"
	}
	description: "KubeVela addon for implementing GitOps for continuous deployment using either fluxcd or argocd"
	type: "component"
	labels: {}
}

template: {
	output: {
		if parameter.agent == "fluxcd" {
			apiVersion: "source.toolkit.fluxcd.io/v1beta2"
		}
		if parameter.agent == "argocd" {
			apiVersion: "argoproj.io/v1alpha1"
		}
		kind: ""
		metadata: {
			name: context.name
			namespace: context.namespace
		}
		spec: {
			interval: parameter.pullInterval
			sourceRef: {
				if parameter.repoType == "git" {
					kind: "GitRepository"
				}
				if parameter.repoType == "oss" {
					kind: "Bucket"
				}
				name: context.name
				namespace: context.namespace
			}
			path: parameter.paths.glob
			suspend: parameter.suspend
			prune: parameter.prune
			pruneTimeout: parameter.pruneTimeout
			force: parameter.force
		}
	}

	outputs: {}
}
