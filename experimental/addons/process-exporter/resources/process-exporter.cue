package main

processExporter: {
	name: "process-exporter"
	type: "daemon"
	dependsOn: [o11yNamespace.name, processExporterConfig.name]
	properties: {
		image:           parameter["image"]
		imagePullPolicy: parameter["imagePullPolicy"]
		volumeMounts: {
			configMap: [{
				name:      "config"
				mountPath: "/config"
				cmName:    "process-exporter"
			}]
			hostPath: [{
				name:             "proc"
				mountPath:        "/host/proc"
				mountPropagation: "HostToContainer"
				path:             "/proc"
				readOnly:         true
			}]
		}
	}
	traits: [{
		type: "command"
		properties: args: [
			"--procfs=/host/proc",
			"-config.path=/config/process.yaml",
		]
	}, {
		type: "expose"
		properties: {
			port: [9256]
			annotations: {
				"prometheus.io/port":   "9256"
				"prometheus.io/scrape": "true"
				"prometheus.io/path":   "/metrics"
			}
		}
	}, {
		type: "resource"
		properties: {
			cpu:    parameter["cpu"]
			memory: parameter["memory"]
		}
	}]
}
