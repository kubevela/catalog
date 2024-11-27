package main

_base: string
_rules: [...]
controllerArgs: [...]
_targetNamespace: string
defaultResources: {
	limits: {
		cpu:    parameter.helmControllerResourceLimits.cpu    | *"1000m"
		memory: parameter.helmControllerResourceLimits.memory | *"1Gi"
	}
	requests: {
		cpu:    parameter.helmControllerResourceRequests.cpu    | *"100m"
		memory: parameter.helmControllerResourceRequests.memory | *"64Mi"
	}
}

helmController: {
	// About this name, refer to #429 for details.
	name: "fluxcd-helm-controller"
	type: "webservice"
	dependsOn: ["fluxcd-ns"]
	properties: {
		imagePullPolicy: "IfNotPresent"
		image:           _base + "fluxcd/helm-controller:v1.1.0"
		env: [
			{
				name:  "RUNTIME_NAMESPACE"
				value: _targetNamespace
			},
			{
				name:  "GOMAXPROCS"
				value: defaultResources.limits.cpu
			},
			{
				name:  "GOMEMLIMIT"
				value: defaultResources.limits.memory
			}
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
		ports: [
			{
				name: "http-prom"
				port: 8080
				expose: false
				protocol: "TCP"
			},
		]
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
			type: "annotations"
			properties: {
				"prometheus.io/port": "8080"
				"prometheus.io/scrape": "true"
			}
		},
		{
			type: "resource"
			properties: defaultResources 
		},
		{
			type: "command"
			properties: {
				if parameter.helmControllerOptions != _|_ {
					args: controllerArgs + parameter.helmControllerOptions
				}
				if parameter.helmControllerOptions == _|_ {
					args: controllerArgs
				}
			}
		},
	]
}
