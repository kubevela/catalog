output: {
	type: "webservice"
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
	dependsOn: ["ck-op"]
}
