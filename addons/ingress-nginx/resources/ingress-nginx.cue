package main

nginxIngress: {
	type: "helm"
	name: "nginx-ingress"
	properties: {
		repoType: "helm"
		url:      "https://kubernetes.github.io/ingress-nginx"
		chart:    "ingress-nginx"
		version:  "4.2.0"
		values: {
			controller: service: type: parameter["serviceType"]
		}
	}
}
