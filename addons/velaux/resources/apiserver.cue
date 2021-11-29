package resources

output: {
	type: "webservice"
	properties: {
		image: parameter["repo"] + "oamdev/apiserver:" + parameter["version"]
		cmd: [
			"--datastore-type=" + parameter["dbType"],
			"--datastore-database=" + parameter["database"],
			"--datastore-url=" + parameter["dbURL"],
		]
		ports: [
			{
				port:     8000
				protocol: "TCP"
				expose:   true
			},
		]
	}
}
