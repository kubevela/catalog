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
		spec: {
			template: spec: {
				containers: [{
					image: parameter.image

				}]
			}
		}
		apiVersion: "apps/v1"
		kind: "Deployment"
	}
}