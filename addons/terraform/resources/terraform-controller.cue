output: {
	type: "helm"
	properties: {
		repoType: "helm"
		url:      "https://charts.kubevela.net/addons"
		chart:    "terraform-controller"
		version:  "0.7.0"
		values: {
			if !parameter["githubBlocked"] {
				githubBlocked: "'false'"
			}
			if parameter["githubBlocked"] {
				githubBlocked: "'true'"
			}
		}
	}
}
