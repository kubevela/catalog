output: {
        type: "helm"
        properties: {
                repoType: "helm"
                url:      "https://devopstales.github.io/helm-charts"
                chart:    "trivy-operator"
                version:  "2.3.2"
                targetNamespace: "default"
                values: {
                    image:{
                        repository: parameter["repository"]
                        tag: parameter["tag"]
                    }

                    persistence:{
                        enabled:parameter["enabled"]
                    }

                    namespaceScanner: {
                        crontab: parameter["crontab"]
                    }

                }
	    }
}
