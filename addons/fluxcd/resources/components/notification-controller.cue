package main

_base: string
_rules: [...]
controllerArgs: [...]
_targetNamespace: string

notificationController: {
	// About this name, refer to #429 for details.
	name: "fluxcd-notification-controller"
	type: "webservice"
	dependsOn: ["fluxcd-ns"]
	properties: {
		imagePullPolicy: "IfNotPresent"
		image:           _base + "fluxcd/notification-controller:v1.4.0"
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
				port:     9090
				name:     "http"
				protocol: "TCP"
				expose:   true
			},
			{
				port:     9292
				name:     "http-webhook"
				protocol: "TCP"
				expose:   true
			},
			{
				name: "http-prom"
				port: 8080
				expose: false
				protocol: "TCP"
			},
		]
		exposeType: "ClusterIP"
	}
	traits: [
		{
			type: "service-account"
			properties: {
				name:       "sa-notification-controller"
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
				"app": "notification-controller"
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
					if parameter.notificationControllerResourceLimits.cpu  != _|_ {
						cpu:    parameter.notificationControllerResourceLimits.cpu	
					}
					if parameter.notificationControllerResourceLimits.cpu  == _|_ {
						cpu:    deploymentResources.limits.cpu
					}
					if parameter.notificationControllerResourceLimits.memory  != _|_ {
						memory:    parameter.notificationControllerResourceLimits.memory	
					}
					if parameter.sourceControllerResourceLimits.memory  == _|_ {
						memory:    deploymentResources.limits.memory
					}
				}
				requests: {
					if parameter.notificationControllerResourceRequests.cpu  != _|_ {
						cpu:    parameter.notificationControllerResourceRequests.cpu	
					}
					if parameter.notificationControllerResourceRequests.cpu  == _|_ {
						cpu:    deploymentResources.requests.cpu
					}
					if parameter.notificationControllerResourceRequests.memory  != _|_ {
						memory:    parameter.notificationControllerResourceRequests.memory	
					}
					if parameter.notificationControllerResourceRequests.memory  == _|_ {
						memory:    deploymentResources.requests.memory
					}
				}
			} 
		},
		{
			type: "command"
			properties: {
				if parameter.notificationControllerOptions != _|_ {
					args: controllerArgs + parameter.notificationControllerOptions
				}
				if parameter.notificationControllerOptions == _|_ {
					args: controllerArgs
				}
			}
		},
	]
}
