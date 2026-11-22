parameter: {
	// +usage=The namespace to install the OCM controller into
	namespace: *"ocm-system" | string
	// +usage=Helm values for the OCM controller chart. fullnameOverride is fixed to "ocm-k8s-toolkit".
	values?: {
		// The addon health check looks the controller Deployment up by this name.
		fullnameOverride?: "ocm-k8s-toolkit"
		...
	}
}
