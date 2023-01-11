package main

_version: context.metadata.version

database: *[ if parameter["database"] != _|_ {
	"--datastore-database=" + parameter["database"]
}] | []

dbURL: *[ if parameter["dbURL"] != _|_ {
	"--datastore-url=" + parameter["dbURL"]
}] | []

enableImpersonation: *[ if parameter["enableImpersonation"] {
	"--feature-gates=EnableImpersonation=true"
}] | []

apiserver: {
	name: "apiserver"
	type: "webservice"
	properties: {
		if parameter["repo"] == _|_ {
			image: "oamdev/vela-apiserver:" + _version
		}

		if parameter["repo"] != _|_ {
			image: parameter["repo"] + "/" + "oamdev/vela-apiserver:" + _version
		}

		if parameter["imagePullSecrets"] != _|_ {
			imagePullSecrets: parameter["imagePullSecrets"]
		}

		cmd: ["apiserver", "--datastore-type=" + parameter["dbType"]] + database + dbURL + enableImpersonation
		ports: [
			{
				port:     8000
				protocol: "TCP"
				expose:   true
			},
		]
	}
	if parameter["enableImpersonation"] {
		dependsOn: ["velaux-additional-privileges"]
	}
	traits: [
		{
			type: "service-account"
			properties: name: parameter["serviceAccountName"]
		},
		{type: "scaler", properties: replicas: parameter["replicas"]},
	]
}
