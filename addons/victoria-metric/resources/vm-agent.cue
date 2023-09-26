output: {
	name: "vm-agent"
	type: "helm"
	properties: {
		repoType: "helm"
		url:      "https://victoriametrics.github.io/helm-charts/"
		chart:    "victoria-metrics-agent"
		version:  "0.9.10"
		targetNamespace: parameter.namespace
		values: {
			remoteWriteUrls: ["http://victoria-metrics-cluster-vminsert:8480/insert/0/prometheus"]
			config: {
				"global": {
					"scrape_interval": "10s"
				}
				"scrape_configs": [
					{
						"job_name": "vmagent"
						"static_configs": [
							{
								"targets": [
									"localhost:8429",
								]
							},
						]
					},
					{
						"job_name": "ksm"
						"kubernetes_sd_configs": [
							{
								"role": "endpointslices"
							},
						]
						"relabel_configs": [
							{
								"action": "drop"
								"source_labels": [
									"__meta_kubernetes_pod_container_init",
								]
								"regex": true
							},
							{
								"action": "keep_if_equal"
								"source_labels": [
									"__meta_kubernetes_service_annotation_prometheus_io_port",
									"__meta_kubernetes_pod_container_port_number",
								]
							},
							{
								"source_labels": [
									"__meta_kubernetes_service_annotation_prometheus_io_scrape",
								]
								"action": "keep"
								"regex":  true
							},
							{
								"source_labels": [
									"__meta_kubernetes_service_annotation_oam_dev_addon_name",
								]
								"action": "keep"
								"regex":  "kube-state-metric"
							},
							{
								"source_labels": [
									"__meta_kubernetes_service_annotation_prometheus_io_scheme",
								]
								"action":       "replace"
								"target_label": "__scheme__"
								"regex":        "(https?)"
							},
							{
								"source_labels": [
									"__meta_kubernetes_service_annotation_prometheus_io_path",
								]
								"action":       "replace"
								"target_label": "__metrics_path__"
								"regex":        "(.+)"
							},
							{
								"source_labels": [
									"__address__",
									"__meta_kubernetes_service_annotation_prometheus_io_port",
								]
								"action":       "replace"
								"target_label": "__address__"
								"regex":        "([^:]+)(?::\\d+)?;(\\d+)"
								"replacement":  "$1:$2"
							},
							{
								"action": "labelmap"
								"regex":  "__meta_kubernetes_service_label_(.+)"
							},
							{
								"source_labels": [
									"__meta_kubernetes_service_name",
								]
								"target_label": "job"
								"replacement":  "${1}"
							}
						]
					},
					{
						"job_name": "kubernetes-apiservers"
						"kubernetes_sd_configs": [
							{
								"role": "endpoints"
							},
						]
						"scheme": "https"
						"tls_config": {
							"ca_file":              "/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
							"insecure_skip_verify": true
						}
						"bearer_token_file": "/var/run/secrets/kubernetes.io/serviceaccount/token"
						"relabel_configs": [
							{
								"source_labels": [
									"__meta_kubernetes_namespace",
									"__meta_kubernetes_service_name",
									"__meta_kubernetes_endpoint_port_name",
								]
								"action": "keep"
								"regex":  "default;kubernetes;https"
							},
						]
					},
					{
						"job_name": "kubernetes-nodes"
						"scheme":   "https"
						"tls_config": {
							"ca_file":              "/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
							"insecure_skip_verify": true
						}
						"bearer_token_file": "/var/run/secrets/kubernetes.io/serviceaccount/token"
						"kubernetes_sd_configs": [
							{
								"role": "node"
							},
						]
						"relabel_configs": [
							{
								"action": "labelmap"
								"regex":  "__meta_kubernetes_node_label_(.+)"
							},
							{
								"target_label": "__address__"
								"replacement":  "kubernetes.default.svc:443"
							},
							{
								"source_labels": [
									"__meta_kubernetes_node_name",
								]
								"regex":        "(.+)"
								"target_label": "__metrics_path__"
								"replacement":  "/api/v1/nodes/$1/proxy/metrics"
							},
						]
					},
					{
						"job_name": "kubernetes-nodes-cadvisor"
						"scheme":   "https"
						"tls_config": {
							"ca_file":              "/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
							"insecure_skip_verify": true
						}
						"bearer_token_file": "/var/run/secrets/kubernetes.io/serviceaccount/token"
						"kubernetes_sd_configs": [
							{
								"role": "node"
							},
						]
						"relabel_configs": [
							{
								"action": "labelmap"
								"regex":  "__meta_kubernetes_node_label_(.+)"
							},
							{
								"target_label": "__address__"
								"replacement":  "kubernetes.default.svc:443"
							},
							{
								"source_labels": [
									"__meta_kubernetes_node_name",
								]
								"regex":        "(.+)"
								"target_label": "__metrics_path__"
								"replacement":  "/api/v1/nodes/$1/proxy/metrics/cadvisor"
							},
						]
						"honor_timestamps": false
					},
					{
						"job_name": "kubernetes-service-endpoints"
						"kubernetes_sd_configs": [
							{
								"role": "endpointslices"
							},
						]
						"relabel_configs": [
							{
								"action": "drop"
								"source_labels": [
									"__meta_kubernetes_pod_container_init",
								]
								"regex": true
							},
							{
								"source_labels": [
									"__meta_kubernetes_service_annotation_oam_dev_addon_name",
								]
								"action": "drop"
								"regex":  "kube-state-metric"
							},
							{
								"action": "keep_if_equal"
								"source_labels": [
									"__meta_kubernetes_service_annotation_prometheus_io_port",
									"__meta_kubernetes_pod_container_port_number",
								]
							},
							{
								"source_labels": [
									"__meta_kubernetes_service_annotation_prometheus_io_scrape",
								]
								"action": "keep"
								"regex":  true
							},
							{
								"source_labels": [
									"__meta_kubernetes_service_annotation_prometheus_io_scheme",
								]
								"action":       "replace"
								"target_label": "__scheme__"
								"regex":        "(https?)"
							},
							{
								"source_labels": [
									"__meta_kubernetes_service_annotation_prometheus_io_path",
								]
								"action":       "replace"
								"target_label": "__metrics_path__"
								"regex":        "(.+)"
							},
							{
								"source_labels": [
									"__address__",
									"__meta_kubernetes_service_annotation_prometheus_io_port",
								]
								"action":       "replace"
								"target_label": "__address__"
								"regex":        "([^:]+)(?::\\d+)?;(\\d+)"
								"replacement":  "$1:$2"
							},
							{
								"action": "labelmap"
								"regex":  "__meta_kubernetes_service_label_(.+)"
							},
							{
								"source_labels": [
									"__meta_kubernetes_pod_name",
								]
								"target_label": "pod"
							},
							{
								"source_labels": [
									"__meta_kubernetes_pod_container_name",
								]
								"target_label": "container"
							},
							{
								"source_labels": [
									"__meta_kubernetes_namespace",
								]
								"target_label": "namespace"
							},
							{
								"source_labels": [
									"__meta_kubernetes_service_name",
								]
								"target_label": "service"
							},
							{
								"source_labels": [
									"__meta_kubernetes_service_name",
								]
								"target_label": "job"
								"replacement":  "${1}"
							},
							{
								"source_labels": [
									"__meta_kubernetes_pod_node_name",
								]
								"action":       "replace"
								"target_label": "node"
							},
						]
					},
					{
						"job_name":        "kubernetes-service-endpoints-slow"
						"scrape_interval": "5m"
						"scrape_timeout":  "30s"
						"kubernetes_sd_configs": [
							{
								"role": "endpointslices"
							},
						]
						"relabel_configs": [
							{
								"action": "drop"
								"source_labels": [
									"__meta_kubernetes_pod_container_init",
								]
								"regex": true
							},
							{
								"action": "keep_if_equal"
								"source_labels": [
									"__meta_kubernetes_service_annotation_prometheus_io_port",
									"__meta_kubernetes_pod_container_port_number",
								]
							},
							{
								"source_labels": [
									"__meta_kubernetes_service_annotation_prometheus_io_scrape_slow",
								]
								"action": "keep"
								"regex":  true
							},
							{
								"source_labels": [
									"__meta_kubernetes_service_annotation_prometheus_io_scheme",
								]
								"action":       "replace"
								"target_label": "__scheme__"
								"regex":        "(https?)"
							},
							{
								"source_labels": [
									"__meta_kubernetes_service_annotation_prometheus_io_path",
								]
								"action":       "replace"
								"target_label": "__metrics_path__"
								"regex":        "(.+)"
							},
							{
								"source_labels": [
									"__address__",
									"__meta_kubernetes_service_annotation_prometheus_io_port",
								]
								"action":       "replace"
								"target_label": "__address__"
								"regex":        "([^:]+)(?::\\d+)?;(\\d+)"
								"replacement":  "$1:$2"
							},
							{
								"action": "labelmap"
								"regex":  "__meta_kubernetes_service_label_(.+)"
							},
							{
								"source_labels": [
									"__meta_kubernetes_pod_name",
								]
								"target_label": "pod"
							},
							{
								"source_labels": [
									"__meta_kubernetes_pod_container_name",
								]
								"target_label": "container"
							},
							{
								"source_labels": [
									"__meta_kubernetes_namespace",
								]
								"target_label": "namespace"
							},
							{
								"source_labels": [
									"__meta_kubernetes_service_name",
								]
								"target_label": "service"
							},
							{
								"source_labels": [
									"__meta_kubernetes_service_name",
								]
								"target_label": "job"
								"replacement":  "${1}"
							},
							{
								"source_labels": [
									"__meta_kubernetes_pod_node_name",
								]
								"action":       "replace"
								"target_label": "node"
							},
						]
					},
					{
						"job_name":     "kubernetes-services"
						"metrics_path": "/probe"
						"params": {
							"module": [
								"http_2xx",
							]
						}
						"kubernetes_sd_configs": [
							{
								"role": "service"
							},
						]
						"relabel_configs": [
							{
								"source_labels": [
									"__meta_kubernetes_service_annotation_prometheus_io_probe",
								]
								"action": "keep"
								"regex":  true
							},
							{
								"source_labels": [
									"__address__",
								]
								"target_label": "__param_target"
							},
							{
								"target_label": "__address__"
								"replacement":  "blackbox"
							},
							{
								"source_labels": [
									"__param_target",
								]
								"target_label": "instance"
							},
							{
								"action": "labelmap"
								"regex":  "__meta_kubernetes_service_label_(.+)"
							},
							{
								"source_labels": [
									"__meta_kubernetes_namespace",
								]
								"target_label": "namespace"
							},
							{
								"source_labels": [
									"__meta_kubernetes_service_name",
								]
								"target_label": "service"
							},
						]
					},
					{
						"job_name": "kubernetes-pods"
						"kubernetes_sd_configs": [
							{
								"role": "pod"
							},
						]
						"relabel_configs": [
							{
								"action": "drop"
								"source_labels": [
									"__meta_kubernetes_pod_container_init",
								]
								"regex": true
							},
							{
								"action": "keep_if_equal"
								"source_labels": [
									"__meta_kubernetes_pod_annotation_prometheus_io_port",
									"__meta_kubernetes_pod_container_port_number",
								]
							},
							{
								"source_labels": [
									"__meta_kubernetes_pod_annotation_prometheus_io_scrape",
								]
								"action": "keep"
								"regex":  true
							},
							{
								"source_labels": [
									"__meta_kubernetes_pod_annotation_prometheus_io_path",
								]
								"action":       "replace"
								"target_label": "__metrics_path__"
								"regex":        "(.+)"
							},
							{
								"source_labels": [
									"__address__",
									"__meta_kubernetes_pod_annotation_prometheus_io_port",
								]
								"action":       "replace"
								"regex":        "([^:]+)(?::\\d+)?;(\\d+)"
								"replacement":  "$1:$2"
								"target_label": "__address__"
							},
							{
								"action": "labelmap"
								"regex":  "__meta_kubernetes_pod_label_(.+)"
							},
							{
								"source_labels": [
									"__meta_kubernetes_pod_name",
								]
								"target_label": "pod"
							},
							{
								"source_labels": [
									"__meta_kubernetes_pod_container_name",
								]
								"target_label": "container"
							},
							{
								"source_labels": [
									"__meta_kubernetes_namespace",
								]
								"target_label": "namespace"
							},
							{
								"source_labels": [
									"__meta_kubernetes_pod_node_name",
								]
								"action":       "replace"
								"target_label": "node"
							},
						]
					},
				]
			}
		}
	}
}
