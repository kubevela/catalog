package main

grafanaAccess: {
	name: "grafana-access"
	type: "grafana-access"
	properties: {
		name:     "default"
		endpoint: "http://grafana.\(parameter.namespace):3000"
		username: parameter.adminUser
		password: parameter.adminPassword
	}
}
