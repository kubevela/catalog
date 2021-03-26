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

					if parameter["dbSecret"] != _|_ {
						env: [
							{
								name:  "username"
								value: dbConn.username
							},
							{
								name:  "endpoint"
								value: dbConn.endpoint
							},
							{
								name:  "DB_PASSWORD"
								value: dbConn.password
							},
						]
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

	// +usage=Referred db secret
	// +insertSecretTo=dbConn
	dbSecret?: string

	// +usage=Number of CPU units for the service, like `0.5` (0.5 CPU core), `1` (1 CPU core)
	cpu?: string
}

dbConn: {
	username: string
	endpoint: string
	port:     string
}
