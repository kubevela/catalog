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

_nginxTrait: *[
		if parameter["domain"] != _|_ && parameter["gatewayDriver"] == "nginx" {
		{
			type: "gateway"
			properties: {
				domain: parameter["domain"]
				http: {
					"/": 8000
				}
				class: parameter["ingressClass"]
			}
		}
	},
] | []

_traefikTrait: *[
		if parameter["domain"] != _|_ && parameter["gatewayDriver"] == "traefik" {
		{
			type: "http-route"
			properties: {
				domains: [ parameter["domain"]]
				rules: [{port: 8000}]
			}
		}
	},
] | []

_httpsTrait: *[ if parameter["secretName"] != _|_ && parameter["domain"] != _|_ && parameter["gatewayDriver"] == "traefik" {
	type: "https-route"
	properties: {
		domains: [ parameter["domain"]]
		rules: [{port: 8000}]
		secrets: [{
			name: parameter["secretName"]
		}]
	}}] | []

server: {
	name: "velaux-server"
	type: "webservice"
	properties: {
		if parameter["repo"] == _|_ {
			image: "oamdev/velaux:" + _version
		}

		if parameter["repo"] != _|_ {
			image: parameter["repo"] + "/" + "oamdev/velaux:" + _version
		}

		if parameter["imagePullSecrets"] != _|_ {
			imagePullSecrets: parameter["imagePullSecrets"]
		}

		if parameter["serviceType"] != _|_ {
			exposeType: parameter["serviceType"]
		}

		cmd: ["server", "--datastore-type=" + parameter["dbType"], "--feature-gates=EnableCacheJSFile=true"] + database + dbURL + enableImpersonation
		ports: [
			{
				port:     8000
				protocol: "TCP"
				expose:   true
				if parameter["serviceType"] == "NodePort" {
					nodePort: parameter["nodePort"]
				}
			},
		]
	}
	dependsOn: ["velaux-additional-privileges"]
	traits: [
		{
			type: "service-account"
			properties: name: parameter["serviceAccountName"]
		},
		{type: "scaler", properties: replicas: parameter["replicas"]},
	] + _nginxTrait + _traefikTrait + _httpsTrait
}
