package main

prometheusConfig: {
	name: "prometheus-config"
	type: "k8s-objects"
	dependsOn: [o11yNamespace.name]
	properties: objects: [{
		apiVersion: "v1"
		kind:       "ConfigMap"
		metadata: name: "prometheus-server"
		data: {
			"allow-snippet-annotations": "false"
			"alerting_rules.yml":        "{}"
			"alerts":                    "{}"
			"prometheus.yml": ##"""
				global:
				  evaluation_interval: 1m
				  scrape_interval: 1m
				  scrape_timeout: 10s
				  external_labels:
				    cluster: $CLUSTER
				rule_files:
				- /etc/config/recording_rules.yml
				- /etc/config/alerting_rules.yml
				- /etc/config/rules
				- /etc/config/alerts
				- /etc/custom/*.yml
				scrape_configs:
				- job_name: prometheus
				  static_configs:
				  - targets:
				    - localhost:9090
				    labels:
				      cluster: $CLUSTER
				- bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
				  job_name: kubernetes-apiservers
				  kubernetes_sd_configs:
				  - role: endpoints
				  relabel_configs:
				  - action: keep
				    regex: default;kubernetes;https
				    source_labels:
				    - __meta_kubernetes_namespace
				    - __meta_kubernetes_service_name
				    - __meta_kubernetes_endpoint_port_name
				  - replacement: $CLUSTER
				    target_label: cluster
				  scheme: https
				  tls_config:
				    ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
				    insecure_skip_verify: true
				- bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
				  job_name: kubernetes-nodes
				  kubernetes_sd_configs:
				  - role: node
				  relabel_configs:
				  - action: labelmap
				    regex: __meta_kubernetes_node_label_(.+)
				  - replacement: kubernetes.default.svc:443
				    target_label: __address__
				  - regex: (.+)
				    replacement: /api/v1/nodes/$1/proxy/metrics
				    source_labels:
				    - __meta_kubernetes_node_name
				    target_label: __metrics_path__
				  - replacement: $CLUSTER
				    target_label: cluster
				  scheme: https
				  tls_config:
				    ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
				    insecure_skip_verify: true
				- bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
				  job_name: kubernetes-nodes-cadvisor
				  kubernetes_sd_configs:
				  - role: node
				  relabel_configs:
				  - action: labelmap
				    regex: __meta_kubernetes_node_label_(.+)
				  - replacement: kubernetes.default.svc:443
				    target_label: __address__
				  - regex: (.+)
				    replacement: /api/v1/nodes/$1/proxy/metrics/cadvisor
				    source_labels:
				    - __meta_kubernetes_node_name
				    target_label: __metrics_path__
				  - replacement: $CLUSTER
				    target_label: cluster
				  scheme: https
				  tls_config:
				    ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
				    insecure_skip_verify: true
				- honor_labels: true
				  job_name: kubernetes-service-endpoints
				  kubernetes_sd_configs:
				  - role: endpoints
				  relabel_configs:
				  - action: keep
				    regex: true
				    source_labels:
				    - __meta_kubernetes_service_annotation_prometheus_io_scrape
				  - action: drop
				    regex: true
				    source_labels:
				    - __meta_kubernetes_service_annotation_prometheus_io_scrape_slow
				  - action: replace
				    regex: (https?)
				    source_labels:
				    - __meta_kubernetes_service_annotation_prometheus_io_scheme
				    target_label: __scheme__
				  - action: replace
				    regex: (.+)
				    source_labels:
				    - __meta_kubernetes_service_annotation_prometheus_io_path
				    target_label: __metrics_path__
				  - action: replace
				    regex: (.+?)(?::\d+)?;(\d+)
				    replacement: $1:$2
				    source_labels:
				    - __address__
				    - __meta_kubernetes_service_annotation_prometheus_io_port
				    target_label: __address__
				  - action: labelmap
				    regex: __meta_kubernetes_service_annotation_prometheus_io_param_(.+)
				    replacement: __param_$1
				  - action: labelmap
				    regex: __meta_kubernetes_service_label_(.+)
				  - action: replace
				    source_labels:
				    - __meta_kubernetes_namespace
				    target_label: namespace
				  - action: replace
				    source_labels:
				    - __meta_kubernetes_service_name
				    target_label: service
				  - action: replace
				    source_labels:
				    - __meta_kubernetes_pod_node_name
				    target_label: node
				  - replacement: $CLUSTER
				    target_label: cluster
				- honor_labels: true
				  job_name: kubernetes-service-endpoints-slow
				  kubernetes_sd_configs:
				  - role: endpoints
				  relabel_configs:
				  - action: keep
				    regex: true
				    source_labels:
				    - __meta_kubernetes_service_annotation_prometheus_io_scrape_slow
				  - action: replace
				    regex: (https?)
				    source_labels:
				    - __meta_kubernetes_service_annotation_prometheus_io_scheme
				    target_label: __scheme__
				  - action: replace
				    regex: (.+)
				    source_labels:
				    - __meta_kubernetes_service_annotation_prometheus_io_path
				    target_label: __metrics_path__
				  - action: replace
				    regex: (.+?)(?::\d+)?;(\d+)
				    replacement: $1:$2
				    source_labels:
				    - __address__
				    - __meta_kubernetes_service_annotation_prometheus_io_port
				    target_label: __address__
				  - action: labelmap
				    regex: __meta_kubernetes_service_annotation_prometheus_io_param_(.+)
				    replacement: __param_$1
				  - action: labelmap
				    regex: __meta_kubernetes_service_label_(.+)
				  - action: replace
				    source_labels:
				    - __meta_kubernetes_namespace
				    target_label: namespace
				  - action: replace
				    source_labels:
				    - __meta_kubernetes_service_name
				    target_label: service
				  - action: replace
				    source_labels:
				    - __meta_kubernetes_pod_node_name
				    target_label: node
				  - replacement: $CLUSTER
				    target_label: cluster
				  scrape_interval: 5m
				  scrape_timeout: 30s
				- honor_labels: true
				  job_name: prometheus-pushgateway
				  kubernetes_sd_configs:
				  - role: service
				  relabel_configs:
				  - action: keep
				    regex: pushgateway
				    source_labels:
				    - __meta_kubernetes_service_annotation_prometheus_io_probe
				  - replacement: $CLUSTER
				    target_label: cluster
				- honor_labels: true
				  job_name: kubernetes-services
				  kubernetes_sd_configs:
				  - role: service
				  metrics_path: /probe
				  params:
				    module:
				    - http_2xx
				  relabel_configs:
				  - action: keep
				    regex: true
				    source_labels:
				    - __meta_kubernetes_service_annotation_prometheus_io_probe
				  - source_labels:
				    - __address__
				    target_label: __param_target
				  - replacement: blackbox
				    target_label: __address__
				  - source_labels:
				    - __param_target
				    target_label: instance
				  - action: labelmap
				    regex: __meta_kubernetes_service_label_(.+)
				  - source_labels:
				    - __meta_kubernetes_namespace
				    target_label: namespace
				  - source_labels:
				    - __meta_kubernetes_service_name
				    target_label: service
				  - replacement: $CLUSTER
				    target_label: cluster
				- honor_labels: true
				  job_name: kubernetes-pods
				  kubernetes_sd_configs:
				  - role: pod
				  relabel_configs:
				  - action: keep
				    regex: true
				    source_labels:
				    - __meta_kubernetes_pod_annotation_prometheus_io_scrape
				  - action: drop
				    regex: true
				    source_labels:
				    - __meta_kubernetes_pod_annotation_prometheus_io_scrape_slow
				  - action: replace
				    regex: (https?)
				    source_labels:
				    - __meta_kubernetes_pod_annotation_prometheus_io_scheme
				    target_label: __scheme__
				  - action: replace
				    regex: (.+)
				    source_labels:
				    - __meta_kubernetes_pod_annotation_prometheus_io_path
				    target_label: __metrics_path__
				  - action: replace
				    regex: (.+?)(?::\d+)?;(\d+)
				    replacement: $1:$2
				    source_labels:
				    - __address__
				    - __meta_kubernetes_pod_annotation_prometheus_io_port
				    target_label: __address__
				  - action: labelmap
				    regex: __meta_kubernetes_pod_annotation_prometheus_io_param_(.+)
				    replacement: __param_$1
				  - action: labelmap
				    regex: __meta_kubernetes_pod_label_(.+)
				  - action: replace
				    source_labels:
				    - __meta_kubernetes_namespace
				    target_label: namespace
				  - action: replace
				    source_labels:
				    - __meta_kubernetes_pod_name
				    target_label: pod
				  - action: drop
				    regex: Pending|Succeeded|Failed|Completed
				    source_labels:
				    - __meta_kubernetes_pod_phase
				  - replacement: $CLUSTER
				    target_label: cluster
				- honor_labels: true
				  job_name: kubernetes-pods-slow
				  kubernetes_sd_configs:
				  - role: pod
				  relabel_configs:
				  - action: keep
				    regex: true
				    source_labels:
				    - __meta_kubernetes_pod_annotation_prometheus_io_scrape_slow
				  - action: replace
				    regex: (https?)
				    source_labels:
				    - __meta_kubernetes_pod_annotation_prometheus_io_scheme
				    target_label: __scheme__
				  - action: replace
				    regex: (.+)
				    source_labels:
				    - __meta_kubernetes_pod_annotation_prometheus_io_path
				    target_label: __metrics_path__
				  - action: replace
				    regex: (.+?)(?::\d+)?;(\d+)
				    replacement: $1:$2
				    source_labels:
				    - __address__
				    - __meta_kubernetes_pod_annotation_prometheus_io_port
				    target_label: __address__
				  - action: labelmap
				    regex: __meta_kubernetes_pod_annotation_prometheus_io_param_(.+)
				    replacement: __param_$1
				  - action: labelmap
				    regex: __meta_kubernetes_pod_label_(.+)
				  - action: replace
				    source_labels:
				    - __meta_kubernetes_namespace
				    target_label: namespace
				  - action: replace
				    source_labels:
				    - __meta_kubernetes_pod_name
				    target_label: pod
				  - action: drop
				    regex: Pending|Succeeded|Failed|Completed
				    source_labels:
				    - __meta_kubernetes_pod_phase
				  - replacement: $CLUSTER
				    target_label: cluster
				  scrape_interval: 5m
				  scrape_timeout: 30s
				alerting:
				  alertmanagers:
				  - kubernetes_sd_configs:
				      - role: pod
				    tls_config:
				      ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
				    bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
				    relabel_configs:
				    - source_labels: [__meta_kubernetes_namespace]
				      regex: default
				      action: keep
				    - source_labels: [__meta_kubernetes_pod_label_app]
				      regex: prometheus
				      action: keep
				    - source_labels: [__meta_kubernetes_pod_label_component]
				      regex: alertmanager
				      action: keep
				    - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_probe]
				      regex: .*
				      action: keep
				    - source_labels: [__meta_kubernetes_pod_container_port_number]
				      regex: "9093"
				      action: keep
				"""##
			"recording_rules.yml": "{}"
			"rules":               "{}"
		}
	}]
}
