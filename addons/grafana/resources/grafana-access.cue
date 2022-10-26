package main

grafanaAccess: {
	name: "grafana-access"
	type: "grafana-access"
	dependsOn: [o11yNamespace.name]
	properties: {
		name:     parameter.grafanaName
		endpoint: "http://grafana.\(parameter.namespace):3000"
		username: parameter.adminUser
		password: parameter.adminPassword
	}
}
