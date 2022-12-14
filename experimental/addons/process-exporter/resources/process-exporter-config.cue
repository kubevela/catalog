package main

processExporterConfig: {
	name: "process-exporter-config"
	type: "k8s-objects"
	dependsOn: [o11yNamespace.name]
	properties: objects: [{
		apiVersion: "v1"
		kind:       "ConfigMap"
		metadata: name: "process-exporter"
		data: {
			"process.yaml": #"""
				process_names:
				  - name: "{{.Comm}}"
				    cmdline:
				    - '.+'
				"""#
		}
	}]
}
