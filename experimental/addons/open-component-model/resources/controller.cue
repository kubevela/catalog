package main

ocmController: {
	name: "ocm-controller"
	type: "helmchart"
	properties: {
		chart: {
			source:  "oci://ghcr.io/open-component-model/kubernetes/controller/chart"
			version: "0.23.0"
		}
		release: {
			name:      "ocm-k8s-toolkit"
			namespace: parameter.namespace
		}
		if parameter.values != _|_ {
			values: parameter.values
		}
		// I needed to add this for the health reporting to work properly once the release is applied.
		// The name was needed because vela 1.11.1 did not use the match criteria without this being set.
		healthStatus: [{
			resource: {
				kind: "Deployment"
				name: "ocm-k8s-toolkit-controller-manager"
			}
			condition: type: "Available"
		}]
	}
}
