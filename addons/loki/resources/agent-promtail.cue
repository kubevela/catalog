package main

promtail: {
	name: "promtail"
	type: "daemon"
	dependsOn: [o11yNamespace.name, promtailConfig.name]
	properties: {
		image:           parameter.promtailImage
		imagePullPolicy: parameter.imagePullPolicy
		env: [{
			name: "HOSTNAME"
			valueFrom: fieldRef: fieldPath: "spec.nodeName"
		}]
		volumeMounts: {
			configMap: [{
				name:      "bootconfig-volume"
				mountPath: "/etc/bootconfig"
				cmName:    "promtail"
			}]
			hostPath: [{
				name:      "run"
				path:      "/run/promtail"
				mountPath: "/run/promtail"
			}, {
				name:      "containers"
				path:      "/var/lib/docker/containers"
				mountPath: "/var/lib/docker/containers"
				readOnly:  true
			}, {
				name:      "pods"
				path:      "/var/log/pods"
				mountPath: "/var/log/pods"
				readOnly:  true
			}]
		}
		readinessProbe: {
			httpGet: {
				path: "/ready"
				port: 3101
			}
			initialDelaySeconds: 10
		}
	}
	traits: [{
		type: "command"
		properties: args: ["-config.file=/etc/config/agent.yaml"]
	}, {
		type: "json-patch"
		properties: operations: [{
			op:   "add"
			path: "/spec/template/spec/containers/0/securityContext"
			value: {
				allowPrivilegeEscalation: false
				capabilities: drop: ["ALL"]
				readOnlyRootFilesystem: true
			}
		}]
	}] + [agentInitContainer, {
		agentServiceAccount
		properties: name: "promtail"
	}]
}

promtailConfig: {
	name: "promtail-config"
	type: "k8s-objects"
	dependsOn: [o11yNamespace.name]
	properties: objects: [{
		apiVersion: "v1"
		kind:       "ConfigMap"
		metadata: name: "promtail"
		data: {
			"agent.yaml": #"""
				server:
				  log_level: info
				  http_listen_port: 3101

				clients:
				  - url: http://loki:3100/loki/api/v1/push
				
				positions:
				  filename: /run/promtail/positions.yaml
				
				scrape_configs:
				  # See also https://github.com/grafana/loki/blob/master/production/ksonnet/promtail/scrape_config.libsonnet for reference
				  - job_name: kubernetes-pods
				    pipeline_stages:
				      - cri: {}
				      - static_labels:
				          agent: promtail
				          cluster: $CLUSTER
				          forward: daemon
				    kubernetes_sd_configs:
				      - role: pod
				    relabel_configs:
				      - action: replace
				        source_labels:
				        - __meta_kubernetes_namespace
				        target_label: namespace
				      - action: replace
				        source_labels:
				        - __meta_kubernetes_pod_name
				        target_label: pod
				      - action: replace
				        source_labels:
				        - __meta_kubernetes_pod_container_name
				        target_label: container
				      - action: replace
				        replacement: /var/log/pods/*$1/*.log
				        separator: /
				        source_labels:
				        - __meta_kubernetes_pod_uid
				        - __meta_kubernetes_pod_container_name
				        target_label: __path__
				      - action: replace
				        regex: true/(.*)
				        replacement: /var/log/pods/*$1/*.log
				        separator: /
				        source_labels:
				        - __meta_kubernetes_pod_annotationpresent_kubernetes_io_config_hash
				        - __meta_kubernetes_pod_annotation_kubernetes_io_config_hash
				        - __meta_kubernetes_pod_container_name
				        target_label: __path__
				"""#
		}
	}]
}
