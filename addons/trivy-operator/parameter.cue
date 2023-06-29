parameter: {
	// +usage=Deploy to specified clusters. Leave empty to deploy to all clusters.
	clusters?: [...string]
	// +usage=Namespace to deploy to, defaults to cert-manager
	namespace: *"trivy-system" | string
	// +usage=Specify if upgrade the CRDs when upgrading trivy-operator or not
	upgradeCRD: *false | bool
}
