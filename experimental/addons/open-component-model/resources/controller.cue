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
		values: {
			if parameter.values != _|_ {
				parameter.values
			}
			fullnameOverride: "ocm-k8s-toolkit"
		}
		// KubeVela 1.11's helmchart health check needs the resource name; fullnameOverride is fixed so this one is stable.
		healthStatus: [{
			resource: {
				kind: "Deployment"
				name: "ocm-k8s-toolkit-controller-manager"
			}
			condition: type: "Available"
		}]
	}
}
