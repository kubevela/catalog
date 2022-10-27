import (
	"encoding/yaml"
	"path"
)

"file-logs-collector": {
	annotations: {}
	attributes: {
		appliesToWorkloads: [
			"deployments.apps",
			"statefulsets.apps",
		]
		podDisruptive: false
	}
	description: "Collect log from file or stdout using vector"
	type:        "trait"
}

template: {
	_dir: *"" | string

	outputs: config: {
		apiVersion: "v1"
		kind:       "ConfigMap"
		metadata: {
			name: context.name + "-vector-config"
		}
		data: {
			"vector.yaml": yaml.Marshal(configFile)
		}
	}

	_dir: path.Dir(parameter.path)

	patch: {
		// +patchKey=name
		spec: template: spec: volumes: [
			{
				name: "vector-config"
				projected: {
					defaultMode: 420
					sources: [
						{configMap: name: context.name + "-vector-config"},
					]
				}
			},
			{
				name: "container-log"
				emptyDir: {}
			},
			{
				name: "vector-data"
				emptyDir: {}
			},
		]
	}

	patch: {
		// +patchKey=name
		spec: template: spec: containers: [{
			name:  "vector-log"
			image: "timberio/vector:0.23.3-alpine"
			args: ["--config-dir", "/etc/vector/"]
			env: [
				{
					name:                               "MY_POD_NAME"
					valueFrom: fieldRef: {"apiVersion": "v1", "fieldPath": "metadata.name"}
				},
				{
					name:                               "MY_POD_NAMESPACE"
					valueFrom: fieldRef: {"apiVersion": "v1", "fieldPath": "metadata.namespace"}
				},
			]
			volumeMounts: [
				{
					mountPath: "/data" + _dir
					name:      "container-log"
				},
				{
					mountPath: "/etc/vector/"
					name:      "vector-config"
				},
				{
					mountPath: "/vector-data-dir"
					name:      "vector-data"
				},
			]}, {
			name: context.name
			volumeMounts: [{
				{
					mountPath: _dir
					name:      "container-log"
				}
			}]
		},
		]
	}

	configFile: {
		data_dir: "/vector-data-dir"
		api: {
			enabled:    true
			address:    "127.0.0.1:8686"
			playground: false
		}
		sources: {
			my_source_id: {
				type:              "file"
				ignore_older_secs: 600
				include: ["/data" + parameter.path]
				read_from: "beginning"
			}
		}
		sinks: {
			loki: {
				type: "loki"
				inputs: ["my_source_id"]
				endpoint:    "http://loki.o11y-system:3100"
				compression: "none"
				labels: {
					agent:     "vector"
					stream:    "file"
					forward:   "sidecar"
					filename:  "{{ file }}"
					pod:       "${MY_POD_NAME}"
					namespace: "${MY_POD_NAMESPACE}"
					cluster:   context.cluster
				}
				encoding: {
					codec: "json"
				}
			}
		}
	}

	parameter: {
		path: string
	}

}
