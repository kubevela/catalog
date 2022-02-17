output: {
	type: "helm"
	properties: {
		repoType: "helm"
		url: "https://www.getambassador.io"
		chart: "ambassador"
		version: "6.9.3"
		values: {
			image: repository: "docker.io/datawire/ambassador"
			enableAES: false
			crds:	keep: false
			if parameter["serviceType"] != _|_ {
				service: type: parameter["serviceType"]
			}
		}
	}
}
