database: *[if parameter["database"] != _|_ {
"--datastore-database=" + parameter["database"]
}] | []

dbURL: *[if parameter["dbURL"] != _|_ {
"--datastore-url=" + parameter["dbURL"]
}] | []

output: {
	type: "webservice"
	properties: {
		if parameter["repo"] == _|_ {
			image: "oamdev/vela-apiserver:" + parameter["version"]
		}

		if parameter["repo"] != _|_ {
			image: parameter["repo"] + "/" +"oamdev/vela-apiserver:" + parameter["version"]
		}

		cmd: ["apiserver", "--datastore-type=" + parameter["dbType"]] + database + dbURL
		ports: [
			{
				port:     8000
				protocol: "TCP"
				expose:   true
			},
		]
	}
	traits:[{
		type: "service-account"
		properties: name: parameter["serviceAccountName"]
	}]
}
