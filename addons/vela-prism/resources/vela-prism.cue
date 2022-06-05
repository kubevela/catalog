output: {
	type: "helm"
	properties: {
		repoType: "helm"
		url:      "https://charts.kubevela.net/prism"
		chart:    "vela-prism"
        values: {
            replicaCount: parameter["replicacount"]
            secureTLS: {
              enabled: parameter["enabled"]
            }
        }
	}
}
