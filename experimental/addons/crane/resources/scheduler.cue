output: {
	if parameter.deployScheduler {
		type: "helm"
		properties: {
			if parameter.mirror {
				url: "https://finops-helm.pkg.coding.net/gocrane/gocrane"
			}
			if !parameter.mirror {
				url: "https://gocrane.github.io/helm-charts"
			}
			repoType:        "helm"
			chart:           "scheduler"
			version:         "0.1.0"
			targetNamespace: "crane-system"
			releaseName:     "scheduler"
		}
	}
	// If parameter.deployScheduler is false, then the above component won't be generated, causing errors.
	// Just put some dummy resources to prevent that error.
	if !parameter.deployScheduler {
		type: "k8s-objects"
		properties: objects: [{}]
	}
}
