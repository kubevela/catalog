parameter: {
	// +usage=The clusters to install
	clusters?: [...string]
	// +usage=Specify if upgrade the CRDs when upgrading kruise-rollout or not
	upgradeCRD: *true | bool
}