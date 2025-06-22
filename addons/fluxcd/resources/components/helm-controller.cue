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
		image:           _base + "fluxcd/helm-controller:v1.1.0"
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
			properties: {
				limits: {
					if parameter.helmControllerResourceLimits.cpu  != _|_ {
						cpu:    parameter.helmControllerResourceLimits.cpu	
					}
					if parameter.helmControllerResourceLimits.cpu  == _|_ {
						cpu:    deploymentResources.limits.cpu
					}
					if parameter.helmControllerResourceLimits.memory  != _|_ {
						memory:    parameter.helmControllerResourceLimits.memory	
					}
					if parameter.helmControllerResourceLimits.memory  == _|_ {
						memory:    deploymentResources.limits.memory
					}
				}
				requests: {
					if parameter.helmControllerResourceRequests.cpu  != _|_ {
						cpu:    parameter.helmControllerResourceRequests.cpu	
					}
					if parameter.helmControllerResourceRequests.cpu  == _|_ {
						cpu:    deploymentResources.requests.cpu
					}
					if parameter.helmControllerResourceRequests.memory  != _|_ {
						memory:    parameter.helmControllerResourceRequests.memory	
					}
					if parameter.helmControllerResourceRequests.memory  == _|_ {
						memory:    deploymentResources.requests.memory
					}
				}
			} 
		},
		{
			type: "command"
			properties: {
				if parameter.helmControllerOptions != _|_ {
					args: eventAddrArgs + parameter.helmControllerOptions
				}
				if parameter.helmControllerOptions == _|_ {
					args: eventAddrArgs
				}
			}
		},
	]
}
