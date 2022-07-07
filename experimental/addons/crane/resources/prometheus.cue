output: {
	type: "helm"
	properties: {
		if parameter.mirror {
			url: "https://finops-helm.pkg.coding.net/gocrane/prometheus-community"
		}
		if !parameter.mirror {
			url: "https://prometheus-community.github.io/helm-charts"
		}
		repoType:        "helm"
		chart:           "prometheus"
		version:         "15.8.5"
		targetNamespace: "crane-system"
		releaseName:     "prometheus"
		values: {
			//# Prometheus server ConfigMap entries
			//#
			pushgateway: enabled:  false
			alertmanager: enabled: false

			serverFiles: {
				//# Records configuration
				//# Ref: https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/
				"recording_rules.yml": {
					groups: [{
						name:     "costs.rules"
						interval: "3600s"
						rules: [{
							expr: """
					sum(label_replace(irate(container_cpu_usage_seconds_total{container!=\"POD\", container!=\"\",image!=\"\"}[1h]), \"node\", \"$1\", \"instance\",  \"(.*)\")) by (container, pod, node, namespace) * on (node) group_left() avg(avg_over_time(node_cpu_hourly_cost[1h])) by (node)

					"""

							record: "namespace:container_cpu_usage_costs_hourly:sum_rate"
						}, {
							expr: """
					sum(label_replace(avg_over_time(container_memory_working_set_bytes{container!=\"POD\",container!=\"\",image!=\"\"}[1h]), \"node\", \"$1\", \"instance\",  \"(.*)\")) by (container, pod, node, namespace) / 1024.0 / 1024.0 / 1024.0 * on (node) group_left() avg(avg_over_time(node_ram_hourly_cost[1h])) by (node)

					"""

							record: "namespace:container_memory_usage_costs_hourly:sum_rate"
						}, {
							expr: """
					avg(avg_over_time(node_cpu_hourly_cost[1h])) by (node)

					"""

							record: "node:node_cpu_hourly_cost:avg"
						}, {
							expr: """
					avg(avg_over_time(node_ram_hourly_cost[1h])) by (node)

					"""

							record: "node:node_ram_hourly_cost:avg"
						}, {
							expr: """
					avg(avg_over_time(node_total_hourly_cost[1h])) by (node)

					"""

							record: "node:node_total_hourly_cost:avg"
						}]
					}, {
						name:     "scheduler.rules.30s"
						interval: "30s"
						rules: [{
							record: "cpu_usage_active"
							expr:   "100 - (avg by (instance) (irate(node_cpu_seconds_total{mode=\"idle\"}[90s])) * 100)"
						}, {
							record: "mem_usage_active"
							expr:   "100*(1-node_memory_MemAvailable_bytes/node_memory_MemTotal_bytes)"
						}]
					}, {
						name:     "scheduler.rules.1m"
						interval: "1m"
						rules: [{
							record: "cpu_usage_avg_5m"
							expr:   "avg_over_time(cpu_usage_active[5m])"
						}, {
							record: "mem_usage_avg_5m"
							expr:   "avg_over_time(mem_usage_active[5m])"
						}]
					}, {
						name:     "scheduler.rules.5m"
						interval: "5m"
						rules: [{
							record: "cpu_usage_max_avg_1h"
							expr:   "max_over_time(cpu_usage_avg_5m[1h])"
						}, {
							record: "cpu_usage_max_avg_1d"
							expr:   "max_over_time(cpu_usage_avg_5m[1d])"
						}, {
							record: "mem_usage_max_avg_1h"
							expr:   "max_over_time(mem_usage_avg_5m[1h])"
						}, {
							record: "mem_usage_max_avg_1d"
							expr:   "max_over_time(mem_usage_avg_5m[1d])"
						}]
					}]
				}
			}

			// adds additional scrape configs to prometheus.yml
			// must be a string so you have to add a | after extraScrapeConfigs:
			// example adds prometheus-blackbox-exporter scrape config
			extraScrapeConfigs: """
				# this is used to scrape fadvisor
				- job_name: \"fadvisor\"
				  honor_timestamps: true
				  scheme: http
				  metrics_path: /metrics
				  static_configs:
				    - targets: ['fadvisor.crane-system.svc.cluster.local:8081']
				- job_name: crane
				  kubernetes_sd_configs:
				  - role: pod
				  relabel_configs:
				  - action: keep
				    regex: crane-system;craned-(.+)
				    source_labels:
				    - __meta_kubernetes_namespace
				    - __meta_kubernetes_pod_name
				  - source_labels:
				    - __address__
				    regex: (.*)
				    replacement: \"${1}:8080\"
				    target_label: __address__
				"""

			server: {
				persistentVolume: enabled: false
				service: {
					annotations: {}
					labels: {}
					clusterIP: ""

					//# List of IP addresses at which the Prometheus server service is available
					//# Ref: https://kubernetes.io/docs/user-guide/services/#external-ips
					//#
					externalIPs: []

					loadBalancerIP: ""
					loadBalancerSourceRanges: []
					servicePort:     8080
					sessionAffinity: "None"
					type:            "ClusterIP"
				}
			}

			nodeExporter: hostRootfs: false

			kubeStateMetrics: {
				//# If false, kube-state-metrics sub-chart will not be installed
				//#
				enabled: true
			}

			//# kube-state-metrics sub-chart configurable values
			//# Please see https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-state-metrics
			//#
			"kube-state-metrics": {
				prometheus: monitor: honorLabels: true
				image: {
					repository: "ccr.ccs.tencentyun.com/tkeimages/kube-state-metrics"
					pullPolicy: "IfNotPresent"
					tag:        "2.2.4"
				}
			}

		}
	}
}
