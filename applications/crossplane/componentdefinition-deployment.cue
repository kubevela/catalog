import "list"

output: {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	spec: {
		selector: matchLabels: {
			"app.oam.dev/component": context.name
		}

		template: {
			metadata: labels: {
				"app.oam.dev/component": context.name
			}

			spec: {
				containers: [{
					name:  context.name
					image: parameter.image

					if parameter["cmd"] != _|_ {
						command: parameter.cmd
					}

					if parameter["secretRef"] != _|_ {
						env:
							list.FlattenN([ for c in parameter.secretRef {
								[ for k in c.environment {
									name: k
									valueFrom: {
										secretKeyRef: {
											name: context.outputSecretName[c.name]
											key:  k
										}
									}
								},
								]
							}], 1)
					}

					ports: [{
						containerPort: parameter.port
					}]

					if parameter["cpu"] != _|_ {
						resources: {
							limits:
								cpu: parameter.cpu
							requests:
								cpu: parameter.cpu
						}
					}
				}]
		}
		}
	}
}

parameter: {
	// +usage=Which image would you like to use for your service
	// +short=i
	image: string

	// +usage=Commands to run in the container
	cmd?: [...string]

	// +usage=Which port do you want customer traffic sent to
	// +short=p
	port: *80 | int

	// +usage=Referred config
	secretRef?: [...{
		// +usage=Referred secret name
		name: string
		// +usage=Key from KubeVela config
		environment: [...string]
	}]

	// +usage=Number of CPU units for the service, like `0.5` (0.5 CPU core), `1` (1 CPU core)
	cpu?: string
}

context: {
	name:        "sample-db"
	appName:     "webapp"
	appRevision: ""
	namespace:   "default"
	outputSecretName: {"db-conn": "webapp-sample-db"}
}

parameter: {
	image: "zzxwill/flask-web-application:v0.3"
	ports: 80
	secretRef: [
		{name: "db-conn"
			environment:
			["username", "endpoint", "password"]
		},
	]
}
