import (
	"vela/op"
	"encoding/yaml"
	"strings"
)

"read-app": {
	alias: ""
	annotations: {
		"definition.oam.dev/example-url": "https://raw.githubusercontent.com/kubevela/workflow/main/examples/workflow-run/apply-applications.yaml"
	}
	attributes: {}
	description: "Read application from the cluster"
	labels: {
		"scope": "WorkflowRun"
	}
	type: "workflow-step"
}

template: {
	read: op.#Read & {
		value: {
			apiVersion: "core.oam.dev/v1beta1"
			kind:       "Application"
			metadata: {
				name:      parameter.name
				namespace: parameter.namespace
			}
		}
	}
	message: op.#Steps & {
		if read.err != _|_ {
			if strings.Contains(read.err, "not found") {
				msg: op.#Message & {
					message: "Application not found"
				}
			}
		}
	}
	parameter: {
		name:      string
		namespace: *context.namespace | string
	}
}
