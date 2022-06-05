output: {
	type: "helm"
	properties: {
		repoType: "helm"
		url:      "https://charts.kubevela.net/prism"
		chart:    "vela-prism"
        values: {
            replicaCount: parameter["replicacount"]

            image: {
                  repository: parameter["repository"]
                  tag: parameter["tag"]
                  pullPolicy: parameter["pullPolicy"]
            }

            resources: {
                limits: {
                    cpu: parameter["cpu"]
                    memory: parameter["memory"]
                }
            }
            secureTLS: {
              enabled: parameter["enabled"]
            }
        }
	}
}
