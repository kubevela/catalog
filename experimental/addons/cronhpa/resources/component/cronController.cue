package main

cronController: {
	name: "cron-controller"
	type: "webservice"
	properties: {
		image:           parameter.registry + "/" + parameter.repository + ":" + parameter.imageTag
		imagePullPolicy: parameter.imagePullPolicy
		if parameter.imagePullSecrets != _|_ {
			imagePullSecrets: [ for v in parameter.imagePullSecrets {
				v
			},
			]
		}
		env: [
			{
				name:  "TZ"
				value: '"Asia/Shanghai"'
			},
		]
	}
	traits: [
		{
			type: "scaler"
			properties: {
				replicas: parameter.replicas
			}
		}, {
			type: "resource"
			properties: {
				requests: {
					cpu:    parameter.resources.requests.cpu
					memory: parameter.resources.requests.memory
				}
				limits: {
					cpu:    parameter.resources.limits.cpu
					memory: parameter.resources.limits.memory
				}
			}
		}, {
			type: "labels"
			properties: {
				"app":                     "kubernetes-cronhpa-controller"
				"controller-tools.k8s.io": '2.0'
			}
		}, {
			type: "service-account"
			properties: {
				create: true
				name:   "kubernetes-cronhpa-controller"
			}
		},
	]
}
