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

	clean: op.#Delete & {
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
}
