package main

kedacore: {
	type: "helm"
	name: "kedacore"
	properties: {
		repoType:   "helm"
		url:        "https://kedacore.github.io/charts"
		chart:      "keda"
		version:    "2.8.2"
		upgradeCRD: parameter.upgradeCRD
	}
}
