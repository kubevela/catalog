package main

sourceController: {
	name: "source-controller"
	type: "webservice"
	dependsOn: ["fluxcd-ns"]
	properties: {
		imagePullPolicy: "IfNotPresent"
		image:           parameter.registry + "/fluxcd/source-controller:v0.25.1"
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
				"app.kubernetes.io/instance": "flux-system"
				"control-plane":              "controller"
				// This label is kept to avoid breaking existing 
				// KubeVela e2e tests (makefile e2e-setup).
				"app": "source-controller"
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
					"--storage-adv-addr=http://source-controller.flux-system.svc:9090",
				]
			}
		},
	]
}
