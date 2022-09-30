package main

agentInitContainer: {...}
agentServiceAccount: {...}

vector: {
	name: "vector"
	type: "daemon"
	properties: {
		image:           parameter.vectorImage
		imagePullPolicy: parameter.imagePullPolicy
		env: [{
			name: "VECTOR_SELF_NODE_NAME"
			valueFrom: fieldRef: fieldPath: "spec.nodeName"
		}, {
			name: "VECTOR_SELF_POD_NAME"
			valueFrom: fieldRef: fieldPath: "metadata.name"
		}, {
			name: "VECTOR_SELF_POD_NAMESPACE"
			valueFrom: fieldRef: fieldPath: "metadata.namespace"
		}, {
			name:  "PROCFS_ROOT"
			value: "/host/proc"
		}, {
			name:  "SYSFS_ROOT"
			value: "/host/sys"
		}]
		volumeMounts: {
			configMap: [{
				name:      "bootconfig-volume"
				mountPath: "/etc/bootconfig"
				cmName:    "vector"
			}, {
				name:      "loki-endpoint-volume"
				mountPath: "/etc/loki-endpoint"
				cmName:    "loki-endpoint"
			}]
			hostPath: [{
				name:      "data"
				path:      "/var/lib/vector"
				mountPath: "/vector-data-dir"
			}, {
				name:      "var-log"
				path:      "/var/log/"
				mountPath: "/var/log/"
				readOnly:  true
			}, {
				name:      "var-lib"
				path:      "/var/lib/"
				mountPath: "/var/lib/"
				readOnly:  true
			}, {
				name:      "procfs"
				path:      "/proc"
				mountPath: "/host/proc"
				readOnly:  true
			}, {
				name:      "sysfs"
				path:      "/sys"
				mountPath: "/host/sys"
				readOnly:  true
			}]
		}
	}
	traits: [{
		type: "command"
		properties: args: ["--config-dir", "/etc/config/"]
	}] + [agentInitContainer, {
		agentServiceAccount
		properties: name: "vector"
	}]
}

vectorConfig: {
	name: "vector-config"
	type: "k8s-objects"
	properties: objects: [{
		apiVersion: "v1"
		kind:       "ConfigMap"
		metadata: name: "vector"
		data: {
			"agent.yaml": #"""
				data_dir: /vector-data-dir
				sources:
				  kubernetes-logs:
				    type: kubernetes_logs
				sinks:
				  loki:
				    type: loki
				    inputs:
				      - kubernetes-logs
				    endpoint: $LOKIURL
				    compression: none
				    request:
				      concurrency: 10
				    labels:
				      agent: vector
				      cluster: $CLUSTER
				      stream: "{{ stream }}"
				      forward: daemon
				      filename: "{{ file }}"
				      pod: "{{ kubernetes.pod_name }}"
				      namespace: "{{ kubernetes.pod_namespace }}"
				      container: "{{ kubernetes.container_name }}"
				    encoding:
				      codec: json
				"""#
		}
	}]
}
