output: {
	type: "helm"
	properties: {
		repoType:   "helm"
		url:        "https://kubevela.github.io/charts"
		chart:      "terraform-controller"
		version:    "0.7.11"
		upgradeCRD: parameter.upgradeCRD
		if parameter.values != _|_ {
			values: parameter.values
		}
	}
}
