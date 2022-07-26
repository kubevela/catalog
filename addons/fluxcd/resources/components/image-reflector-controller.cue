output: {
	type: "worker"
	properties: {
		imagePullPolicy: "IfNotPresent"
		image:           "fluxcd/image-reflector-controller:v0.18.0"
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
