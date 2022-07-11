output: {
	type: "webservice"
	properties: {

		image: "ghcr.io/altinity/altinity-dashboard:main"

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
}
