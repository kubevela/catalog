output: {
	type: "helm"
	properties: {
		repoType: "helm"
		url:      "https://charts.kubevela.net/addons"
		chart:    "terraform-controller"
		version:  "0.2.15"
		values: {
			githubBlocked: parameter["github-blocked"]
		}
	}
}
