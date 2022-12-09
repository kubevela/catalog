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

	createSecret: op.#Apply & {
		value: {
			apiVersion: "v1"
			kind:       "Secret"
			metadata: {
				name:      parameter.serviceAccountName + "-autogen"
				namespace: parameter.namespace
				annotations: "kubernetes.io/service-account.name": parameter.serviceAccountName
			}
			type: "kubernetes.io/service-account-token"
		}
	} @step(2)

	getSecret: op.#Read & {
		value: {
			apiVersion: "v1"
			kind:       "Secret"
			metadata: {
				name:      parameter.serviceAccountName + "-autogen"
				namespace: parameter.namespace
			}
		}
	} @step(3)

	wait: op.#ConditionalWait & {
		continue: *false | bool
		if readSA.value.secrets != _|_ {
			if len(readSA.value.secrets) > 0 {
				continue: true
			}
		}
		if getSecret.value.data != _|_ {
			if getSecret.value.data.token != _|_ {
				continue: true
			}
		}
	} @step(4)

	read: op.#Read & {
		value: {
			apiVersion: "v1"
			kind:       "Secret"
			metadata: {
				if getSecret.value.data == _|_ || getSecret.value.data.token == _|_ {
					name: readSA.value.secrets[0].name
				}
				if getSecret.value.data != _|_ && getSecret.value.data.token != _|_ {
					name: parameter.serviceAccountName + "-autogen"
				}
				namespace: parameter.namespace
			}
		}
	} @step(5)

	decode: op.#Steps & {
		token:     base64.Decode(null, read.value.data.token)
		convert:   op.#ConvertString & {bt: token}
		kubeToken: convert.str
	} @step(6)

	output: op.#Apply & {
		value: {
			apiVersion: "o11y.prism.oam.dev/v1alpha1"
			kind:       "GrafanaDatasource"
			metadata: name: "\(parameter.uid)@\(parameter.grafana)"
			spec: {
				type:            "marcusolsson-json-datasource"
				name:            "KubernetesAPIServer"
				url:             parameter.endpoint
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
	} @step(7)

	parameter: {
		serviceAccountName: *"grafana" | string
		namespace:          *"o11y-system" | string
		uid:                *"kubernetes-api" | string
		grafana:            *"default" | string
		endpoint:           *"https://kubernetes.default" | string
	}
}
