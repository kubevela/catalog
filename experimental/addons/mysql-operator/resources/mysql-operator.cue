package main

mysqlOperator: {
    name: "mysql-operator"
	type: "helm"
	properties: {
		repoType: "helm"
		url:      "https://helm-charts.bitpoke.io"
		chart:    "mysql-operator"
		version:  "0.6.2"
		values: {
			orchestrator: {
				persistence: {
					enabled: parameter["orchestrator.persistence.enabled"]
				}
			}
		}
	}
}
