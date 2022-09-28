package main

_version: "v1.5.4"

velaux: {
	name: "velaux"
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

		ports: [
			{
				port:     80
				protocol: "TCP"
				expose:   true
				if parameter["serviceType"] == "NodePort" {
					nodePort: parameter["nodePort"]
				}
			},
		]
		if parameter["serviceType"] != _|_ {
			exposeType: parameter["serviceType"]
		}
		if parameter["dex"] == true {
			env: [
				{
					name:  "KUBEVELA_API_URL"
					value: "apiserver.vela-system:8000"
				},
				{
					name:  "DEX_URL"
					value: "dex.vela-system:5556"
				},
			]
		}
		if parameter["dex"] != true {
			env: [
				{
					name:  "KUBEVELA_API_URL"
					value: "apiserver.vela-system:8000"
				},
			]
		}
	}
	_nginxTrait: *[
			if parameter["domain"] != _|_ && parameter["gatewayDriver"] == "nginx" {
			{
				type: "gateway"
				properties: {
					domain: parameter["domain"]
					http: {
						"/": 80
					}
					class: "nginx"
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
					rules: [{port: 80}]
				}
			}
		},
	] | []
	_httpsTrait: *[ if parameter["secretName"] != _|_ && parameter["domain"] != _|_ && parameter["gatewayDriver"] == "traefik" {
		type: "https-route"
		properties: {
			domains: [ parameter["domain"]]
			rules: [{port: 80}]
			secrets: [{
				name: parameter["secretName"]
			}]
		}}] | []
	_scalerTraits: [
		{type: "scaler", properties: replicas: parameter["replicas"]},
	]
	traits: _nginxTrait + _traefikTrait + _httpsTrait + _scalerTraits
	dependsOn: ["apiserver"]
}
