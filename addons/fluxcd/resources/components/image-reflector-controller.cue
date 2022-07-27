package main

imageReflectorController: {
	name: "image-reflector-controller"
	type: "webservice"
	dependsOn: ["fluxcd-ns"]
	properties: {
		imagePullPolicy: "IfNotPresent"
		image:           parameter.registry + "/fluxcd/image-reflector-controller:v0.19.0"
		env: [
			{
				name:  "RUNTIME_NAMESPACE"
				value: "flux-system"
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
				{
					name:      "data"
					mountPath: "/data"
				},
			]
		}
	}
	traits: [
		{
			type: "service-account"
			properties: {
				name: "sa-image-reflector-controller"
			}
		},
		{
			type: "labels"
			properties: {
				"app.kubernetes.io/instance": "flux-system"
				"control-plane":              "controller"
				// This label is kept to avoid breaking existing 
				// KubeVela e2e tests (makefile e2e-setup).
				"app": "image-reflector-controller"
			}
		},
		{
			type: "command"
			properties: {
				args: [
					"--watch-all-namespaces",
					"--log-level=debug",
					"--log-encoding=json",
					"--enable-leader-election",
				]
			}
		},
	]
}
