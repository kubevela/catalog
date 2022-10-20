import (
	"vela/op"
)

"clean-jobs": {
	type: "workflow-step"
	annotations: {}
	labels: {
		"ui-hidden": "true"
	}
	description: "clean workflow run applied jobs"
}
template: {

	parameter: {
		labelselector?: {...}
	}

	cleanJobs: op.#Delete & {
		value: {
			apiVersion: "batch/v1"
			kind:       "Job"
			metadata: {
				name:      context.name
				namespace: context.namespace
			}
		}
		filter: {
			namespace: context.namespace
			if parameter.labelselector != _|_ {
				matchingLabels: parameter.labelselector
			}
			if parameter.labelselector == _|_ {
				matchingLabels: {
					"workflowrun.oam.dev/name": context.name
				}
			}
		}
	}

	cleanPods: op.#Delete & {
		value: {
			apiVersion: "v1"
			kind:       "pod"
			metadata: {
				name:      context.name
				namespace: context.namespace
			}
		}
		filter: {
			namespace: context.namespace
			if parameter.labelselector != _|_ {
				matchingLabels: parameter.labelselector
			}
			if parameter.labelselector == _|_ {
				matchingLabels: {
					"workflowrun.oam.dev/name": context.name
				}
			}
		}
	}
}
