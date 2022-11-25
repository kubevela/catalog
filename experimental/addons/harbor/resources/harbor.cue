package main

harbor: {
	type: "helm"
	name: "harbor"
	properties: {
		repoType:        "helm"
		url:             "https://helm.goharbor.io"
		chart:           "harbor"
		version:         "1.10.2"
		targetNamespace: "vela-system"
		releaseName:     "harbor"
		values: {
			expose: type: parameter.serviceType
		}
	}
}
