import (
	"vela/op"
)

"addon-operation": {
	type: "workflow-step"
	annotations: {
		"definition.oam.dev/example-url": "https://raw.githubusercontent.com/kubevela/catalog/master/examples/vela-workflow/observability.yaml"
	}
	labels: {
		"scope": "WorkflowRun"
	}
	description: "Enable a KubeVela addon"
}
template: {

	job: op.#Apply & {
		value: {
			apiVersion: "batch/v1"
			kind:       "Job"
			metadata: {
				name:      context.name + "-" + context.stepSessionID
				namespace: "vela-system"
				labels: {
					"enable-addon.oam.dev": context.name
				}
				annotations: {
					"workflowrun.oam.dev/step": context.stepName
				}
			}
			spec: {
				backoffLimit: 3
				template: {
					metadata: {
						labels: {
							"workflowrun.oam.dev/name":    context.name
							"workflowrun.oam.dev/session": context.stepSessionID
						}
						annotations: {
							"workflowrun.oam.dev/step": context.stepName
						}
					}
					spec: {
						containers: [
							{
								name:  parameter.addonName + "-enable-job"
								image: parameter.image

								if parameter.args == _|_ {
									command: ["vela", "addon", parameter.operation, parameter.addonName]
								}

								if parameter.args != _|_ {
									command: ["vela", "addon", parameter.operation, parameter.addonName] + parameter.args
								}
							},
						]
						restartPolicy:  "Never"
						serviceAccount: parameter.serviceAccountName
					}
				}
			}
		}
	}

	log: op.#Log & {
		source: {
			resources: [{labelSelector: {
				"workflowrun.oam.dev/name":    context.name
				"workflowrun.oam.dev/session": context.stepSessionID
			}}]
		}
	}

	fail: op.#Steps & {
		if job.value.status.failed != _|_ {
			if job.value.status.failed > 2 {
				breakWorkflow: op.#Fail & {
					message: "enable addon failed"
				}
			}
		}
	}

	wait: op.#ConditionalWait & {
		continue: job.value.status.succeeded != _|_ && job.value.status.succeeded > 0
	}

	parameter: {
		// +usage=Specify the name of the addon.
		addonName: string
		// +usage=Specify addon enable args.
		args?: [...string]
		// +usage=Specify the image
		image: *"oamdev/vela-cli:v1.6.0" | string
		// +usage=operation for the addon
		operation: *"enable" | "upgrade" | "disable"
		// +usage=specify serviceAccountName want to use
		serviceAccountName: *"kubevela-vela-core" | string
	}
}
