"mysql-exporter": {
	alias: "Mysql Exporter"
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
		mysqlExporter: {
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
								"prometheus.io/port":   "9104"
							}
						}
					}
					spec: {
						containers: [
							{
								name:            "exporter-server"
								image:           "prom/mysqld-exporter:" + parameter.version
								imagePullPolicy: "IfNotPresent"
								ports: [{
									containerPort: 9104
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
										name:  "DATA_SOURCE_NAME"
										value: parameter.username + ":" + parameter.password + "@(" + parameter.mysqlHost + ":\(parameter.mysqlPort))/"
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
					port:       9104
					targetPort: 9104
					name:       "exporter-port"
				}]
			}
		}
	}
	parameter: {
		// +usage=Specify the name of the Exporter.
		name: *"mysql-server-exporter" | string
		// +usage=Specify the host of the target Mysql server, maybe you could set the mysql component name.
		mysqlHost: *"mysql-server" | string
		// +usage=Specify the port of the target Mysql server.
		mysqlPort: *3306 | int
		// +usage=Specify the username of the target Mysql server.
		username: string
		// +usage=Specify the password of the target Mysql server.
		password: string
		// +usage=Specify the version of the Exporter collector.
		version: *"v0.14.0" | string
		// +usage=Specify the CPU capacity of the Exporter collector.
		cpu?: string
		// +usage=Specify the Memory capacity of the Exporter collector.
		memory?: string
		// +usage=Disable annotation means do not add the annotations for the exporter pod, and the Prometheus can not scrape it.
		disableAnnotation: *false | bool
	}
}
