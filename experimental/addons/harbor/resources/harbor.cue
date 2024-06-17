package main

harbor: {
	type: "helm"
	name: "harbor"
	properties: {
		repoType:        "helm"
		url:             "https://helm.goharbor.io"
		chart:           "harbor"
		version:         "1.13.1"
		targetNamespace: "vela-system"
		releaseName:     "harbor"
		values: {
			expose: type: parameter.serviceType
			expose: tls: enabled: false
			externalURL: parameter.externalURL
		}
	}
}
