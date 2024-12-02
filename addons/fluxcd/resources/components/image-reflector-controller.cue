package main

_base: string
_rules: [...]
controllerArgs: [...]
_targetNamespace: string

imageReflectorController: {
	// About this name, refer to #429 for details.
	name: "fluxcd-image-reflector-controller"
	type: "webservice"
	dependsOn: ["fluxcd-ns"]
	properties: {
		imagePullPolicy: "IfNotPresent"
		image:           _base + "fluxcd/image-reflector-controller:v0.33.0"
		env: [
			{
				name:  "RUNTIME_NAMESPACE"
				value: _targetNamespace
			},
			{
				name: "GOMAXPROCS"
				valueFrom: {
					resourceFieldRef: {
						resource: "limits.cpu"
					}
				}			
			},
			{
				name: "GOMEMLIMIT"
				valueFrom: {
					resourceFieldRef: {
						resource: "limits.memory"
					}
				}			
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
				{
					name:      "data"
					mountPath: "/data"
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
				name:       "sa-image-reflector-controller"
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
				"app": "image-reflector-controller"
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
			properties: {
				limits: {
					if parameter.imageReflectorControllerResourceLimits.cpu  != _|_ {
						cpu:    parameter.imageReflectorControllerResourceLimits.cpu	
					}
					if parameter.imageReflectorControllerResourceLimits.cpu  == _|_ {
						cpu:    deploymentResources.limits.cpu
					}
					if parameter.imageReflectorControllerResourceLimits.memory  != _|_ {
						memory:    parameter.imageReflectorControllerResourceLimits.memory	
					}
					if parameter.imageReflectorControllerResourceLimits.memory  == _|_ {
						memory:    deploymentResources.limits.memory
					}
				}
				requests: {
					if parameter.imageReflectorControllerResourceRequests.cpu  != _|_ {
						cpu:    parameter.imageReflectorControllerResourceRequests.cpu	
					}
					if parameter.imageReflectorControllerResourceRequests.cpu  == _|_ {
						cpu:    deploymentResources.requests.cpu
					}
					if parameter.imageReflectorControllerResourceRequests.memory  != _|_ {
						memory:    parameter.imageReflectorControllerResourceRequests.memory	
					}
					if parameter.imageReflectorControllerResourceRequests.memory  == _|_ {
						memory:    deploymentResources.requests.memory
					}
				}
			} 
		},
		{
			type: "command"
			properties: {
				if parameter.imageReflectorControllerOptions != _|_ {
					args: eventAddrArgs + parameter.imageReflectorControllerOptions
				}
				if parameter.imageReflectorControllerOptions == _|_ {
					args: eventAddrArgs
				}
			}
		},
	]
}
