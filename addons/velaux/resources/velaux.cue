package main

velaux_version: "v1.7.4"

velaux: {
	name: "velaux"
	type: "webservice"
	properties: {
		if parameter["repo"] == _|_ {
			image: "oamdev/velaux:" + velaux_version
		}

		if parameter["repo"] != _|_ {
			image: parameter["repo"] + "/" + "oamdev/velaux:" + velaux_version
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
	_nginxIngressTrait: *[
			if parameter["domain"] != _|_ && parameter["gatewayDriver"] == "nginx" && parameter["trafficType"] == "ingress" {
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
	_traefikGatewayTrait: *[
			if parameter["domain"] != _|_ && parameter["gatewayDriver"] == "traefik" && parameter["trafficType"] == "gateway" {
			{
				type: "http-route"
				properties: {
					domains: [ parameter["domain"]]
					rules: [{port: 80}]
				}
			}
		},
	] | []
	_traefikIngressTrait: *[
			if parameter["domain"] != _|_ && parameter["gatewayDriver"] == "traefik" && parameter["trafficType"] == "ingress" {
			{
				type: "ingress"
				properties: {
					domain: parameter["domain"]
					http: {
						"/": 80
					}
					class: "traefik"
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
	traits: _nginxIngressTrait + _traefikIngressTrait +_traefikGatewayTrait + _httpsTrait + _scalerTraits
	dependsOn: ["apiserver"]
}
