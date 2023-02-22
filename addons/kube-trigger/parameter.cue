package main

const: {
	// +usage=The const name of the resource
	name: "kube-trigger"
	// +usage=The namespace of the addon application
	namespace: "vela-system"
}

parameter: {
	image:           *"oamdev/kube-trigger-manager" | string
	imagePullPolicy: *"IfNotPresent" | "Never" | "Always"
	version:         *"v0.1.0" | string
	resources: {
		requests: {
			cpu:    *"10m" | string
			memory: *"64Mi" | string
		}
		limits: {
			cpu:    *"500m" | string
			memory: *"1Gi" | string
		}
	}
}
