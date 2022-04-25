output: {
	type: "helm"
	properties: {
		repoType: "helm"
		url:      "https://charts.jetstack.io"
		chart:    "cert-manager"
		version:  "v1.7.1"
		values: {
                        installCRDs: parameter["installCRDs"]
		}
	}
}
