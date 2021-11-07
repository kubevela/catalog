output: {
	type: "helm"
	properties: {
		repoType: "git"
		url:      "https://github.com/oam-dev/grafana-registration"
		git: {
			branch: "master"
		}
		chart:           "./chart"
		targetNamespace: "observability"
		values: {
			replicaCount: 1
		}
	}
}
