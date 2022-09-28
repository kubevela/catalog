package main

dashboard: {
	type: "webservice"
	name: "ck-dashboard"
	properties: {
		image: "ghcr.io/altinity/altinity-dashboard:v0.1.4"

		if parameter["serviceType"] != _|_ {
			exposeType: parameter["serviceType"]
		}
		cmd: ["adash", "--notoken", "--bindhost", "0.0.0.0"]
		ports: [
			{
				port:     8080
				protocol: "TCP"
				expose:   true
			},
		]
	}
	traits: [{
		type: "service-account"
		properties: {
			name:   "clickhouse-dashboard"
			create: true
			privileges: [ for p in _clusterPrivileges {
				scope: "cluster"
				{p}
			}]
		}
	}]
	dependsOn: ["ck-op"]
}

_clusterPrivileges: [{
	apiGroups: [""]
	resources: ["pods"]
	verbs: ["list", "watch"]
}, {
	apiGroups: ["extensions", "apps"]
	resources: ["deployments"]
	verbs: ["list", "watch"]
}, {
	apiGroups: ["clickhouse.altinity.com"]
	resources: ["clickhouseinstallations"]
	verbs: ["list", "watch"]
}]
