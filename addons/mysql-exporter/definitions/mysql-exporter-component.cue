"mysql-exporter-server": {
	alias: "Mysql Exporter"
	annotations: {}
	workload: {
		definition: {
			apiVersion: "apps/v1"
			kind:       "Deployment"
		}
		type: "deployments.apps"
	}
	status: {
		customStatus: #"""
				ready: {
					readyReplicas: *0 | int
				} & {
					if context.output.status.readyReplicas != _|_ {
						readyReplicas: context.output.status.readyReplicas
					}
				}
				message: "Ready:\(ready.readyReplicas)/\(context.output.spec.replicas)"
				"""#
		healthPolicy: #"""
				ready: {
					updatedReplicas:    *0 | int
					readyReplicas:      *0 | int
					replicas:           *0 | int
					observedGeneration: *0 | int
				} & {
					if context.output.status.updatedReplicas != _|_ {
						updatedReplicas: context.output.status.updatedReplicas
					}
					if context.output.status.readyReplicas != _|_ {
						readyReplicas: context.output.status.readyReplicas
					}
					if context.output.status.replicas != _|_ {
						replicas: context.output.status.replicas
					}
					if context.output.status.observedGeneration != _|_ {
						observedGeneration: context.output.status.observedGeneration
					}
				}
				isHealth: (context.output.spec.replicas == ready.readyReplicas) && (context.output.spec.replicas == ready.updatedReplicas) && (context.output.spec.replicas == ready.replicas) && (ready.observedGeneration == context.output.metadata.generation || ready.observedGeneration > context.output.metadata.generation)
				"""#
	}
	description: ""
	labels: {}
	type: "component"
}

template: {
	output: {
		apiVersion: "apps/v1"
		kind:       "Deployment"
		metadata: {
			name:      context.name
			namespace: context.namespace
		}
		spec: {
			selector: {
				matchLabels: {
					"app.oam.dev/name":      context.appName
					"app.oam.dev/component": context.name
				}
			}
			template: {
				metadata: {
					labels: {
						"app.oam.dev/name":      context.appName
						"app.oam.dev/component": context.name
					}
					if parameter.disableAnnotation == _|_ || parameter.disableAnnotation != true {
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
	outputs: {
		service: {
			apiVersion: "v1"
			kind:       "Service"
			metadata: name: context.name
			spec: {
				selector: {
					"app.oam.dev/component": context.name
					"app.oam.dev/name":      context.appName
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
