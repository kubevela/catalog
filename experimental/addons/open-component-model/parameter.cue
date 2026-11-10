parameter: {
	// +usage=The namespace to install the OCM controller into
	namespace: *"ocm-system" | string
	// +usage=Helm values for the OCM controller chart. nameOverride and fullnameOverride are not supported.
	values?: {
		// Both rename the controller Deployment, which the addon health check looks up by name.
		nameOverride?:     error("nameOverride is not supported: the addon health check needs the default Deployment name")
		fullnameOverride?: error("fullnameOverride is not supported: the addon health check needs the default Deployment name")
		...
	}
}
