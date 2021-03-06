output: {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata:
	    labels: parameter.labels
	spec: {
		selector: matchLabels: parameter.labels

		template: {
			metadata: labels: parameter.labels

			spec: {
				if parameter["serviceAccountName"] != _|_ {
					serviceAccountName: parameter.serviceAccountName
				}
				containers: [{
					if parameter["containerName"] != _|_ {
						name: parameter.containerName
					}
					if parameter["containerName"] == _|_ {
						name: context.name
					}
					image: parameter.image
					if parameter["env"] != _|_ {
						env: parameter.env
					}

					if parameter["cmd"] != _|_ {
						command: parameter.cmd
					}
					imagePullPolicy: "IfNotPresent"
					ports: [{
						containerPort: parameter.port
					}]
					if parameter["volumeMounts"] != _|_ {
						volumeMounts: parameter.volumeMounts
					}
					securityContext:
						runAsUser: 1000
				}]
				if parameter["volumes"] != _|_ {
					volumes: [ for v in parameter.volumes {
						name: v.name
						emptyDir: {}
					}]
				}
			}
		}
	}
}

parameter: {
	// +usage=Which image would you like to use for your service
	image: string
	// +usage=Commands to run in the container
	cmd?: [...string]
	// +usage=Which port do you want customer traffic sent to
	port: *80 | int
	// +usage=Define arguments by using environment variables
	env?: [...{
		// +usage=Environment variable name
		name: string
		// +usage=The value of the environment variable
		value?: string
		// +usage=Specifies a source the value of this var should come from
		valueFrom?: {
			// +usage=Selects a key of a secret in the pod's namespace
			secretKeyRef: {
				// +usage=The name of the secret in the pod's namespace to select from
				name: string
				// +usage=The key of the secret to select from. Must be a valid secret key
				key: string
			}
		}
	}]
	volumes?: [...{
		name: string
	}]
	volumeMounts?: [...{
		name:      string
		mountPath: string
	}]
	serviceAccountName?: string
	labels: [string]: string
	containerName?: string
}
