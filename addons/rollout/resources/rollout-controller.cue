output: {
	type: "helm"
	properties: {
		chart:           "vela-rollout"
		version:         context.metadata.version
		repoType:        "helm"
		url:             "https://charts.kubevela.net/core"
		targetNamespace: "vela-system"
		releaseName:     "vela-rollout"
		values: {}
	}
}
