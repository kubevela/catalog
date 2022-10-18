package main

grafanaAccount: {
	name: "grafana-account"
	type: "k8s-objects"
	properties: objects: [{
		apiVersion: "v1"
		kind:       "Secret"
		metadata: name: const.secretName
		stringData: {
			username: parameter.adminUser
			password: parameter.adminPassword
		}
	}]
}
