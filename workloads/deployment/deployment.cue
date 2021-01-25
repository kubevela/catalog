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

					if parameter["env"] != _|_ && parameter["configRef"] == _|_ {
						envValuePlain
					}

					if parameter["env"] == _|_ && parameter["configRef"] != _|_ {
						envValueFrom
					}
					if parameter["env"] != _|_ && parameter["configRef"] != _|_ {
						env: envValuePlain.env + envValueFrom.env
					}

					if context["config"] != _|_ {
						env: context.config
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

envValuePlain: {
	if parameter["env"] != _|_ {
		env:
		[ for e in parameter.env {
			name:  e.name
			value: e.value
		}]
	}
}

envValueFrom: {
	if parameter["configRef"] != _|_ {
		env:
			list.FlattenN([ for c in parameter.configRef {
				[ for k in c.keys {
					name: k
					valueFrom: {
						secretKeyRef: {
							name: c.name
							key:  k
						}
					}
				},
				]
			}], 1)
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
	configRef?: [...{
		// +usage=Referred config name, ie, cloud resource name
		name: string
		// +usage=Key from KubeVela config
		keys: [...string]
	}]
	// +usage=Define arguments by using environment variables
	env?: [...{
		// +usage=Environment variable name
		name: string
		// +usage=The value of the environment variable
		value: string
	}]

	// +usage=Number of CPU units for the service, like `0.5` (0.5 CPU core), `1` (1 CPU core)
	cpu?: string
}

context: {
	name: "abc"
}

parameter: {
	env: [
		{name: "A", value: "a"},
	]
	configRef: [
		{name: "rds-config", keys: ["db_name", "db_host"]},
		{name: "oss-config", keys: ["bucket_name"]},
	]
}
