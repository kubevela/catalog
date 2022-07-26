output: {
	type: "webservice"
	properties: {
		imagePullPolicy: "IfNotPresent"
		image:           "fluxcd/source-controller:v0.24.4"
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
				path: "/"
				port: 9090
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
		]
		exposeType: "ClusterIP"
	}
	traits: [
		{
			type: "service-account"
			properties: {
				name: "sa-source-controller"
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
					"--storage-path=/data",
					"--storage-adv-addr=http://source-controller.vela-system.svc:9090",
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
