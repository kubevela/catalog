output: {
	type: "helm"
	properties: {
		repoType: "helm"
		url:      "https://charts.kubevela.net/addons"
		chart:    "terraform-controller"
		version:  "0.7.9"
		if parameter.values != _|_ {
			values: parameter.values
		}
	}
}
