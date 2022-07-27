package main

imageAutomationController: {
	name: "image-automation-controller"
	type: "worker"
	dependsOn: ["fluxcd-ns"]
	properties: {
		imagePullPolicy: "IfNotPresent"
		image:           parameter.registry + "/fluxcd/image-automation-controller:v0.23.0"
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
			]
		}
	}
	traits: [
		{
			type: "service-account"
			properties: {
				name: "sa-image-automation-controller"
			}
		},
		{
			type: "labels"
			properties: {
				"app.kubernetes.io/instance": "flux-system"
				"control-plane":              "controller"
				// This label is kept to avoid breaking existing 
				// KubeVela e2e tests (makefile e2e-setup).
				"app": "image-automation-controller"
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
		{
			type: "annotations"
			properties: {
				"prometheus.io/port":   "8080"
				"prometheus.io/scrape": "true"
			}
		},
	]
}
