import (
	"vela/op"
	"encoding/yaml"
	"strings"
)

"read-app": {
	alias: ""
	annotations: {}
	attributes: {}
	description: "Read application from the cluster"
	labels: {}
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
