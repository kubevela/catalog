"redis-exporter": {
	alias: "Redis Exporter"
	annotations: {}
	attributes: {
		appliesToWorkloads: ["*"]
		podDisruptive: false
	}
	description: ""
	labels: {}
	type: "trait"
}

template: {
	outputs: {
		_name: context.name + "exporter"
		redisExporter: {
			apiVersion: "apps/v1"
			kind:       "Deployment"
			metadata: {
				name:      _name
				namespace: context.namespace
			}
			spec: {
				selector: {
					matchLabels: {
						"app.oam.dev/trait": _name
						"app.oam.dev/name":  context.appName
					}
				}
				template: {
					metadata: {
						labels: {
							"app.oam.dev/trait": _name
							"app.oam.dev/name":  context.appName
						}
						if parameter.disableAnnotation != true {
							annotations: {
								"prometheus.io/scrape": "true"
								"prometheus.io/port":   "9121"
							}
						}
					}
					spec: {
						containers: [
							{
								name:            "exporter-server"
								image:           "oliver006/redis_exporter:latest"
								imagePullPolicy: "IfNotPresent"
								ports: [{
									containerPort: 9121
									protocol:      "TCP"
									name:          "exporter-port"
								}]
								resources: {
									requests: {
										if parameter.cpu != _|_ {
											cpu: parameter.cpu
										}
										if parameter.memory != _|_ {
											memory: parameter.memory
										}
									}
									limits: {
										if parameter.cpu != _|_ {
											cpu: parameter.cpu
										}
										if parameter.memory != _|_ {
											memory: parameter.memory
										}
									}
								}
								env: [
									{
										name:  "REDIS_ADDR"
										value: parameter.address
									},
									if parameter.user != _|_ {
										{
											name:  "REDIS_USER"
											value: parameter.user
										}
									},
									{
										name:  "REDIS_PASSWORD"
										value: parameter.password
									},
								]
							},
						]

					}
				}
			}
		}
		service: {
			apiVersion: "v1"
			kind:       "Service"
			metadata: name: _name
			spec: {
				selector: {
					"app.oam.dev/trait": _name
					"app.oam.dev/name":  context.appName
				}
				ports: [{
					port:       9121
					targetPort: 9121
					name:       "exporter-port"
				}]
			}
		}
	}
	parameter: {
		// +usage=Specify the name of the Exporter.
		name: *"redis-server-exporter" | string
		// +usage=Address of the Redis instance.
		address: *"localhost" | string
		// +usage=User name to use for authentication(Redis ACL for Redis 6.0 and newer).
		user?: string
		// +usage=Password of the Redis instance
		password: *"" | string
		// +usage=Specify the CPU capacity of the Exporter collector.
		cpu?: string
		// +usage=Specify the Memory capacity of the Exporter collector.
		memory?: string
		// +usage=Disable annotation means do not add the annotations for the exporter pod, and the Prometheus can not scrape it.
		disableAnnotation: *false | bool
	}
}
