package main

_base: string
_rules: [...]
controllerArgs: [...]
_targetNamespace: string
// imageControllerDefaultArgs: controllerArgs + [
// 	"--events-addr=" + "http://fluxcd-notification-controller." + _targetNamespace + ".svc:9090"
// ]

kustomizeController: {
	// About this name, refer to #429 for details.
	name: "fluxcd-kustomize-controller"
	type: "webservice"
	dependsOn: ["fluxcd-ns"]
	properties: {
		imagePullPolicy: "IfNotPresent"
		image:           _base + "fluxcd/kustomize-controller:v1.4.0"
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
				name:       "sa-kustomize-controller"
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
				"app": "kustomize-controller"
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
					if parameter.kustomizeControllerResourceLimits.cpu  != _|_ {
						cpu:    parameter.kustomizeControllerResourceLimits.cpu	
					}
					if parameter.kustomizeControllerResourceLimits.cpu  == _|_ {
						cpu:    deploymentResources.limits.cpu
					}
					if parameter.kustomizeControllerResourceLimits.memory  != _|_ {
						memory:    parameter.kustomizeControllerResourceLimits.memory	
					}
					if parameter.kustomizeControllerResourceLimits.memory  == _|_ {
						memory:    deploymentResources.limits.memory
					}
				}
				requests: {
					if parameter.kustomizeControllerResourceLimits.cpu  != _|_ {
						cpu:    parameter.kustomizeControllerResourceLimits.cpu	
					}
					if parameter.kustomizeControllerResourceLimits.cpu  == _|_ {
						cpu:    deploymentResources.requests.cpu
					}
					if parameter.kustomizeControllerResourceLimits.memory  != _|_ {
						memory:    parameter.kustomizeControllerResourceLimits.memory	
					}
					if parameter.kustomizeControllerResourceLimits.memory  == _|_ {
						memory:    deploymentResources.requests.memory
					}
				}
			} 
		},
		{
			type: "command"
			properties: {
				if parameter.kustomizeControllerOptions != _|_ {
					args: eventAddrArgs + parameter.kustomizeControllerOptions
				}
				if parameter.kustomizeControllerOptions == _|_ {
					args: eventAddrArgs
				}
			}
		},
	]
}
