import (
	"vela/op"
	"encoding/yaml"
)

"apply-app": {
	alias: ""
	annotations: {}
	attributes: {}
	description: "Apply application from data or ref to the cluster"
	labels: {}
	type: "workflow-step"
}

template: {
	app: op.#Steps & {
		if parameter.data != _|_ {
			apply: op.#Apply & {
				value: parameter.data
			}
		}
		if parameter.ref != _|_ {
			if parameter.ref.type == "configMap" {
				cm: op.#Read & {
					value: {
						apiVersion: "v1"
						kind:       "ConfigMap"
						metadata: {
							name:      parameter.ref.name
							namespace: parameter.ref.namespace
						}
					}
				}
				template: cm.value.data[parameter.ref.key]
				apply:    op.#Apply & {
					value: yaml.Unmarshal(template)
				}
			}
		}
	}
	wait: op.#ConditionalWait & {
		continue: app.apply.value.status.status == "running"
	}
	parameter: close({
		data?: {...}
	}) | close({
		ref?: {
			name:      string
			namespace: *context.namespace | string
			type:      *"configMap" | string
			key:       *"application" | string
		}
	})
}
