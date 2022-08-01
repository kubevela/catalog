output: {
	type: "helm"
	properties: {
		repoType: "helm"
		url:      "https://charts.jetstack.io"
		chart:    "cert-manager"
        targetNamespace: parameter["tgtNs"]
		version:  "v1.7.1"
		values: {
                        installCRDs: parameter["installCRDs"]
		}
	}
}
