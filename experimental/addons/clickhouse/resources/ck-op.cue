package main

operator: {
	name: "ck-operator"
	type: "ref-objects"
	properties: {
		urls: ["https://raw.githubusercontent.com/Altinity/clickhouse-operator/master/deploy/operator/clickhouse-operator-install-bundle.yaml"]
	}
	traits: [{
		type: "prometheus-scrape"
		properties: {
			port: 8888
			selector: app: "clickhouse-operator"
			type: parameter["serviceType"]
		}
	}]
}
