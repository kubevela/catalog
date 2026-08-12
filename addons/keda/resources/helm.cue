package main

kedacore: {
	type: "helm"
	name: "kedacore"
	properties: {
		repoType:   "helm"
		url:        "https://kedacore.github.io/charts"
		chart:      "keda"
		version:    "2.12.0"
		upgradeCRD: parameter.upgradeCRD
	}
}
