output: {
	type: "helm"
	properties: {
		repoType: "helm"
		url: "https://kubernetes.github.io/ingress-nginx"
		chart: "ingress-nginx"
		version: "4.1.3"
		values: {
			controller: service: type: parameter["serviceType"]
		}
	}
}