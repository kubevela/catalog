package main

aquaTrivyHelm: {
	name: "aqua-trivy-system-helm"
	dependsOn: ["trivy-system-ns"]
	type: "helm"

	properties: {
		repoType:        "helm"
		url:             "https://aquasecurity.github.io/helm-charts"
		chart:           "trivy-operator"
		version:         "0.9.1"
		targetNamespace: parameter.namespace
		values: {
			trivy: ignoreUnfixed: true
		}
	}
}
