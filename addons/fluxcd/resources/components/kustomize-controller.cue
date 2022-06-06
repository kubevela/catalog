output: {
	type: "worker"
	properties: {
		imagePullPolicy: "IfNotPresent"
		image:           "fluxcd/kustomize-controller:v0.25.0"
		env: [
			{
				name:  "RUNTIME_NAMESPACE"
				value: "vela-system"
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
				name: "sa-kustomize-controller"
			}
		},
		{
			type: "labels"
			properties: {
				"app.kubernetes.io/instance": "vela-system"
				"control-plane":              "controller"
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
