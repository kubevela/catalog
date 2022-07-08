output: {
	type: "helm"
	properties: {
		if parameter.mirror {
			url: "https://finops-helm.pkg.coding.net/gocrane/gocrane"
		}
		if !parameter.mirror {
			url: "https://gocrane.github.io/helm-charts"
		}
		repoType:        "helm"
		chart:           "crane"
		version:         "0.5.0"
		targetNamespace: "crane-system"
		releaseName:     "crane"
	}
}
