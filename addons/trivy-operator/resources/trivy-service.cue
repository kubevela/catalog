package main

trivyHelm: {
	name: "trivy-system-helm"
	dependsOn: ["trivy-system-ns"]
	type: "helm"

	properties: {
		repoType:        "helm"
		url:             "https://devopstales.github.io/helm-charts"
		chart:           "trivy-operator"
		version:         "2.3.2"
		targetNamespace: parameter.namespace
		values: {
			image: {
				repository: parameter["repository"]
				tag:        parameter["tag"]
			}

			persistence: {
				enabled: parameter["enabled"]
			}

			namespaceScanner: {
				crontab: parameter["crontab"]
			}

		}
	}
	traits: [{
		type: "prometheus-scrape"
		properties: {
			port: 9115
			selector: {
				app:                          "trivy-operator"
				"app.kubernetes.io/instance": "trivy-system-trivy-system-helm"
				"app.kubernetes.io/name":     "trivy-operator"
			}
			type: "ClusterIP"
		}
	}]
}
