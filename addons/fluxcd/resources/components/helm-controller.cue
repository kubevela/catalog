package main

_base: string
_rules: [...]
controllerArgs: [...]
_targetNamespace: string

helmController: {
	// About this name, refer to #429 for details.
	name: "fluxcd-helm-controller"
	type: "webservice"
	dependsOn: ["fluxcd-ns"]
	properties: {
		imagePullPolicy: "IfNotPresent"
		image:           _base + "fluxcd/helm-controller:v0.22.0"
		env: [
			{
				name:  "RUNTIME_NAMESPACE"
				value: _targetNamespace
			},
		]
		livenessProbe: {
			httpGet: {
				path: "/healthz"
				port: 9440
			}
			timeoutSeconds: 5
		}
		readinessProbe: {
			httpGet: {
				path: "/readyz"
				port: 9440
			}
			timeoutSeconds: 5
		}
		volumeMounts: {
			emptyDir: [
				{
					name:      "temp"
					mountPath: "/tmp"
				},
			]
		}
	}
	traits: [
		{
			type: "service-account"
			properties: {
				name:       "sa-helm-controller"
				create:     true
				privileges: _rules
			}
		},
		{
			type: "labels"
			properties: {
				"control-plane": "controller"
				// This label is kept to avoid breaking existing 
				// KubeVela e2e tests (makefile e2e-setup).
				"app": "helm-controller"
			}
		},
		{
			type: "command"
			properties: {
				args: controllerArgs
			}
		},
	]
}
