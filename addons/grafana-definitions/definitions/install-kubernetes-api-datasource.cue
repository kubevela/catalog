import (
	"vela/op"
	"encoding/base64"
)

"install-kubernetes-api-datasource": {
	alias: ""
	annotations: {}
	attributes: podDisruptive: false
	description: "Create Kubernetes API datasource."
	labels: "ui-hidden": "true"
	type: "workflow-step"
}

template: {
	readSA: op.#Apply & {
		value: {
			apiVersion: "v1"
			kind:       "ServiceAccount"
			metadata: {
				name:      parameter.serviceAccountName
				namespace: parameter.namespace
			}
		}
	} @step(1)

	wait: op.#ConditionalWait & {
		continue: readSA.value.secrets != _|_ && len(readSA.value.secrets) > 0
	} @step(2)

	read: op.#Read & {
		value: {
			apiVersion: "v1"
			kind:       "Secret"
			metadata: {
				name:      readSA.value.secrets[0].name
				namespace: parameter.namespace
			}
		}
	} @step(3)

	decode: op.#Steps & {
		token:     base64.Decode(null, read.value.data.token)
		convert:   op.#ConvertString & {bt: token}
		kubeToken: convert.str
	} @step(4)

	output: op.#Apply & {
		value: {
			apiVersion: "o11y.prism.oam.dev/v1alpha1"
			kind:       "GrafanaDatasource"
			metadata: name: "\(parameter.uid)@\(parameter.grafana)"
			spec: {
				type:            "marcusolsson-json-datasource"
				name:            "KubernetesAPIServer"
				url:             "https://kubernetes.default"
				access:          "proxy"
				uid:             "kubernetes-api"
				withCredentials: true
				jsonData: {
					tlsSkipVerify:   true
					httpHeaderName1: "Authorization"
				}
				secureJsonData: {
					httpHeaderValue1: "Bearer \(decode.kubeToken)"
				}
			}
		}
	} @step(5)

	parameter: {
		serviceAccountName: *"grafana" | string
		namespace:          *"o11y-system" | string
		uid:                *"kubernetes-api" | string
		grafana:            *"default" | string
	}
}
