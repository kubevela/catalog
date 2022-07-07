output: {
	type: "helm"
	properties: {
		if parameter.mirror {
			url: "https://finops-helm.pkg.coding.net/gocrane/grafana"
		}
		if !parameter.mirror {
			url: "https://grafana.github.io/helm-charts"
		}
		repoType:        "helm"
		chart:           "grafana"
		version:         "6.29.6"
		targetNamespace: "crane-system"
		releaseName:     "grafana"
		values: {
			service: {
				enabled:    true
				type:       "ClusterIP"
				port:       8082
				targetPort: 3000
				// targetPort: 4181 To be used with a proxy extraContainer
				annotations: {}
				labels: {}
				portName: "service"
			}

			// Administrator credentials when not using an existing secret (see below)
			adminUser:     "admin"
			adminPassword: "admin"

			//# Configure grafana datasources
			//# ref: http://docs.grafana.org/administration/provisioning/#datasources
			//#
			datasources: {
				"datasources.yaml": {
					apiVersion: 1
					datasources: [{
						name:      "Prometheus"
						type:      "prometheus"
						url:       "http://prometheus-server.crane-system.svc.cluster.local:8080"
						access:    "proxy"
						isDefault: true
					}]
				}
			}

			dashboardProviders: "dashboardproviders.yaml": {
				apiVersion: 1
				providers: [{
					name:            "default"
					orgId:           1
					folder:          ""
					type:            "file"
					disableDeletion: false
					editable:        true
					options: path: "/var/lib/grafana/dashboards/default"
				}]
			}

			dashboards: default: {
				"cluster-costs": json: """
					{
					  \"annotations\": {
					    \"list\": [
					      {
					        \"builtIn\": 1,
					        \"datasource\": \"-- Grafana --\",
					        \"enable\": true,
					        \"hide\": true,
					        \"iconColor\": \"rgba(0, 211, 255, 1)\",
					        \"name\": \"Annotations & Alerts\",
					        \"target\": {
					          \"limit\": 100,
					          \"matchAny\": false,
					          \"tags\": [],
					          \"type\": \"dashboard\"
					        },
					        \"type\": \"dashboard\"
					      }
					    ]
					  },
					  \"description\": \"A dashboard to help manage Kubernetes cluster costs and resources\",
					  \"editable\": true,
					  \"fiscalYearStartMonth\": 0,
					  \"gnetId\": 6873,
					  \"graphTooltip\": 0,
					  \"iteration\": 1641381016806,
					  \"links\": [],
					  \"liveNow\": false,
					  \"panels\": [
					    {
					      \"description\": \"Monthly estimated costs according to latest 1 hour resource usage, Note, if you use virtual kubelet or EKS Pod, we do not compute the virtual node costs.\",
					      \"fieldConfig\": {
					        \"defaults\": {
					          \"color\": {
					            \"mode\": \"continuous-GrYlRd\"
					          },
					          \"mappings\": [],
					          \"thresholds\": {
					            \"mode\": \"absolute\",
					            \"steps\": [
					              {
					                \"color\": \"green\",
					                \"value\": null
					              },
					              {
					                \"color\": \"red\",
					                \"value\": 80
					              }
					            ]
					          },
					          \"unit\": \"currencyJPY\"
					        },
					        \"overrides\": [
					          {
					            \"matcher\": {
					              \"id\": \"byName\",
					              \"options\": \"Value #Nodes-Monthly-Estimated-Costs\"
					            },
					            \"properties\": [
					              {
					                \"id\": \"displayName\",
					                \"value\": \"Nodes-Monthly-Estimated-Costs\"
					              }
					            ]
					          },
					          {
					            \"matcher\": {
					              \"id\": \"byName\",
					              \"options\": \"Value #Total-Requests-Monthly-Estimated-Costs\"
					            },
					            \"properties\": [
					              {
					                \"id\": \"displayName\",
					                \"value\": \"Total-Requests-Monthly-Estimated-Costs\"
					              }
					            ]
					          },
					          {
					            \"matcher\": {
					              \"id\": \"byName\",
					              \"options\": \"Value #Total-Usage-Monthly-Estimated-Costs\"
					            },
					            \"properties\": [
					              {
					                \"id\": \"displayName\",
					                \"value\": \"Total-Usage-Monthly-Estimated-Costs\"
					              }
					            ]
					          },
					          {
					            \"matcher\": {
					              \"id\": \"byName\",
					              \"options\": \"Value #Cpu-Requests-Monthly-Estimated-Costs\"
					            },
					            \"properties\": [
					              {
					                \"id\": \"displayName\",
					                \"value\": \"Cpu-Requests-Monthly-Estimated-Costs\"
					              }
					            ]
					          },
					          {
					            \"matcher\": {
					              \"id\": \"byName\",
					              \"options\": \"Value #Ram-Requests-Monthly-Estimated-Costs\"
					            },
					            \"properties\": [
					              {
					                \"id\": \"displayName\",
					                \"value\": \"Ram-Requests-Monthly-Estimated-Costs\"
					              }
					            ]
					          },
					          {
					            \"matcher\": {
					              \"id\": \"byName\",
					              \"options\": \"Value #Cpu-Usage-Monthly-Estimated-Costs\"
					            },
					            \"properties\": [
					              {
					                \"id\": \"displayName\",
					                \"value\": \"Cpu-Usage-Monthly-Estimated-Costs\"
					              }
					            ]
					          },
					          {
					            \"matcher\": {
					              \"id\": \"byName\",
					              \"options\": \"Value #Ram-Usage-Monthly-Estimated-Costs\"
					            },
					            \"properties\": [
					              {
					                \"id\": \"displayName\",
					                \"value\": \"Ram-Usage-Monthly-Estimated-Costs\"
					              }
					            ]
					          }
					        ]
					      },
					      \"gridPos\": {
					        \"h\": 7,
					        \"w\": 24,
					        \"x\": 0,
					        \"y\": 0
					      },
					      \"id\": 136,
					      \"options\": {
					        \"displayMode\": \"basic\",
					        \"orientation\": \"horizontal\",
					        \"reduceOptions\": {
					          \"calcs\": [
					            \"lastNotNull\"
					          ],
					          \"fields\": \"\",
					          \"values\": false
					        },
					        \"showUnfilled\": true
					      },
					      \"pluginVersion\": \"8.3.3\",
					      \"targets\": [
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"sum (\\n    avg(\\n        avg_over_time(node_total_hourly_cost[1h])\\n        * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!~\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}) by (node)\\n    )\\n     \\nby (node)) * 730 * ($Discount/100.0)\",
					          \"format\": \"table\",
					          \"hide\": false,
					          \"interval\": \"\",
					          \"legendFormat\": \"\",
					          \"refId\": \"Nodes-Monthly-Estimated-Costs\"
					        },
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"sum(\\n  sum(\\n    sum(kube_pod_container_resource_requests{resource=\\\"cpu\\\", unit=\\\"core\\\"}) by (container, pod, node, namespace) \\n    * on (node) group_left() \\n    avg(\\n      avg_over_time(node_cpu_hourly_cost[1h]) * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!~\\\"eklet\\\",label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}) by (node) \\n    ) by (node)\\n    \\n)\\n\\n+\\n\\nsum(\\n  sum(kube_pod_container_resource_requests{resource=\\\"memory\\\", unit=\\\"byte\\\", namespace!=\\\"\\\"} / 1024./ 1024. / 1024.) by (container, pod, node, namespace) \\n  * on (node) group_left() \\n  avg(\\n    avg_over_time(node_ram_hourly_cost[1h]) * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!~\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}) by (node)\\n  ) by (node) \\n  \\n)\\n) * 730 * ($Discount/100.0)\",
					          \"format\": \"table\",
					          \"hide\": false,
					          \"instant\": true,
					          \"interval\": \"\",
					          \"legendFormat\": \"\",
					          \"refId\": \"Total-Requests-Monthly-Estimated-Costs\"
					        },
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"sum (\\n  sum(label_replace(irate(container_cpu_usage_seconds_total{container!=\\\"POD\\\", container!=\\\"\\\",image!=\\\"\\\"}[1h]), \\\"node\\\", \\\"$1\\\", \\\"instance\\\",  \\\"(.*)\\\")) by (container, pod, node, namespace) \\n  * on (node) group_left()\\n  avg(\\n    avg_over_time(node_cpu_hourly_cost[1h]) * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!~\\\"eklet\\\",label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}\\n    ) by (node) \\n  ) by (node)\\n\\n+\\n\\n  sum(label_replace(avg_over_time(container_memory_working_set_bytes{container!=\\\"POD\\\",container!=\\\"\\\",image!=\\\"\\\"}[1h]), \\\"node\\\", \\\"$1\\\", \\\"instance\\\",  \\\"(.*)\\\")) by (container, pod, node, namespace) / 1024.0 / 1024.0 / 1024.0 \\n  * on (node) group_left()\\n  avg(\\n    avg_over_time(node_ram_hourly_cost[1h]) * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!~\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}\\n    ) by (node)\\n  ) by (node) \\n) * 730 * ($Discount/100.)\",
					          \"format\": \"table\",
					          \"instant\": true,
					          \"interval\": \"\",
					          \"legendFormat\": \"\",
					          \"refId\": \"Total-Usage-Monthly-Estimated-Costs\"
					        },
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"sum(\\n  sum(kube_pod_container_resource_requests{resource=\\\"cpu\\\", unit=\\\"core\\\"}) by (container, pod, node, namespace) \\n  * on (node) group_left()\\n  avg(\\n      avg_over_time(node_cpu_hourly_cost[1h]) * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!~\\\"eklet\\\",label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}\\n      ) by (node)\\n  ) by (node)\\n) * 730 * ($Discount/100.)\",
					          \"format\": \"table\",
					          \"hide\": false,
					          \"instant\": true,
					          \"interval\": \"\",
					          \"legendFormat\": \"\",
					          \"refId\": \"Cpu-Requests-Monthly-Estimated-Costs\"
					        },
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"sum(\\n  sum(kube_pod_container_resource_requests{resource=\\\"memory\\\", unit=\\\"byte\\\", namespace!=\\\"\\\"} / 1024./ 1024. / 1024.) by (container, pod, node, namespace) * on (node) group_left()\\n  avg(\\n    avg_over_time(node_ram_hourly_cost[1h]) * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!~\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}\\n    ) by (node)\\n  ) by (node) \\n) * 730 * ($Discount/100.)\",
					          \"format\": \"table\",
					          \"hide\": false,
					          \"instant\": true,
					          \"interval\": \"\",
					          \"legendFormat\": \"\",
					          \"refId\": \"Ram-Requests-Monthly-Estimated-Costs\"
					        },
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"sum(\\n  sum(label_replace(irate(container_cpu_usage_seconds_total{container!=\\\"POD\\\", container!=\\\"\\\",image!=\\\"\\\"}[1h]), \\\"node\\\", \\\"$1\\\", \\\"instance\\\",  \\\"(.*)\\\")) by (container, pod, node, namespace) * on (node) group_left()\\n  avg(\\n    avg_over_time(node_cpu_hourly_cost[1h]) * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!~\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}\\n    ) by (node)\\n  ) by (node) \\n) * 730 * ($Discount/100.)\",
					          \"format\": \"table\",
					          \"hide\": false,
					          \"instant\": true,
					          \"interval\": \"\",
					          \"legendFormat\": \"\",
					          \"refId\": \"Cpu-Usage-Monthly-Estimated-Costs\"
					        },
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"sum(\\n  sum(label_replace(avg_over_time(container_memory_working_set_bytes{container!=\\\"POD\\\",container!=\\\"\\\",image!=\\\"\\\"}[1h]), \\\"node\\\", \\\"$1\\\", \\\"instance\\\",  \\\"(.*)\\\")) by (container, pod, node, namespace) / 1024.0 / 1024.0 / 1024.0 * on (node) group_left()\\n    avg(\\n    avg_over_time(node_ram_hourly_cost[1h]) * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!~\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}\\n    ) by (node)\\n  ) by (node) \\n) * 730 * ($Discount/100.)\",
					          \"format\": \"table\",
					          \"hide\": false,
					          \"instant\": true,
					          \"interval\": \"\",
					          \"legendFormat\": \"\",
					          \"refId\": \"Ram-Usage-Monthly-Estimated-Costs\"
					        }
					      ],
					      \"title\": \"Estimated Monthly Cluster Resource Costs\",
					      \"type\": \"bargauge\"
					    },
					    {
					      \"description\": \"This table shows the comparison of application CPU usage vs the capacity of the node (measured over last 60 minutes)\",
					      \"fieldConfig\": {
					        \"defaults\": {
					          \"color\": {
					            \"mode\": \"thresholds\"
					          },
					          \"custom\": {
					            \"align\": \"auto\",
					            \"displayMode\": \"auto\",
					            \"filterable\": false
					          },
					          \"mappings\": [
					            {
					              \"options\": {
					                \"C\": {
					                  \"text\": \"\"
					                }
					              },
					              \"type\": \"value\"
					            }
					          ],
					          \"thresholds\": {
					            \"mode\": \"absolute\",
					            \"steps\": [
					              {
					                \"color\": \"green\",
					                \"value\": null
					              },
					              {
					                \"color\": \"red\",
					                \"value\": 80
					              }
					            ]
					          }
					        },
					        \"overrides\": [
					          {
					            \"matcher\": {
					              \"id\": \"byName\",
					              \"options\": \"node\"
					            },
					            \"properties\": [
					              {
					                \"id\": \"displayName\",
					                \"value\": \"Node\"
					              }
					            ]
					          },
					          {
					            \"matcher\": {
					              \"id\": \"byName\",
					              \"options\": \"Value #cpu-requests-alloc-util\"
					            },
					            \"properties\": [
					              {
					                \"id\": \"displayName\",
					                \"value\": \"CPU-Requests-Alloc-Utilization\"
					              },
					              {
					                \"id\": \"unit\",
					                \"value\": \"percent\"
					              }
					            ]
					          },
					          {
					            \"matcher\": {
					              \"id\": \"byName\",
					              \"options\": \"Value #cpu-usage-util\"
					            },
					            \"properties\": [
					              {
					                \"id\": \"displayName\",
					                \"value\": \"CPU-Usage-Utlization\"
					              },
					              {
					                \"id\": \"unit\",
					                \"value\": \"percent\"
					              }
					            ]
					          },
					          {
					            \"matcher\": {
					              \"id\": \"byName\",
					              \"options\": \"Value #cpu-hourly-costs\"
					            },
					            \"properties\": [
					              {
					                \"id\": \"unit\",
					                \"value\": \"currencyJPY\"
					              },
					              {
					                \"id\": \"displayName\",
					                \"value\": \"Cpu-Hourly-Cost\"
					              }
					            ]
					          },
					          {
					            \"matcher\": {
					              \"id\": \"byName\",
					              \"options\": \"Value #cpu-usage-hourly-cost\"
					            },
					            \"properties\": [
					              {
					                \"id\": \"unit\",
					                \"value\": \"currencyJPY\"
					              },
					              {
					                \"id\": \"displayName\",
					                \"value\": \"Cpu-Usage-Hourly-Cost\"
					              }
					            ]
					          },
					          {
					            \"matcher\": {
					              \"id\": \"byName\",
					              \"options\": \"Value #ram-requests-alloc-util\"
					            },
					            \"properties\": [
					              {
					                \"id\": \"displayName\",
					                \"value\": \"RAM-Requests-Alloc-Utilization\"
					              },
					              {
					                \"id\": \"unit\",
					                \"value\": \"percent\"
					              }
					            ]
					          },
					          {
					            \"matcher\": {
					              \"id\": \"byName\",
					              \"options\": \"Value #ram-usage-util\"
					            },
					            \"properties\": [
					              {
					                \"id\": \"displayName\",
					                \"value\": \"Ram-Usage-Utilization\"
					              },
					              {
					                \"id\": \"unit\",
					                \"value\": \"percent\"
					              }
					            ]
					          },
					          {
					            \"matcher\": {
					              \"id\": \"byName\",
					              \"options\": \"Value #ram-houly-cost\"
					            },
					            \"properties\": [
					              {
					                \"id\": \"displayName\",
					                \"value\": \"Ram-Hourly-Cost\"
					              },
					              {
					                \"id\": \"unit\",
					                \"value\": \"currencyJPY\"
					              }
					            ]
					          },
					          {
					            \"matcher\": {
					              \"id\": \"byName\",
					              \"options\": \"Value #ram-usage-hourly-cost\"
					            },
					            \"properties\": [
					              {
					                \"id\": \"displayName\",
					                \"value\": \"Ram-Usage-Hourly-Cost\"
					              },
					              {
					                \"id\": \"unit\",
					                \"value\": \"currencyJPY\"
					              }
					            ]
					          },
					          {
					            \"matcher\": {
					              \"id\": \"byName\",
					              \"options\": \"Value #Node-Hourly-Total-Cost\"
					            },
					            \"properties\": [
					              {
					                \"id\": \"unit\",
					                \"value\": \"currencyJPY\"
					              },
					              {
					                \"id\": \"displayName\",
					                \"value\": \"Node-Hourly-Total-Cost\"
					              }
					            ]
					          }
					        ]
					      },
					      \"gridPos\": {
					        \"h\": 6,
					        \"w\": 24,
					        \"x\": 0,
					        \"y\": 7
					      },
					      \"hideTimeOverride\": true,
					      \"id\": 90,
					      \"links\": [],
					      \"options\": {
					        \"footer\": {
					          \"fields\": \"\",
					          \"reducer\": [
					            \"sum\"
					          ],
					          \"show\": false
					        },
					        \"showHeader\": true,
					        \"sortBy\": [
					          {
					            \"desc\": true,
					            \"displayName\": \"RAM-Requests-Alloc-Utilization\"
					          }
					        ]
					      },
					      \"pluginVersion\": \"8.3.3\",
					      \"repeatDirection\": \"v\",
					      \"targets\": [
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"sum(\\n  kube_pod_container_resource_requests{resource=\\\"cpu\\\", unit=\\\"core\\\"} \\n  * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!~\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}) by (node)\\n) by (node) \\n\\n/\\n\\nsum(\\n  kube_node_status_capacity{resource=\\\"cpu\\\", unit=\\\"core\\\"} \\n  * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!~\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}) by (node)\\n) by (node) \\n\\n* 100\",
					          \"format\": \"table\",
					          \"instant\": true,
					          \"interval\": \"\",
					          \"intervalFactor\": 1,
					          \"legendFormat\": \"\",
					          \"refId\": \"cpu-requests-alloc-util\"
					        },
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"sum(\\n  label_replace(irate(container_cpu_usage_seconds_total{container!=\\\"POD\\\", container!=\\\"\\\",image!=\\\"\\\"}[1h]), \\\"node\\\", \\\"$1\\\", \\\"instance\\\",  \\\"(.*)\\\") \\n  * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!~\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}) by (node)\\n) by (node)\\n/\\nsum(\\n  kube_node_status_capacity{resource=\\\"cpu\\\", unit=\\\"core\\\"} \\n  * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!~\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}) by (node) \\n) by (node) \\n\\n* 100\",
					          \"format\": \"table\",
					          \"hide\": false,
					          \"instant\": true,
					          \"interval\": \"\",
					          \"intervalFactor\": 1,
					          \"legendFormat\": \"\",
					          \"refId\": \"cpu-usage-util\"
					        },
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"avg(\\n  avg_over_time(node_cpu_hourly_cost[1h]) \\n  * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!~\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}) by (node)\\n) by (node)  * ($Discount/100.)\",
					          \"format\": \"table\",
					          \"hide\": false,
					          \"instant\": true,
					          \"interval\": \"1h\",
					          \"legendFormat\": \"\",
					          \"refId\": \"cpu-hourly-costs\"
					        },
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"sum(\\n\\n  sum(\\n    label_replace(irate(container_cpu_usage_seconds_total{container!=\\\"POD\\\", container!=\\\"\\\",image!=\\\"\\\"}[1h]), \\\"node\\\", \\\"$1\\\", \\\"instance\\\",  \\\"(.*)\\\")  \\n     * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!~\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}) by (node) \\n  ) by (container, pod, node, namespace) \\n\\n  * on (node) group_left() \\n \\n  avg(\\n    avg_over_time(node_cpu_hourly_cost[1h])  \\n    * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!~\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}) by (node) \\n  ) by (node) \\n\\n) by (node)  * ($Discount/100.)\",
					          \"format\": \"table\",
					          \"hide\": false,
					          \"instant\": true,
					          \"interval\": \"1h\",
					          \"legendFormat\": \"\",
					          \"refId\": \"cpu-usage-hourly-cost\"
					        },
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"sum(\\n  kube_pod_container_resource_requests{resource=\\\"memory\\\", unit=\\\"byte\\\", namespace!=\\\"\\\"}  \\n  * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!~\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}) by (node) \\n) by (node) * 100\\n\\n/ \\n\\nsum(\\n  kube_node_status_capacity{resource=\\\"memory\\\", unit=\\\"byte\\\"}  \\n  * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!~\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}) by (node)\\n) by (node)\",
					          \"format\": \"table\",
					          \"hide\": false,
					          \"instant\": true,
					          \"interval\": \"1h\",
					          \"legendFormat\": \"\",
					          \"refId\": \"ram-requests-alloc-util\"
					        },
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"sum(\\n  label_replace(container_memory_usage_bytes{namespace!=\\\"\\\",container!=\\\"POD\\\", container!=\\\"\\\",image!=\\\"\\\"}, \\\"node\\\", \\\"$1\\\", \\\"instance\\\",\\\"(.+)\\\")  \\n  * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!~\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}) by (node)\\n) by (node) * 100\\n\\n/\\nsum(\\n  kube_node_status_capacity{resource=\\\"memory\\\", unit=\\\"byte\\\"} \\n  * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!~\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}) by (node)\\n) by (node)\",
					          \"format\": \"table\",
					          \"hide\": false,
					          \"instant\": true,
					          \"interval\": \"1h\",
					          \"legendFormat\": \"\",
					          \"refId\": \"ram-usage-util\"
					        },
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"avg(\\n  avg_over_time(node_ram_hourly_cost[1h])) by (node) \\n  * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!~\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}\\n) by (node)  * ($Discount/100.)\",
					          \"format\": \"table\",
					          \"hide\": false,
					          \"instant\": true,
					          \"interval\": \"1h\",
					          \"legendFormat\": \"\",
					          \"refId\": \"ram-houly-cost\"
					        },
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"sum(\\n\\n  sum(\\n    label_replace(avg_over_time(container_memory_working_set_bytes{container!=\\\"POD\\\",container!=\\\"\\\",image!=\\\"\\\"}[1h]), \\\"node\\\", \\\"$1\\\", \\\"instance\\\",  \\\"(.*)\\\") \\n    * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!~\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}) by (node)\\n  ) by (container, pod, node, namespace) / 1024.0 / 1024.0 / 1024.0 \\n\\n  * on (node) group_left()\\n\\n  avg(\\n    avg_over_time(node_ram_hourly_cost[1h]) \\n    * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!~\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}) by (node) \\n  ) by (node)\\n  \\n) by (node)  * ($Discount/100.)\\n\",
					          \"format\": \"table\",
					          \"hide\": false,
					          \"instant\": true,
					          \"interval\": \"1h\",
					          \"legendFormat\": \"\",
					          \"refId\": \"ram-usage-hourly-cost\"
					        },
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"avg(\\n  avg_over_time(node_total_hourly_cost[1h])\\n  * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!~\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}) by (node) \\n) by (node) * ($Discount/100.)\",
					          \"format\": \"table\",
					          \"hide\": false,
					          \"instant\": true,
					          \"interval\": \"1h\",
					          \"legendFormat\": \"\",
					          \"refId\": \"Node-Hourly-Total-Cost\"
					        }
					      ],
					      \"title\": \"resource cost & utilization by node\",
					      \"transformations\": [
					        {
					          \"id\": \"merge\",
					          \"options\": {
					            \"reducers\": []
					          }
					        },
					        {
					          \"id\": \"organize\",
					          \"options\": {
					            \"excludeByName\": {
					              \"Time\": true
					            },
					            \"indexByName\": {},
					            \"renameByName\": {}
					          }
					        }
					      ],
					      \"type\": \"table\"
					    },
					    {
					      \"collapsed\": false,
					      \"gridPos\": {
					        \"h\": 1,
					        \"w\": 24,
					        \"x\": 0,
					        \"y\": 13
					      },
					      \"id\": 133,
					      \"panels\": [],
					      \"title\": \"Clutser Utilization\",
					      \"type\": \"row\"
					    },
					    {
					      \"description\": \"Current CPU utilization from applications usage vs allocatable CPU\",
					      \"fieldConfig\": {
					        \"defaults\": {
					          \"color\": {
					            \"mode\": \"thresholds\"
					          },
					          \"decimals\": 2,
					          \"mappings\": [
					            {
					              \"options\": {
					                \"match\": \"null\",
					                \"result\": {
					                  \"text\": \"N/A\"
					                }
					              },
					              \"type\": \"special\"
					            }
					          ],
					          \"max\": 100,
					          \"min\": 0,
					          \"thresholds\": {
					            \"mode\": \"absolute\",
					            \"steps\": [
					              {
					                \"color\": \"rgba(245, 54, 54, 0.9)\",
					                \"value\": null
					              },
					              {
					                \"color\": \"rgba(50, 172, 45, 0.97)\",
					                \"value\": 30
					              },
					              {
					                \"color\": \"#c15c17\",
					                \"value\": 80
					              }
					            ]
					          },
					          \"unit\": \"percent\"
					        },
					        \"overrides\": []
					      },
					      \"gridPos\": {
					        \"h\": 4,
					        \"w\": 6,
					        \"x\": 0,
					        \"y\": 14
					      },
					      \"id\": 91,
					      \"links\": [],
					      \"maxDataPoints\": 100,
					      \"options\": {
					        \"orientation\": \"horizontal\",
					        \"reduceOptions\": {
					          \"calcs\": [
					            \"lastNotNull\"
					          ],
					          \"fields\": \"\",
					          \"values\": false
					        },
					        \"showThresholdLabels\": false,
					        \"showThresholdMarkers\": true
					      },
					      \"pluginVersion\": \"8.3.3\",
					      \"targets\": [
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"sum(label_replace(irate(container_cpu_usage_seconds_total{container!=\\\"POD\\\",container!=\\\"\\\",image!=\\\"\\\"}[1h]), \\\"node\\\", \\\"$1\\\", \\\"instance\\\",  \\\"(.*)\\\")  * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!=\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}) by (node))\\n\\n/\\n\\nsum(kube_node_status_allocatable{resource=\\\"cpu\\\", unit=\\\"core\\\"} * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!=\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}) by (node)) \\n\\n* 100\",
					          \"hide\": false,
					          \"interval\": \"\",
					          \"legendFormat\": \"\",
					          \"refId\": \"B\"
					        }
					      ],
					      \"title\": \"CPU Utilization\",
					      \"type\": \"gauge\"
					    },
					    {
					      \"description\": \"Current CPU reservation requests from applications vs allocatable CPU\",
					      \"fieldConfig\": {
					        \"defaults\": {
					          \"color\": {
					            \"mode\": \"thresholds\"
					          },
					          \"decimals\": 2,
					          \"mappings\": [
					            {
					              \"options\": {
					                \"match\": \"null\",
					                \"result\": {
					                  \"text\": \"N/A\"
					                }
					              },
					              \"type\": \"special\"
					            }
					          ],
					          \"max\": 100,
					          \"min\": 0,
					          \"thresholds\": {
					            \"mode\": \"absolute\",
					            \"steps\": [
					              {
					                \"color\": \"rgba(245, 54, 54, 0.9)\",
					                \"value\": null
					              },
					              {
					                \"color\": \"rgba(50, 172, 45, 0.97)\",
					                \"value\": 30
					              },
					              {
					                \"color\": \"#c15c17\",
					                \"value\": 80
					              }
					            ]
					          },
					          \"unit\": \"percent\"
					        },
					        \"overrides\": []
					      },
					      \"gridPos\": {
					        \"h\": 4,
					        \"w\": 6,
					        \"x\": 6,
					        \"y\": 14
					      },
					      \"id\": 134,
					      \"links\": [],
					      \"maxDataPoints\": 100,
					      \"options\": {
					        \"orientation\": \"horizontal\",
					        \"reduceOptions\": {
					          \"calcs\": [
					            \"lastNotNull\"
					          ],
					          \"fields\": \"\",
					          \"values\": false
					        },
					        \"showThresholdLabels\": false,
					        \"showThresholdMarkers\": true
					      },
					      \"pluginVersion\": \"8.3.3\",
					      \"targets\": [
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"sum(kube_pod_container_resource_requests{resource=\\\"cpu\\\", unit=\\\"core\\\"} * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!=\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}) by (node) ) \\n/ \\nsum(kube_node_status_allocatable{resource=\\\"cpu\\\", unit=\\\"core\\\"} * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!=\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}) by (node) )\\n* 100\",
					          \"format\": \"time_series\",
					          \"interval\": \"\",
					          \"intervalFactor\": 1,
					          \"legendFormat\": \"\",
					          \"refId\": \"A\",
					          \"step\": 10
					        }
					      ],
					      \"title\": \"CPU Requests\",
					      \"type\": \"gauge\"
					    },
					    {
					      \"description\": \"Current RAM use vs RAM available\",
					      \"fieldConfig\": {
					        \"defaults\": {
					          \"color\": {
					            \"mode\": \"thresholds\"
					          },
					          \"mappings\": [
					            {
					              \"options\": {
					                \"match\": \"null\",
					                \"result\": {
					                  \"text\": \"N/A\"
					                }
					              },
					              \"type\": \"special\"
					            }
					          ],
					          \"max\": 100,
					          \"min\": 0,
					          \"thresholds\": {
					            \"mode\": \"absolute\",
					            \"steps\": [
					              {
					                \"color\": \"rgba(245, 54, 54, 0.9)\",
					                \"value\": null
					              },
					              {
					                \"color\": \"rgba(50, 172, 45, 0.97)\",
					                \"value\": 30
					              },
					              {
					                \"color\": \"#c15c17\",
					                \"value\": 80
					              }
					            ]
					          },
					          \"unit\": \"percent\"
					        },
					        \"overrides\": []
					      },
					      \"gridPos\": {
					        \"h\": 4,
					        \"w\": 6,
					        \"x\": 12,
					        \"y\": 14
					      },
					      \"hideTimeOverride\": true,
					      \"id\": 80,
					      \"links\": [],
					      \"maxDataPoints\": 100,
					      \"options\": {
					        \"orientation\": \"horizontal\",
					        \"reduceOptions\": {
					          \"calcs\": [
					            \"lastNotNull\"
					          ],
					          \"fields\": \"\",
					          \"values\": false
					        },
					        \"showThresholdLabels\": false,
					        \"showThresholdMarkers\": true
					      },
					      \"pluginVersion\": \"8.3.3\",
					      \"targets\": [
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"sum(label_replace(container_memory_working_set_bytes{container!=\\\"POD\\\",container!=\\\"\\\",image!=\\\"\\\"}, \\\"node\\\", \\\"$1\\\", \\\"instance\\\",  \\\"(.*)\\\")  * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!=\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}) by (node))\\n\\n/\\n\\nsum(kube_node_status_allocatable{resource=\\\"memory\\\", unit=\\\"byte\\\"} * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!=\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}) by (node) ) \\n* 100\",
					          \"format\": \"time_series\",
					          \"interval\": \"\",
					          \"intervalFactor\": 1,
					          \"legendFormat\": \"\",
					          \"refId\": \"A\",
					          \"step\": 10
					        }
					      ],
					      \"timeFrom\": \"\",
					      \"title\": \"RAM Utilization\",
					      \"type\": \"gauge\"
					    },
					    {
					      \"description\": \"Current RAM requests vs RAM available\",
					      \"fieldConfig\": {
					        \"defaults\": {
					          \"color\": {
					            \"mode\": \"thresholds\"
					          },
					          \"mappings\": [
					            {
					              \"options\": {
					                \"match\": \"null\",
					                \"result\": {
					                  \"text\": \"N/A\"
					                }
					              },
					              \"type\": \"special\"
					            }
					          ],
					          \"max\": 100,
					          \"min\": 0,
					          \"thresholds\": {
					            \"mode\": \"absolute\",
					            \"steps\": [
					              {
					                \"color\": \"rgba(245, 54, 54, 0.9)\",
					                \"value\": null
					              },
					              {
					                \"color\": \"rgba(50, 172, 45, 0.97)\",
					                \"value\": 30
					              },
					              {
					                \"color\": \"#c15c17\",
					                \"value\": 80
					              }
					            ]
					          },
					          \"unit\": \"percent\"
					        },
					        \"overrides\": []
					      },
					      \"gridPos\": {
					        \"h\": 4,
					        \"w\": 6,
					        \"x\": 18,
					        \"y\": 14
					      },
					      \"id\": 92,
					      \"links\": [],
					      \"maxDataPoints\": 100,
					      \"options\": {
					        \"orientation\": \"horizontal\",
					        \"reduceOptions\": {
					          \"calcs\": [
					            \"lastNotNull\"
					          ],
					          \"fields\": \"\",
					          \"values\": false
					        },
					        \"showThresholdLabels\": false,
					        \"showThresholdMarkers\": true
					      },
					      \"pluginVersion\": \"8.3.3\",
					      \"targets\": [
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"(\\n sum(kube_pod_container_resource_requests{resource=\\\"memory\\\", unit=\\\"byte\\\", namespace!=\\\"\\\"}  * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!=\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}) by (node) )\\n /\\n sum(kube_node_status_allocatable{resource=\\\"memory\\\", unit=\\\"byte\\\"}  * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!=\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}) by (node) )\\n) * 100\",
					          \"format\": \"time_series\",
					          \"interval\": \"\",
					          \"intervalFactor\": 1,
					          \"legendFormat\": \"\",
					          \"refId\": \"A\",
					          \"step\": 10
					        }
					      ],
					      \"title\": \"RAM Requests\",
					      \"type\": \"gauge\"
					    },
					    {
					      \"collapsed\": false,
					      \"gridPos\": {
					        \"h\": 1,
					        \"w\": 24,
					        \"x\": 0,
					        \"y\": 18
					      },
					      \"id\": 108,
					      \"panels\": [],
					      \"title\": \"CPU Metrics\",
					      \"type\": \"row\"
					    },
					    {
					      \"aliasColors\": {},
					      \"bars\": false,
					      \"dashLength\": 10,
					      \"dashes\": false,
					      \"fill\": 1,
					      \"fillGradient\": 0,
					      \"gridPos\": {
					        \"h\": 8,
					        \"w\": 24,
					        \"x\": 0,
					        \"y\": 19
					      },
					      \"hiddenSeries\": false,
					      \"id\": 116,
					      \"legend\": {
					        \"alignAsTable\": false,
					        \"avg\": false,
					        \"current\": false,
					        \"max\": false,
					        \"min\": false,
					        \"rightSide\": false,
					        \"show\": true,
					        \"total\": false,
					        \"values\": false
					      },
					      \"lines\": true,
					      \"linewidth\": 1,
					      \"links\": [],
					      \"nullPointMode\": \"null\",
					      \"options\": {
					        \"alertThreshold\": true
					      },
					      \"percentage\": false,
					      \"pluginVersion\": \"8.3.3\",
					      \"pointradius\": 5,
					      \"points\": false,
					      \"renderer\": \"flot\",
					      \"seriesOverrides\": [],
					      \"spaceLength\": 10,
					      \"stack\": false,
					      \"steppedLine\": false,
					      \"targets\": [
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"SUM(kube_node_status_capacity{resource=\\\"cpu\\\", unit=\\\"core\\\"}  * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!=\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}) by (node))\",
					          \"format\": \"time_series\",
					          \"interval\": \"\",
					          \"intervalFactor\": 1,
					          \"legendFormat\": \"capacity\",
					          \"refId\": \"A\"
					        },
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"SUM(kube_pod_container_resource_requests{resource=\\\"cpu\\\", unit=\\\"core\\\"}  * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!=\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}) by (node))\",
					          \"format\": \"time_series\",
					          \"interval\": \"\",
					          \"intervalFactor\": 1,
					          \"legendFormat\": \"requests\",
					          \"refId\": \"C\"
					        },
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"SUM(irate(container_cpu_usage_seconds_total{id=\\\"/\\\"}[5m])  * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!=\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}) by (node))\",
					          \"format\": \"time_series\",
					          \"interval\": \"\",
					          \"intervalFactor\": 1,
					          \"legendFormat\": \"usage\",
					          \"refId\": \"B\"
					        },
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"SUM(kube_pod_container_resource_limits{resource=\\\"cpu\\\", unit=\\\"core\\\"}  * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!=\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}) by (node)) \",
					          \"format\": \"time_series\",
					          \"interval\": \"\",
					          \"intervalFactor\": 1,
					          \"legendFormat\": \"limits\",
					          \"refId\": \"D\"
					        }
					      ],
					      \"thresholds\": [],
					      \"timeRegions\": [],
					      \"title\": \"Cluster CPUs\",
					      \"tooltip\": {
					        \"shared\": true,
					        \"sort\": 0,
					        \"value_type\": \"individual\"
					      },
					      \"type\": \"graph\",
					      \"xaxis\": {
					        \"mode\": \"time\",
					        \"show\": true,
					        \"values\": []
					      },
					      \"yaxes\": [
					        {
					          \"decimals\": 1,
					          \"format\": \"short\",
					          \"logBase\": 1,
					          \"show\": true
					        },
					        {
					          \"format\": \"short\",
					          \"logBase\": 1,
					          \"show\": true
					        }
					      ],
					      \"yaxis\": {
					        \"align\": false
					      }
					    },
					    {
					      \"aliasColors\": {},
					      \"bars\": false,
					      \"dashLength\": 10,
					      \"dashes\": false,
					      \"description\": \"Current CPU use from applications divided by allocatable CPUs\",
					      \"fieldConfig\": {
					        \"defaults\": {
					          \"unit\": \"percent\"
					        },
					        \"overrides\": []
					      },
					      \"fill\": 1,
					      \"fillGradient\": 0,
					      \"gridPos\": {
					        \"h\": 5,
					        \"w\": 24,
					        \"x\": 0,
					        \"y\": 27
					      },
					      \"hiddenSeries\": false,
					      \"hideTimeOverride\": true,
					      \"id\": 82,
					      \"legend\": {
					        \"avg\": false,
					        \"current\": false,
					        \"max\": false,
					        \"min\": false,
					        \"show\": true,
					        \"total\": false,
					        \"values\": false
					      },
					      \"lines\": true,
					      \"linewidth\": 1,
					      \"links\": [],
					      \"maxDataPoints\": 100,
					      \"nullPointMode\": \"null\",
					      \"options\": {
					        \"alertThreshold\": true
					      },
					      \"percentage\": false,
					      \"pluginVersion\": \"8.3.3\",
					      \"pointradius\": 2,
					      \"points\": false,
					      \"renderer\": \"flot\",
					      \"seriesOverrides\": [],
					      \"spaceLength\": 10,
					      \"stack\": false,
					      \"steppedLine\": false,
					      \"targets\": [
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"sum(\\nlabel_replace(irate(container_cpu_usage_seconds_total{container!=\\\"POD\\\", container!=\\\"\\\",image!=\\\"\\\"}[1h]), \\\"node\\\", \\\"$1\\\", \\\"instance\\\",  \\\"(.*)\\\") \\n* on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!~\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}) by (node)\\n)\\n/\\nsum(\\nkube_node_status_allocatable{resource=\\\"cpu\\\", unit=\\\"core\\\"} \\n* on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!~\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}) by (node) \\n) \\n\\n* 100\",
					          \"format\": \"time_series\",
					          \"interval\": \"\",
					          \"intervalFactor\": 1,
					          \"legendFormat\": \"cpu\",
					          \"refId\": \"A\",
					          \"step\": 10
					        }
					      ],
					      \"thresholds\": [],
					      \"timeFrom\": \"\",
					      \"timeRegions\": [],
					      \"title\": \"Cluster CPU Utilization\",
					      \"tooltip\": {
					        \"shared\": true,
					        \"sort\": 0,
					        \"value_type\": \"individual\"
					      },
					      \"type\": \"graph\",
					      \"xaxis\": {
					        \"mode\": \"time\",
					        \"show\": true,
					        \"values\": []
					      },
					      \"yaxes\": [
					        {
					          \"format\": \"percent\",
					          \"logBase\": 1,
					          \"show\": true
					        },
					        {
					          \"format\": \"short\",
					          \"logBase\": 1,
					          \"show\": true
					        }
					      ],
					      \"yaxis\": {
					        \"align\": false
					      }
					    },
					    {
					      \"collapsed\": false,
					      \"gridPos\": {
					        \"h\": 1,
					        \"w\": 24,
					        \"x\": 0,
					        \"y\": 32
					      },
					      \"id\": 113,
					      \"panels\": [],
					      \"title\": \"Memory Metrics\",
					      \"type\": \"row\"
					    },
					    {
					      \"aliasColors\": {},
					      \"bars\": false,
					      \"dashLength\": 10,
					      \"dashes\": false,
					      \"fill\": 1,
					      \"fillGradient\": 0,
					      \"gridPos\": {
					        \"h\": 8,
					        \"w\": 24,
					        \"x\": 0,
					        \"y\": 33
					      },
					      \"hiddenSeries\": false,
					      \"id\": 117,
					      \"legend\": {
					        \"avg\": false,
					        \"current\": false,
					        \"max\": false,
					        \"min\": false,
					        \"show\": false,
					        \"total\": false,
					        \"values\": false
					      },
					      \"lines\": true,
					      \"linewidth\": 1,
					      \"links\": [],
					      \"nullPointMode\": \"null\",
					      \"options\": {
					        \"alertThreshold\": true
					      },
					      \"percentage\": false,
					      \"pluginVersion\": \"8.3.3\",
					      \"pointradius\": 5,
					      \"points\": false,
					      \"renderer\": \"flot\",
					      \"seriesOverrides\": [],
					      \"spaceLength\": 10,
					      \"stack\": false,
					      \"steppedLine\": false,
					      \"targets\": [
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"SUM(kube_node_status_capacity{resource=\\\"memory\\\", unit=\\\"byte\\\"}  * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!=\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}) by (node)  / 1024 / 1024 / 1024 )\",
					          \"format\": \"time_series\",
					          \"interval\": \"\",
					          \"intervalFactor\": 1,
					          \"legendFormat\": \"capacity\",
					          \"refId\": \"A\"
					        },
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"SUM(kube_pod_container_resource_requests{resource=\\\"memory\\\", unit=\\\"byte\\\", namespace!=\\\"\\\"} * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!=\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}) by (node)/ 1024 / 1024 / 1024)\",
					          \"format\": \"time_series\",
					          \"interval\": \"\",
					          \"intervalFactor\": 1,
					          \"legendFormat\": \"requests\",
					          \"refId\": \"C\"
					        },
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"SUM(container_memory_usage_bytes{image!=\\\"\\\"}   * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!=\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}) by (node) / 1024 / 1024 / 1024)\",
					          \"format\": \"time_series\",
					          \"interval\": \"\",
					          \"intervalFactor\": 1,
					          \"legendFormat\": \"usage\",
					          \"refId\": \"B\"
					        },
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"SUM(kube_pod_container_resource_limits{resource=\\\"memory\\\", unit=\\\"byte\\\", namespace!=\\\"\\\"} * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!=\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}) by (node) / 1024 / 1024 / 1024)\",
					          \"format\": \"time_series\",
					          \"interval\": \"\",
					          \"intervalFactor\": 1,
					          \"legendFormat\": \"limits\",
					          \"refId\": \"D\"
					        }
					      ],
					      \"thresholds\": [],
					      \"timeRegions\": [],
					      \"title\": \"Cluster memory (GB)\",
					      \"tooltip\": {
					        \"shared\": true,
					        \"sort\": 0,
					        \"value_type\": \"individual\"
					      },
					      \"type\": \"graph\",
					      \"xaxis\": {
					        \"mode\": \"time\",
					        \"show\": true,
					        \"values\": []
					      },
					      \"yaxes\": [
					        {
					          \"$$hashKey\": \"object:3385\",
					          \"format\": \"decgbytes\",
					          \"logBase\": 1,
					          \"show\": true
					        },
					        {
					          \"$$hashKey\": \"object:3386\",
					          \"format\": \"short\",
					          \"logBase\": 1,
					          \"show\": true
					        }
					      ],
					      \"yaxis\": {
					        \"align\": false
					      }
					    },
					    {
					      \"aliasColors\": {},
					      \"bars\": false,
					      \"dashLength\": 10,
					      \"dashes\": false,
					      \"fieldConfig\": {
					        \"defaults\": {
					          \"unit\": \"percent\"
					        },
					        \"overrides\": []
					      },
					      \"fill\": 1,
					      \"fillGradient\": 0,
					      \"gridPos\": {
					        \"h\": 8,
					        \"w\": 24,
					        \"x\": 0,
					        \"y\": 41
					      },
					      \"hiddenSeries\": false,
					      \"id\": 131,
					      \"legend\": {
					        \"avg\": false,
					        \"current\": false,
					        \"max\": false,
					        \"min\": false,
					        \"show\": false,
					        \"total\": false,
					        \"values\": false
					      },
					      \"lines\": true,
					      \"linewidth\": 1,
					      \"links\": [],
					      \"nullPointMode\": \"null\",
					      \"options\": {
					        \"alertThreshold\": true
					      },
					      \"percentage\": false,
					      \"pluginVersion\": \"8.3.3\",
					      \"pointradius\": 5,
					      \"points\": false,
					      \"renderer\": \"flot\",
					      \"seriesOverrides\": [],
					      \"spaceLength\": 10,
					      \"stack\": false,
					      \"steppedLine\": false,
					      \"targets\": [
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"(\\n sum(kube_pod_container_resource_requests{resource=\\\"memory\\\", unit=\\\"byte\\\", namespace!=\\\"\\\"}  * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!=\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}) by (node) )\\n /\\n sum(kube_node_status_allocatable{resource=\\\"memory\\\", unit=\\\"byte\\\"}  * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!=\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}) by (node) )\\n) * 100\",
					          \"format\": \"time_series\",
					          \"interval\": \"\",
					          \"intervalFactor\": 1,
					          \"legendFormat\": \"usage\",
					          \"refId\": \"A\"
					        }
					      ],
					      \"thresholds\": [],
					      \"timeRegions\": [],
					      \"title\": \"Cluster Memory Utilization\",
					      \"tooltip\": {
					        \"shared\": true,
					        \"sort\": 0,
					        \"value_type\": \"individual\"
					      },
					      \"type\": \"graph\",
					      \"xaxis\": {
					        \"mode\": \"time\",
					        \"show\": true,
					        \"values\": []
					      },
					      \"yaxes\": [
					        {
					          \"$$hashKey\": \"object:3355\",
					          \"format\": \"percent\",
					          \"logBase\": 1,
					          \"show\": true
					        },
					        {
					          \"$$hashKey\": \"object:3356\",
					          \"format\": \"short\",
					          \"logBase\": 1,
					          \"show\": true
					        }
					      ],
					      \"yaxis\": {
					        \"align\": false
					      }
					    }
					  ],
					  \"refresh\": false,
					  \"schemaVersion\": 34,
					  \"style\": \"dark\",
					  \"tags\": [
					    \"cost\",
					    \"utilization\",
					    \"metrics\"
					  ],
					  \"templating\": {
					    \"list\": [
					      {
					        \"current\": {
					          \"selected\": false,
					          \"text\": \"100\",
					          \"value\": \"100\"
					        },
					        \"hide\": 0,
					        \"name\": \"Discount\",
					        \"options\": [
					          {
					            \"selected\": true,
					            \"text\": \"100\",
					            \"value\": \"100\"
					          }
					        ],
					        \"query\": \"100\",
					        \"skipUrlSync\": false,
					        \"type\": \"textbox\"
					      }
					    ]
					  },
					  \"time\": {
					    \"from\": \"now-24h\",
					    \"to\": \"now\"
					  },
					  \"timepicker\": {
					    \"hidden\": false,
					    \"refresh_intervals\": [
					      \"5s\",
					      \"10s\",
					      \"30s\",
					      \"1m\",
					      \"5m\",
					      \"15m\",
					      \"30m\",
					      \"1h\",
					      \"2h\",
					      \"1d\"
					    ],
					    \"time_options\": [
					      \"5m\",
					      \"15m\",
					      \"1h\",
					      \"6h\",
					      \"12h\",
					      \"24h\",
					      \"2d\",
					      \"7d\",
					      \"30d\"
					    ]
					  },
					  \"timezone\": \"browser\",
					  \"title\": \"Cluster cost & utilization metrics\",
					  \"uid\": \"cluster-costs\",
					  \"version\": 2,
					  \"weekStart\": \"\"
					}

					"""

				"costs-dimension": json: """
					{
					  \"annotations\": {
					    \"list\": [
					      {
					        \"builtIn\": 1,
					        \"datasource\": \"-- Grafana --\",
					        \"enable\": true,
					        \"hide\": true,
					        \"iconColor\": \"rgba(0, 211, 255, 1)\",
					        \"name\": \"Annotations & Alerts\",
					        \"target\": {
					          \"limit\": 100,
					          \"matchAny\": false,
					          \"tags\": [],
					          \"type\": \"dashboard\"
					        },
					        \"type\": \"dashboard\"
					      }
					    ]
					  },
					  \"editable\": true,
					  \"fiscalYearStartMonth\": 0,
					  \"graphTooltip\": 0,
					  \"iteration\": 1641378721229,
					  \"links\": [],
					  \"liveNow\": false,
					  \"panels\": [
					    {
					      \"collapsed\": false,
					      \"gridPos\": {
					        \"h\": 1,
					        \"w\": 24,
					        \"x\": 0,
					        \"y\": 0
					      },
					      \"id\": 19,
					      \"panels\": [],
					      \"title\": \"Namespace consumed resource usage costs\",
					      \"type\": \"row\"
					    },
					    {
					      \"description\": \"\",
					      \"fieldConfig\": {
					        \"defaults\": {
					          \"color\": {
					            \"mode\": \"palette-classic\"
					          },
					          \"custom\": {
					            \"hideFrom\": {
					              \"legend\": false,
					              \"tooltip\": false,
					              \"viz\": false
					            }
					          },
					          \"mappings\": [],
					          \"unit\": \"currencyJPY\"
					        },
					        \"overrides\": []
					      },
					      \"gridPos\": {
					        \"h\": 8,
					        \"w\": 8,
					        \"x\": 0,
					        \"y\": 1
					      },
					      \"id\": 16,
					      \"options\": {
					        \"displayLabels\": [
					          \"percent\"
					        ],
					        \"legend\": {
					          \"displayMode\": \"list\",
					          \"placement\": \"right\",
					          \"values\": []
					        },
					        \"pieType\": \"pie\",
					        \"reduceOptions\": {
					          \"calcs\": [
					            \"lastNotNull\"
					          ],
					          \"fields\": \"\",
					          \"values\": true
					        },
					        \"tooltip\": {
					          \"mode\": \"single\"
					        }
					      },
					      \"targets\": [
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"sum(\\n    sum_over_time(namespace:container_cpu_usage_costs_hourly:sum_rate{}[$__range]) + \\n    sum_over_time(namespace:container_memory_usage_costs_hourly:sum_rate{}[$__range])\\n) by (namespace) * ($Discount/100.0)\",
					          \"format\": \"table\",
					          \"instant\": true,
					          \"interval\": \"\",
					          \"legendFormat\": \"{{namespace}}\",
					          \"refId\": \"A\"
					        }
					      ],
					      \"title\": \"last--hours-total-costs-by-namespace{${__from:date:YYYY-MM-DD-hh}->${__to:date:YYYY-MM-DD-hh}}\",
					      \"type\": \"piechart\"
					    },
					    {
					      \"description\": \"\",
					      \"fieldConfig\": {
					        \"defaults\": {
					          \"color\": {
					            \"mode\": \"palette-classic\"
					          },
					          \"custom\": {
					            \"hideFrom\": {
					              \"legend\": false,
					              \"tooltip\": false,
					              \"viz\": false
					            }
					          },
					          \"mappings\": [],
					          \"unit\": \"currencyJPY\"
					        },
					        \"overrides\": []
					      },
					      \"gridPos\": {
					        \"h\": 8,
					        \"w\": 8,
					        \"x\": 8,
					        \"y\": 1
					      },
					      \"id\": 20,
					      \"options\": {
					        \"displayLabels\": [
					          \"percent\"
					        ],
					        \"legend\": {
					          \"displayMode\": \"list\",
					          \"placement\": \"right\",
					          \"values\": []
					        },
					        \"pieType\": \"pie\",
					        \"reduceOptions\": {
					          \"calcs\": [
					            \"lastNotNull\"
					          ],
					          \"fields\": \"\",
					          \"values\": true
					        },
					        \"tooltip\": {
					          \"mode\": \"single\"
					        }
					      },
					      \"targets\": [
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"sum(\\n    sum_over_time(namespace:container_cpu_usage_costs_hourly:sum_rate{}[7d]) + \\n    sum_over_time(namespace:container_memory_usage_costs_hourly:sum_rate{}[7d])\\n) by (namespace) * ($Discount/100.0)\",
					          \"format\": \"table\",
					          \"instant\": true,
					          \"interval\": \"\",
					          \"legendFormat\": \"\",
					          \"refId\": \"A\"
					        }
					      ],
					      \"title\": \"Last-7day-costs-by-namespace\",
					      \"type\": \"piechart\"
					    },
					    {
					      \"description\": \"\",
					      \"fieldConfig\": {
					        \"defaults\": {
					          \"color\": {
					            \"mode\": \"palette-classic\"
					          },
					          \"custom\": {
					            \"hideFrom\": {
					              \"legend\": false,
					              \"tooltip\": false,
					              \"viz\": false
					            }
					          },
					          \"mappings\": [],
					          \"unit\": \"currencyJPY\"
					        },
					        \"overrides\": []
					      },
					      \"gridPos\": {
					        \"h\": 8,
					        \"w\": 8,
					        \"x\": 16,
					        \"y\": 1
					      },
					      \"id\": 17,
					      \"options\": {
					        \"displayLabels\": [
					          \"percent\"
					        ],
					        \"legend\": {
					          \"displayMode\": \"list\",
					          \"placement\": \"right\",
					          \"values\": []
					        },
					        \"pieType\": \"pie\",
					        \"reduceOptions\": {
					          \"calcs\": [
					            \"lastNotNull\"
					          ],
					          \"fields\": \"\",
					          \"values\": true
					        },
					        \"tooltip\": {
					          \"mode\": \"single\"
					        }
					      },
					      \"targets\": [
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"sum(\\n    sum_over_time(namespace:container_cpu_usage_costs_hourly:sum_rate{}[30d]) + \\n    sum_over_time(namespace:container_memory_usage_costs_hourly:sum_rate{}[30d])\\n) by (namespace) * ($Discount/100.0)\",
					          \"format\": \"table\",
					          \"instant\": true,
					          \"interval\": \"\",
					          \"legendFormat\": \"\",
					          \"refId\": \"A\"
					        }
					      ],
					      \"title\": \"Last-30day-costs-by-namespace\",
					      \"type\": \"piechart\"
					    },
					    {
					      \"collapsed\": false,
					      \"gridPos\": {
					        \"h\": 1,
					        \"w\": 24,
					        \"x\": 0,
					        \"y\": 9
					      },
					      \"id\": 2,
					      \"panels\": [],
					      \"title\": \"Namespace-hourly-resource-usage-cost-trends\",
					      \"type\": \"row\"
					    },
					    {
					      \"aliasColors\": {},
					      \"bars\": false,
					      \"dashLength\": 10,
					      \"dashes\": false,
					      \"description\": \"Total Resource Usage Hourly Cost by Namespace\",
					      \"fill\": 1,
					      \"fillGradient\": 0,
					      \"gridPos\": {
					        \"h\": 8,
					        \"w\": 12,
					        \"x\": 0,
					        \"y\": 10
					      },
					      \"hiddenSeries\": false,
					      \"id\": 8,
					      \"legend\": {
					        \"avg\": false,
					        \"current\": false,
					        \"max\": false,
					        \"min\": false,
					        \"show\": true,
					        \"total\": false,
					        \"values\": false
					      },
					      \"lines\": true,
					      \"linewidth\": 1,
					      \"nullPointMode\": \"null\",
					      \"options\": {
					        \"alertThreshold\": true
					      },
					      \"percentage\": false,
					      \"pluginVersion\": \"8.3.3\",
					      \"pointradius\": 2,
					      \"points\": false,
					      \"renderer\": \"flot\",
					      \"seriesOverrides\": [],
					      \"spaceLength\": 10,
					      \"stack\": false,
					      \"steppedLine\": false,
					      \"targets\": [
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": true,
					          \"expr\": \"sum (\\nsum(label_replace(irate(container_cpu_usage_seconds_total{container!=\\\"POD\\\", container!=\\\"\\\",image!=\\\"\\\"}[1h]), \\\"node\\\", \\\"$1\\\", \\\"instance\\\",  \\\"(.*)\\\")) by (container, pod, node, namespace) * on (node) group_left()\\n  avg(avg_over_time(node_cpu_hourly_cost[1h])) by (node)\\n  \\n+\\n\\nsum(label_replace(avg_over_time(container_memory_working_set_bytes{container!=\\\"POD\\\",container!=\\\"\\\",image!=\\\"\\\"}[1h]), \\\"node\\\", \\\"$1\\\", \\\"instance\\\",  \\\"(.*)\\\")) by (container, pod, node, namespace) / 1024.0 / 1024.0 / 1024.0 * on (node) group_left()\\n  avg(avg_over_time(node_ram_hourly_cost[1h])) by (node)\\n) by (namespace) * ($Discount/100.0)\",
					          \"interval\": \"1h\",
					          \"legendFormat\": \"{{namespace}}\",
					          \"refId\": \"A\"
					        }
					      ],
					      \"thresholds\": [],
					      \"timeRegions\": [],
					      \"title\": \"Total Resource Usage Hourly Cost\",
					      \"tooltip\": {
					        \"shared\": true,
					        \"sort\": 0,
					        \"value_type\": \"individual\"
					      },
					      \"type\": \"graph\",
					      \"xaxis\": {
					        \"mode\": \"time\",
					        \"show\": true,
					        \"values\": []
					      },
					      \"yaxes\": [
					        {
					          \"$$hashKey\": \"object:3848\",
					          \"format\": \"currencyJPY\",
					          \"logBase\": 1,
					          \"show\": true
					        },
					        {
					          \"$$hashKey\": \"object:3849\",
					          \"format\": \"short\",
					          \"logBase\": 1,
					          \"show\": true
					        }
					      ],
					      \"yaxis\": {
					        \"align\": false
					      }
					    },
					    {
					      \"aliasColors\": {},
					      \"bars\": false,
					      \"dashLength\": 10,
					      \"dashes\": false,
					      \"description\": \"Ram Resource Usage Houly Cost by Namespace\",
					      \"fill\": 1,
					      \"fillGradient\": 0,
					      \"gridPos\": {
					        \"h\": 8,
					        \"w\": 12,
					        \"x\": 12,
					        \"y\": 10
					      },
					      \"hiddenSeries\": false,
					      \"id\": 6,
					      \"legend\": {
					        \"avg\": false,
					        \"current\": false,
					        \"max\": false,
					        \"min\": false,
					        \"show\": true,
					        \"total\": false,
					        \"values\": false
					      },
					      \"lines\": true,
					      \"linewidth\": 1,
					      \"nullPointMode\": \"null\",
					      \"options\": {
					        \"alertThreshold\": true
					      },
					      \"percentage\": false,
					      \"pluginVersion\": \"8.3.3\",
					      \"pointradius\": 2,
					      \"points\": false,
					      \"renderer\": \"flot\",
					      \"seriesOverrides\": [],
					      \"spaceLength\": 10,
					      \"stack\": false,
					      \"steppedLine\": false,
					      \"targets\": [
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": true,
					          \"expr\": \"sum(\\n  sum(label_replace(avg_over_time(container_memory_working_set_bytes{container!=\\\"POD\\\",container!=\\\"\\\",image!=\\\"\\\"}[1h]), \\\"node\\\", \\\"$1\\\", \\\"instance\\\",  \\\"(.*)\\\")) by (container, pod, node, namespace) / 1024.0 / 1024.0 / 1024.0 * on (node) group_left()\\n  avg(avg_over_time(node_ram_hourly_cost[1h])) by (node)\\n) by (namespace) * ($Discount/100.0)\",
					          \"interval\": \"1h\",
					          \"legendFormat\": \"{{namespace}}\",
					          \"refId\": \"A\"
					        }
					      ],
					      \"thresholds\": [],
					      \"timeRegions\": [],
					      \"title\": \"Ram Resource Usage Houly Cost\",
					      \"tooltip\": {
					        \"shared\": true,
					        \"sort\": 0,
					        \"value_type\": \"individual\"
					      },
					      \"type\": \"graph\",
					      \"xaxis\": {
					        \"mode\": \"time\",
					        \"show\": true,
					        \"values\": []
					      },
					      \"yaxes\": [
					        {
					          \"$$hashKey\": \"object:3783\",
					          \"format\": \"short\",
					          \"logBase\": 1,
					          \"show\": true
					        },
					        {
					          \"$$hashKey\": \"object:3784\",
					          \"format\": \"short\",
					          \"logBase\": 1,
					          \"show\": true
					        }
					      ],
					      \"yaxis\": {
					        \"align\": false
					      }
					    },
					    {
					      \"aliasColors\": {},
					      \"bars\": false,
					      \"dashLength\": 10,
					      \"dashes\": false,
					      \"description\": \"CPU Resource Usage Hourly cost by namespace\",
					      \"fill\": 1,
					      \"fillGradient\": 0,
					      \"gridPos\": {
					        \"h\": 8,
					        \"w\": 12,
					        \"x\": 0,
					        \"y\": 18
					      },
					      \"hiddenSeries\": false,
					      \"id\": 4,
					      \"legend\": {
					        \"avg\": false,
					        \"current\": false,
					        \"max\": false,
					        \"min\": false,
					        \"show\": true,
					        \"total\": false,
					        \"values\": false
					      },
					      \"lines\": true,
					      \"linewidth\": 1,
					      \"nullPointMode\": \"null\",
					      \"options\": {
					        \"alertThreshold\": true
					      },
					      \"percentage\": false,
					      \"pluginVersion\": \"8.3.3\",
					      \"pointradius\": 2,
					      \"points\": false,
					      \"renderer\": \"flot\",
					      \"seriesOverrides\": [],
					      \"spaceLength\": 10,
					      \"stack\": false,
					      \"steppedLine\": false,
					      \"targets\": [
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": true,
					          \"expr\": \"sum(\\n\\nsum(label_replace(irate(container_cpu_usage_seconds_total{container!=\\\"POD\\\", container!=\\\"\\\",image!=\\\"\\\"}[1h]), \\\"node\\\", \\\"$1\\\", \\\"instance\\\",  \\\"(.*)\\\")) by (container, pod, node, namespace) * on (node) group_left()\\n  avg(avg_over_time(node_cpu_hourly_cost[1h])) by (node)\\n\\n\\n  ) by (namespace) * ($Discount/100.0)\",
					          \"interval\": \"1h\",
					          \"legendFormat\": \"{{namespace}}\",
					          \"refId\": \"A\"
					        }
					      ],
					      \"thresholds\": [],
					      \"timeRegions\": [],
					      \"title\": \"CPU Resource Usage Hourly Cost\",
					      \"tooltip\": {
					        \"shared\": true,
					        \"sort\": 0,
					        \"value_type\": \"individual\"
					      },
					      \"type\": \"graph\",
					      \"xaxis\": {
					        \"mode\": \"time\",
					        \"show\": true,
					        \"values\": []
					      },
					      \"yaxes\": [
					        {
					          \"$$hashKey\": \"object:3675\",
					          \"format\": \"currencyJPY\",
					          \"logBase\": 1,
					          \"show\": true
					        },
					        {
					          \"$$hashKey\": \"object:3676\",
					          \"format\": \"currencyJPY\",
					          \"logBase\": 1,
					          \"show\": true
					        }
					      ],
					      \"yaxis\": {
					        \"align\": false
					      }
					    },
					    {
					      \"description\": \"Estimated Namespace Monthly Cost according latest hourly cost\",
					      \"fieldConfig\": {
					        \"defaults\": {
					          \"color\": {
					            \"mode\": \"palette-classic\"
					          },
					          \"custom\": {
					            \"hideFrom\": {
					              \"legend\": false,
					              \"tooltip\": false,
					              \"viz\": false
					            }
					          },
					          \"mappings\": [
					            {
					              \"options\": {
					                \"\": {
					                  \"text\": \"\"
					                }
					              },
					              \"type\": \"value\"
					            }
					          ],
					          \"unit\": \"currencyJPY\"
					        },
					        \"overrides\": []
					      },
					      \"gridPos\": {
					        \"h\": 8,
					        \"w\": 12,
					        \"x\": 12,
					        \"y\": 18
					      },
					      \"id\": 10,
					      \"options\": {
					        \"displayLabels\": [],
					        \"legend\": {
					          \"displayMode\": \"list\",
					          \"placement\": \"right\",
					          \"values\": []
					        },
					        \"pieType\": \"pie\",
					        \"reduceOptions\": {
					          \"calcs\": [
					            \"lastNotNull\"
					          ],
					          \"fields\": \"\",
					          \"values\": true
					        },
					        \"text\": {},
					        \"tooltip\": {
					          \"mode\": \"single\"
					        }
					      },
					      \"pluginVersion\": \"7.5.2\",
					      \"targets\": [
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"sum (\\nsum(label_replace(irate(container_cpu_usage_seconds_total{container!=\\\"POD\\\", container!=\\\"\\\",image!=\\\"\\\"}[1h]), \\\"node\\\", \\\"$1\\\", \\\"instance\\\",  \\\"(.*)\\\")) by (container, pod, node, namespace) * on (node) group_left()\\n  avg(avg_over_time(node_cpu_hourly_cost[1h])) by (node)\\n\\n+\\n\\nsum(label_replace(avg_over_time(container_memory_working_set_bytes{container!=\\\"POD\\\",container!=\\\"\\\",image!=\\\"\\\"}[1h]), \\\"node\\\", \\\"$1\\\", \\\"instance\\\",  \\\"(.*)\\\")) by (container, pod, node, namespace) / 1024.0 / 1024.0 / 1024.0 * on (node) group_left()\\n  avg(avg_over_time(node_ram_hourly_cost[1h])) by (node)\\n) by (namespace)  * 730 * ($Discount/100.0)\",
					          \"format\": \"table\",
					          \"instant\": true,
					          \"interval\": \"\",
					          \"legendFormat\": \"{{namespace}}\",
					          \"refId\": \"A\"
					        }
					      ],
					      \"title\": \"Estimated Namespace Resource Usage Monthly Cost\",
					      \"type\": \"piechart\"
					    },
					    {
					      \"collapsed\": false,
					      \"gridPos\": {
					        \"h\": 1,
					        \"w\": 24,
					        \"x\": 0,
					        \"y\": 26
					      },
					      \"id\": 14,
					      \"panels\": [],
					      \"title\": \"Containers\",
					      \"type\": \"row\"
					    },
					    {
					      \"description\": \"Top K container costs of latest hour\",
					      \"fieldConfig\": {
					        \"defaults\": {
					          \"custom\": {
					            \"align\": \"auto\",
					            \"displayMode\": \"auto\"
					          },
					          \"mappings\": [],
					          \"thresholds\": {
					            \"mode\": \"absolute\",
					            \"steps\": [
					              {
					                \"color\": \"green\",
					                \"value\": null
					              },
					              {
					                \"color\": \"red\",
					                \"value\": 80
					              }
					            ]
					          }
					        },
					        \"overrides\": [
					          {
					            \"matcher\": {
					              \"id\": \"byName\",
					              \"options\": \"Value #total-costs\"
					            },
					            \"properties\": [
					              {
					                \"id\": \"displayName\",
					                \"value\": \"total-costs\"
					              },
					              {
					                \"id\": \"unit\",
					                \"value\": \"currencyJPY\"
					              }
					            ]
					          },
					          {
					            \"matcher\": {
					              \"id\": \"byName\",
					              \"options\": \"Value #cpu-usage-costs\"
					            },
					            \"properties\": [
					              {
					                \"id\": \"displayName\",
					                \"value\": \"cpu-usage-costs\"
					              },
					              {
					                \"id\": \"unit\",
					                \"value\": \"currencyJPY\"
					              }
					            ]
					          },
					          {
					            \"matcher\": {
					              \"id\": \"byName\",
					              \"options\": \"Value #ram-usage-costs\"
					            },
					            \"properties\": [
					              {
					                \"id\": \"unit\",
					                \"value\": \"currencyJPY\"
					              },
					              {
					                \"id\": \"displayName\",
					                \"value\": \"ram-usage-costs\"
					              }
					            ]
					          }
					        ]
					      },
					      \"gridPos\": {
					        \"h\": 9,
					        \"w\": 24,
					        \"x\": 0,
					        \"y\": 27
					      },
					      \"id\": 23,
					      \"options\": {
					        \"footer\": {
					          \"fields\": \"\",
					          \"reducer\": [
					            \"sum\"
					          ],
					          \"show\": false
					        },
					        \"showHeader\": true,
					        \"sortBy\": [
					          {
					            \"desc\": true,
					            \"displayName\": \"total-costs\"
					          }
					        ]
					      },
					      \"pluginVersion\": \"8.3.3\",
					      \"targets\": [
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"topk(20, sum(\\n    sum_over_time(namespace:container_cpu_usage_costs_hourly:sum_rate{}[$__range]) + \\n    sum_over_time(namespace:container_memory_usage_costs_hourly:sum_rate{}[$__range])\\n) by (container,namespace,pod) * ($Discount/100.0)\\n) \",
					          \"format\": \"table\",
					          \"hide\": false,
					          \"instant\": true,
					          \"interval\": \"\",
					          \"legendFormat\": \"\",
					          \"refId\": \"total-costs\"
					        }
					      ],
					      \"title\": \"TopK Container Total Usage Costs{${__from:date:YYYY-MM-DD-hh}->${__to:date:YYYY-MM-DD-hh}}\",
					      \"transformations\": [
					        {
					          \"id\": \"filterFieldsByName\",
					          \"options\": {
					            \"include\": {
					              \"names\": [
					                \"container\",
					                \"namespace\",
					                \"node\",
					                \"pod\",
					                \"Value #cpu-usage-costs\",
					                \"Value #ram-usage-costs\",
					                \"Value #total-costs\"
					              ]
					            }
					          }
					        },
					        {
					          \"id\": \"merge\",
					          \"options\": {}
					        }
					      ],
					      \"type\": \"table\"
					    },
					    {
					      \"description\": \"Top K container costs of latest hour\",
					      \"fieldConfig\": {
					        \"defaults\": {
					          \"custom\": {
					            \"align\": \"auto\",
					            \"displayMode\": \"auto\"
					          },
					          \"mappings\": [],
					          \"thresholds\": {
					            \"mode\": \"absolute\",
					            \"steps\": [
					              {
					                \"color\": \"green\",
					                \"value\": null
					              },
					              {
					                \"color\": \"red\",
					                \"value\": 80
					              }
					            ]
					          }
					        },
					        \"overrides\": [
					          {
					            \"matcher\": {
					              \"id\": \"byName\",
					              \"options\": \"Value #total-costs\"
					            },
					            \"properties\": [
					              {
					                \"id\": \"displayName\",
					                \"value\": \"total-costs\"
					              },
					              {
					                \"id\": \"unit\",
					                \"value\": \"currencyJPY\"
					              }
					            ]
					          },
					          {
					            \"matcher\": {
					              \"id\": \"byName\",
					              \"options\": \"Value #cpu-usage-costs\"
					            },
					            \"properties\": [
					              {
					                \"id\": \"displayName\",
					                \"value\": \"cpu-usage-costs\"
					              },
					              {
					                \"id\": \"unit\",
					                \"value\": \"currencyJPY\"
					              }
					            ]
					          },
					          {
					            \"matcher\": {
					              \"id\": \"byName\",
					              \"options\": \"Value #ram-usage-costs\"
					            },
					            \"properties\": [
					              {
					                \"id\": \"unit\",
					                \"value\": \"currencyJPY\"
					              },
					              {
					                \"id\": \"displayName\",
					                \"value\": \"ram-usage-costs\"
					              }
					            ]
					          }
					        ]
					      },
					      \"gridPos\": {
					        \"h\": 9,
					        \"w\": 24,
					        \"x\": 0,
					        \"y\": 36
					      },
					      \"id\": 12,
					      \"options\": {
					        \"footer\": {
					          \"fields\": \"\",
					          \"reducer\": [
					            \"sum\"
					          ],
					          \"show\": false
					        },
					        \"showHeader\": true,
					        \"sortBy\": [
					          {
					            \"desc\": true,
					            \"displayName\": \"total-costs\"
					          }
					        ]
					      },
					      \"pluginVersion\": \"8.3.3\",
					      \"targets\": [
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"topk(20, sum (\\nsum(label_replace(irate(container_cpu_usage_seconds_total{container!=\\\"POD\\\", container!=\\\"\\\",image!=\\\"\\\"}[1h]), \\\"node\\\", \\\"$1\\\", \\\"instance\\\",  \\\"(.*)\\\")) by (container, pod, node, namespace) * on (node) group_left()\\n  avg(avg_over_time(node_cpu_hourly_cost[1h])) by (node)\\n\\n+\\n\\nsum(label_replace(avg_over_time(container_memory_working_set_bytes{container!=\\\"POD\\\",container!=\\\"\\\",image!=\\\"\\\"}[1h]), \\\"node\\\", \\\"$1\\\", \\\"instance\\\",  \\\"(.*)\\\")) by (container, pod, node, namespace) / 1024.0 / 1024.0 / 1024.0 * on (node) group_left()\\n  avg(avg_over_time(node_ram_hourly_cost[1h])) by (node)\\n) by (container, pod, node, namespace)) * ($Discount/100.0)\",
					          \"format\": \"table\",
					          \"hide\": false,
					          \"instant\": true,
					          \"interval\": \"\",
					          \"legendFormat\": \"\",
					          \"refId\": \"total-costs\"
					        }
					      ],
					      \"title\": \"TopK Container Total Usage Costs Latest 1 Hour\",
					      \"transformations\": [
					        {
					          \"id\": \"filterFieldsByName\",
					          \"options\": {
					            \"include\": {
					              \"names\": [
					                \"container\",
					                \"namespace\",
					                \"node\",
					                \"pod\",
					                \"Value #cpu-usage-costs\",
					                \"Value #ram-usage-costs\",
					                \"Value #total-costs\"
					              ]
					            }
					          }
					        },
					        {
					          \"id\": \"merge\",
					          \"options\": {}
					        }
					      ],
					      \"type\": \"table\"
					    },
					    {
					      \"description\": \"Top K container cpu usage costs of latest hour\",
					      \"fieldConfig\": {
					        \"defaults\": {
					          \"custom\": {
					            \"align\": \"auto\",
					            \"displayMode\": \"auto\"
					          },
					          \"mappings\": [],
					          \"thresholds\": {
					            \"mode\": \"absolute\",
					            \"steps\": [
					              {
					                \"color\": \"green\",
					                \"value\": null
					              },
					              {
					                \"color\": \"red\",
					                \"value\": 80
					              }
					            ]
					          }
					        },
					        \"overrides\": [
					          {
					            \"matcher\": {
					              \"id\": \"byName\",
					              \"options\": \"Value #total-costs\"
					            },
					            \"properties\": [
					              {
					                \"id\": \"displayName\",
					                \"value\": \"total-costs\"
					              },
					              {
					                \"id\": \"unit\",
					                \"value\": \"currencyJPY\"
					              }
					            ]
					          },
					          {
					            \"matcher\": {
					              \"id\": \"byName\",
					              \"options\": \"Value #cpu-usage-costs\"
					            },
					            \"properties\": [
					              {
					                \"id\": \"displayName\",
					                \"value\": \"cpu-usage-costs\"
					              },
					              {
					                \"id\": \"unit\",
					                \"value\": \"currencyJPY\"
					              }
					            ]
					          },
					          {
					            \"matcher\": {
					              \"id\": \"byName\",
					              \"options\": \"Value #ram-usage-costs\"
					            },
					            \"properties\": [
					              {
					                \"id\": \"unit\",
					                \"value\": \"currencyJPY\"
					              },
					              {
					                \"id\": \"displayName\",
					                \"value\": \"ram-usage-costs\"
					              }
					            ]
					          }
					        ]
					      },
					      \"gridPos\": {
					        \"h\": 9,
					        \"w\": 24,
					        \"x\": 0,
					        \"y\": 45
					      },
					      \"id\": 21,
					      \"options\": {
					        \"footer\": {
					          \"fields\": \"\",
					          \"reducer\": [
					            \"sum\"
					          ],
					          \"show\": false
					        },
					        \"showHeader\": true
					      },
					      \"pluginVersion\": \"8.3.3\",
					      \"targets\": [
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"topk(20, sum (\\nsum(label_replace(irate(container_cpu_usage_seconds_total{container!=\\\"POD\\\", container!=\\\"\\\",image!=\\\"\\\"}[1h]), \\\"node\\\", \\\"$1\\\", \\\"instance\\\",  \\\"(.*)\\\")) by (container, pod, node, namespace) * on (node) group_left()\\n  avg(avg_over_time(node_cpu_hourly_cost[1h])) by (node)\\n) by (container, pod, node, namespace) * ($Discount/100.0) )\",
					          \"format\": \"table\",
					          \"hide\": false,
					          \"instant\": true,
					          \"interval\": \"\",
					          \"legendFormat\": \"\",
					          \"refId\": \"cpu-usage-costs\"
					        }
					      ],
					      \"title\": \"TopK Container Cpu Usage Costs Latest 1 Hour\",
					      \"transformations\": [
					        {
					          \"id\": \"filterFieldsByName\",
					          \"options\": {
					            \"include\": {
					              \"names\": [
					                \"container\",
					                \"namespace\",
					                \"node\",
					                \"pod\",
					                \"Value #cpu-usage-costs\",
					                \"Value #ram-usage-costs\",
					                \"Value #total-costs\"
					              ]
					            }
					          }
					        },
					        {
					          \"id\": \"merge\",
					          \"options\": {}
					        }
					      ],
					      \"type\": \"table\"
					    },
					    {
					      \"description\": \"Top K container costs of latest hour\",
					      \"fieldConfig\": {
					        \"defaults\": {
					          \"custom\": {
					            \"align\": \"auto\",
					            \"displayMode\": \"auto\"
					          },
					          \"mappings\": [],
					          \"thresholds\": {
					            \"mode\": \"absolute\",
					            \"steps\": [
					              {
					                \"color\": \"green\",
					                \"value\": null
					              },
					              {
					                \"color\": \"red\",
					                \"value\": 80
					              }
					            ]
					          }
					        },
					        \"overrides\": [
					          {
					            \"matcher\": {
					              \"id\": \"byName\",
					              \"options\": \"Value #total-costs\"
					            },
					            \"properties\": [
					              {
					                \"id\": \"displayName\",
					                \"value\": \"total-costs\"
					              },
					              {
					                \"id\": \"unit\",
					                \"value\": \"currencyJPY\"
					              }
					            ]
					          },
					          {
					            \"matcher\": {
					              \"id\": \"byName\",
					              \"options\": \"Value #cpu-usage-costs\"
					            },
					            \"properties\": [
					              {
					                \"id\": \"displayName\",
					                \"value\": \"cpu-usage-costs\"
					              },
					              {
					                \"id\": \"unit\",
					                \"value\": \"currencyJPY\"
					              }
					            ]
					          },
					          {
					            \"matcher\": {
					              \"id\": \"byName\",
					              \"options\": \"Value #ram-usage-costs\"
					            },
					            \"properties\": [
					              {
					                \"id\": \"unit\",
					                \"value\": \"currencyJPY\"
					              },
					              {
					                \"id\": \"displayName\",
					                \"value\": \"ram-usage-costs\"
					              }
					            ]
					          }
					        ]
					      },
					      \"gridPos\": {
					        \"h\": 9,
					        \"w\": 24,
					        \"x\": 0,
					        \"y\": 54
					      },
					      \"id\": 22,
					      \"options\": {
					        \"footer\": {
					          \"fields\": \"\",
					          \"reducer\": [
					            \"sum\"
					          ],
					          \"show\": false
					        },
					        \"showHeader\": true,
					        \"sortBy\": [
					          {
					            \"desc\": true,
					            \"displayName\": \"ram-usage-costs\"
					          }
					        ]
					      },
					      \"pluginVersion\": \"8.3.3\",
					      \"targets\": [
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"topk(20, sum (\\nsum(label_replace(irate(container_cpu_usage_seconds_total{container!=\\\"POD\\\", container!=\\\"\\\",image!=\\\"\\\"}[1h]), \\\"node\\\", \\\"$1\\\", \\\"instance\\\",  \\\"(.*)\\\")) by (container, pod, node, namespace) * on (node) group_left()\\n  avg(avg_over_time(node_cpu_hourly_cost[1h])) by (node)\\n\\n+\\n\\nsum(label_replace(avg_over_time(container_memory_working_set_bytes{container!=\\\"POD\\\",container!=\\\"\\\",image!=\\\"\\\"}[1h]), \\\"node\\\", \\\"$1\\\", \\\"instance\\\",  \\\"(.*)\\\")) by (container, pod, node, namespace) / 1024.0 / 1024.0 / 1024.0 * on (node) group_left()\\n  avg(avg_over_time(node_ram_hourly_cost[1h])) by (node)\\n) by (container, pod, node, namespace) * ($Discount/100.0))\",
					          \"format\": \"table\",
					          \"instant\": true,
					          \"interval\": \"\",
					          \"legendFormat\": \"\",
					          \"refId\": \"ram-usage-costs\"
					        }
					      ],
					      \"title\": \"TopK Container Mem Usage Costs Latest 1 Hour\",
					      \"transformations\": [
					        {
					          \"id\": \"filterFieldsByName\",
					          \"options\": {
					            \"include\": {
					              \"names\": [
					                \"container\",
					                \"namespace\",
					                \"node\",
					                \"pod\",
					                \"Value #ram-usage-costs\"
					              ]
					            }
					          }
					        },
					        {
					          \"id\": \"merge\",
					          \"options\": {}
					        }
					      ],
					      \"type\": \"table\"
					    }
					  ],
					  \"schemaVersion\": 34,
					  \"style\": \"dark\",
					  \"tags\": [],
					  \"templating\": {
					    \"list\": [
					      {
					        \"current\": {
					          \"selected\": false,
					          \"text\": \"100\",
					          \"value\": \"100\"
					        },
					        \"hide\": 0,
					        \"name\": \"Discount\",
					        \"options\": [
					          {
					            \"selected\": true,
					            \"text\": \"100\",
					            \"value\": \"100\"
					          }
					        ],
					        \"query\": \"100\",
					        \"skipUrlSync\": false,
					        \"type\": \"textbox\"
					      }
					    ]
					  },
					  \"time\": {
					    \"from\": \"now-24h\",
					    \"to\": \"now\"
					  },
					  \"timepicker\": {},
					  \"timezone\": \"\",
					  \"title\": \"Costs by Dimension\",
					  \"uid\": \"Pq1y8i07z\",
					  \"version\": 2,
					  \"weekStart\": \"\"
					}

					"""

				"namespace-costs": json: """
					{
					  \"annotations\": {
					    \"list\": [
					      {
					        \"builtIn\": 1,
					        \"datasource\": \"-- Grafana --\",
					        \"enable\": true,
					        \"hide\": true,
					        \"iconColor\": \"rgba(0, 211, 255, 1)\",
					        \"name\": \"Annotations & Alerts\",
					        \"target\": {
					          \"limit\": 100,
					          \"matchAny\": false,
					          \"tags\": [],
					          \"type\": \"dashboard\"
					        },
					        \"type\": \"dashboard\"
					      }
					    ]
					  },
					  \"description\": \"\",
					  \"editable\": true,
					  \"fiscalYearStartMonth\": 0,
					  \"graphTooltip\": 0,
					  \"id\": 6,
					  \"iteration\": 1641389211629,
					  \"links\": [],
					  \"liveNow\": false,
					  \"panels\": [
					    {
					      \"description\": \"cpu requests and usage costs given namespace ${namespace}\",
					      \"fieldConfig\": {
					        \"defaults\": {
					          \"color\": {
					            \"mode\": \"palette-classic\"
					          },
					          \"custom\": {
					            \"axisLabel\": \"\",
					            \"axisPlacement\": \"auto\",
					            \"barAlignment\": 0,
					            \"drawStyle\": \"line\",
					            \"fillOpacity\": 0,
					            \"gradientMode\": \"none\",
					            \"hideFrom\": {
					              \"legend\": false,
					              \"tooltip\": false,
					              \"viz\": false
					            },
					            \"lineInterpolation\": \"linear\",
					            \"lineWidth\": 1,
					            \"pointSize\": 5,
					            \"scaleDistribution\": {
					              \"type\": \"linear\"
					            },
					            \"showPoints\": \"auto\",
					            \"spanNulls\": false,
					            \"stacking\": {
					              \"group\": \"A\",
					              \"mode\": \"none\"
					            },
					            \"thresholdsStyle\": {
					              \"mode\": \"off\"
					            }
					          },
					          \"mappings\": [],
					          \"thresholds\": {
					            \"mode\": \"absolute\",
					            \"steps\": [
					              {
					                \"color\": \"green\"
					              },
					              {
					                \"color\": \"red\",
					                \"value\": 80
					              }
					            ]
					          },
					          \"unit\": \"currencyJPY\"
					        },
					        \"overrides\": []
					      },
					      \"gridPos\": {
					        \"h\": 9,
					        \"w\": 12,
					        \"x\": 0,
					        \"y\": 0
					      },
					      \"id\": 2,
					      \"options\": {
					        \"legend\": {
					          \"calcs\": [],
					          \"displayMode\": \"list\",
					          \"placement\": \"bottom\"
					        },
					        \"tooltip\": {
					          \"mode\": \"single\"
					        }
					      },
					      \"targets\": [
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"sum(\\n  sum(kube_pod_container_resource_requests{resource=\\\"cpu\\\", unit=\\\"core\\\", namespace=\\\"$namespace\\\"}) by (container, pod, node, namespace) \\n  * on (node) group_left()\\n  avg(\\n      avg_over_time(node_cpu_hourly_cost[1h]) * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!~\\\"eklet\\\",label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}\\n      ) by (node)\\n   ) by (node)\\n) * ($Discount/100.)\",
					          \"instant\": false,
					          \"interval\": \"1h\",
					          \"legendFormat\": \"requests-costs\",
					          \"refId\": \"A\"
					        },
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"sum(\\n  sum(label_replace(irate(container_cpu_usage_seconds_total{container!=\\\"POD\\\", container!=\\\"\\\",image!=\\\"\\\",namespace=\\\"$namespace\\\"}[1h]), \\\"node\\\", \\\"$1\\\", \\\"instance\\\",  \\\"(.*)\\\")) by (container, pod, node, namespace) \\n  * on (node) group_left()\\n  avg(\\n    avg_over_time(node_cpu_hourly_cost[1h]) * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!~\\\"eklet\\\",label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}\\n    ) by (node) \\n  ) by (node)\\n) * ($Discount/100.)\",
					          \"hide\": false,
					          \"interval\": \"1h\",
					          \"legendFormat\": \"usage-costs\",
					          \"refId\": \"B\"
					        }
					      ],
					      \"title\": \"CPU Hourly Costs Over Time By Namespace ${namespace}\",
					      \"type\": \"timeseries\"
					    },
					    {
					      \"description\": \"ram requests and usage costs given namespace ${namespace}\",
					      \"fieldConfig\": {
					        \"defaults\": {
					          \"color\": {
					            \"mode\": \"palette-classic\"
					          },
					          \"custom\": {
					            \"axisLabel\": \"\",
					            \"axisPlacement\": \"auto\",
					            \"barAlignment\": 0,
					            \"drawStyle\": \"line\",
					            \"fillOpacity\": 0,
					            \"gradientMode\": \"none\",
					            \"hideFrom\": {
					              \"legend\": false,
					              \"tooltip\": false,
					              \"viz\": false
					            },
					            \"lineInterpolation\": \"linear\",
					            \"lineWidth\": 1,
					            \"pointSize\": 5,
					            \"scaleDistribution\": {
					              \"type\": \"linear\"
					            },
					            \"showPoints\": \"auto\",
					            \"spanNulls\": false,
					            \"stacking\": {
					              \"group\": \"A\",
					              \"mode\": \"none\"
					            },
					            \"thresholdsStyle\": {
					              \"mode\": \"off\"
					            }
					          },
					          \"mappings\": [],
					          \"thresholds\": {
					            \"mode\": \"absolute\",
					            \"steps\": [
					              {
					                \"color\": \"green\"
					              },
					              {
					                \"color\": \"red\",
					                \"value\": 80
					              }
					            ]
					          },
					          \"unit\": \"currencyJPY\"
					        },
					        \"overrides\": []
					      },
					      \"gridPos\": {
					        \"h\": 9,
					        \"w\": 12,
					        \"x\": 12,
					        \"y\": 0
					      },
					      \"id\": 6,
					      \"options\": {
					        \"legend\": {
					          \"calcs\": [],
					          \"displayMode\": \"list\",
					          \"placement\": \"bottom\"
					        },
					        \"tooltip\": {
					          \"mode\": \"single\"
					        }
					      },
					      \"targets\": [
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"sum(\\n  sum(label_replace(avg_over_time(container_memory_working_set_bytes{container!=\\\"POD\\\",container!=\\\"\\\",image!=\\\"\\\",namespace=\\\"$namespace\\\"}[1h]), \\\"node\\\", \\\"$1\\\", \\\"instance\\\",  \\\"(.*)\\\")) by (container, pod, node, namespace) / 1024.0 / 1024.0 / 1024.0 \\n  * on (node) group_left()\\n  avg(\\n    avg_over_time(node_ram_hourly_cost[1h]) * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!~\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}\\n    ) by (node)\\n  ) by (node)\\n) * ($Discount/100.)\",
					          \"instant\": false,
					          \"interval\": \"1h\",
					          \"legendFormat\": \"requests-costs\",
					          \"refId\": \"A\"
					        },
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"sum(\\n  sum(kube_pod_container_resource_requests{resource=\\\"memory\\\", unit=\\\"byte\\\", namespace=\\\"$namespace\\\"} / 1024./ 1024. / 1024.) by (container, pod, node, namespace) * on (node) group_left()\\n  avg(\\n    avg_over_time(node_ram_hourly_cost[1h]) * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!~\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}\\n    ) by (node)\\n  ) by (node) \\n) * ($Discount/100.)\",
					          \"hide\": false,
					          \"interval\": \"1h\",
					          \"legendFormat\": \"usage-costs\",
					          \"refId\": \"B\"
					        }
					      ],
					      \"title\": \"RAM Hourly Costs Over Time By Namespace ${namespace}\",
					      \"type\": \"timeseries\"
					    },
					    {
					      \"description\": \"requests and usage costs given namespace ${namespace}\",
					      \"fieldConfig\": {
					        \"defaults\": {
					          \"color\": {
					            \"mode\": \"palette-classic\"
					          },
					          \"custom\": {
					            \"axisLabel\": \"\",
					            \"axisPlacement\": \"auto\",
					            \"barAlignment\": 0,
					            \"drawStyle\": \"line\",
					            \"fillOpacity\": 0,
					            \"gradientMode\": \"none\",
					            \"hideFrom\": {
					              \"legend\": false,
					              \"tooltip\": false,
					              \"viz\": false
					            },
					            \"lineInterpolation\": \"linear\",
					            \"lineWidth\": 1,
					            \"pointSize\": 5,
					            \"scaleDistribution\": {
					              \"type\": \"linear\"
					            },
					            \"showPoints\": \"auto\",
					            \"spanNulls\": false,
					            \"stacking\": {
					              \"group\": \"A\",
					              \"mode\": \"none\"
					            },
					            \"thresholdsStyle\": {
					              \"mode\": \"off\"
					            }
					          },
					          \"mappings\": [],
					          \"thresholds\": {
					            \"mode\": \"absolute\",
					            \"steps\": [
					              {
					                \"color\": \"green\"
					              },
					              {
					                \"color\": \"red\",
					                \"value\": 80
					              }
					            ]
					          },
					          \"unit\": \"currencyJPY\"
					        },
					        \"overrides\": []
					      },
					      \"gridPos\": {
					        \"h\": 9,
					        \"w\": 12,
					        \"x\": 0,
					        \"y\": 9
					      },
					      \"id\": 3,
					      \"options\": {
					        \"legend\": {
					          \"calcs\": [],
					          \"displayMode\": \"list\",
					          \"placement\": \"bottom\"
					        },
					        \"tooltip\": {
					          \"mode\": \"single\"
					        }
					      },
					      \"targets\": [
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"sum(\\n  sum(kube_pod_container_resource_requests{resource=\\\"cpu\\\", unit=\\\"core\\\", namespace=\\\"$namespace\\\"}) by (container, pod, node, namespace) \\n  * on (node) group_left()\\n  avg(\\n      avg_over_time(node_cpu_hourly_cost[1h]) * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!~\\\"eklet\\\",label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}\\n      ) by (node)\\n   ) by (node)\\n) * ($Discount/100.)\\n\\n+\\n\\nsum(\\n  sum(kube_pod_container_resource_requests{resource=\\\"memory\\\", unit=\\\"byte\\\", namespace=\\\"$namespace\\\"} / 1024./ 1024. / 1024.) by (container, pod, node, namespace) * on (node) group_left()\\n  avg(\\n    avg_over_time(node_ram_hourly_cost[1h]) * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!~\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}\\n    ) by (node)\\n  ) by (node) \\n) * ($Discount/100.)\",
					          \"instant\": false,
					          \"interval\": \"1h\",
					          \"legendFormat\": \"requests-costs\",
					          \"refId\": \"A\"
					        },
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"sum(\\n  sum(label_replace(irate(container_cpu_usage_seconds_total{container!=\\\"POD\\\", container!=\\\"\\\",image!=\\\"\\\",namespace=\\\"$namespace\\\"}[1h]), \\\"node\\\", \\\"$1\\\", \\\"instance\\\",  \\\"(.*)\\\")) by (container, pod, node, namespace) \\n  * on (node) group_left()\\n  avg(\\n    avg_over_time(node_cpu_hourly_cost[1h]) * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!~\\\"eklet\\\",label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}\\n    ) by (node) \\n  ) by (node)\\n) * ($Discount/100.)\\n+\\nsum(\\n  sum(label_replace(avg_over_time(container_memory_working_set_bytes{container!=\\\"POD\\\",container!=\\\"\\\",image!=\\\"\\\",namespace=\\\"$namespace\\\"}[1h]), \\\"node\\\", \\\"$1\\\", \\\"instance\\\",  \\\"(.*)\\\")) by (container, pod, node, namespace) / 1024.0 / 1024.0 / 1024.0 \\n  * on (node) group_left()\\n  avg(\\n    avg_over_time(node_ram_hourly_cost[1h]) * on (node) group_left() max(kube_node_labels{label_beta_kubernetes_io_instance_type!~\\\"eklet\\\", label_node_kubernetes_io_instance_type!~\\\"eklet\\\"}\\n    ) by (node)\\n  ) by (node) \\n) * ($Discount/100.)\",
					          \"hide\": false,
					          \"interval\": \"1h\",
					          \"legendFormat\": \"usage-costs\",
					          \"refId\": \"B\"
					        }
					      ],
					      \"title\": \"Hourly Costs Over Time By Namespace ${namespace}\",
					      \"type\": \"timeseries\"
					    },
					    {
					      \"description\": \"\",
					      \"fieldConfig\": {
					        \"defaults\": {
					          \"mappings\": [],
					          \"thresholds\": {
					            \"mode\": \"absolute\",
					            \"steps\": [
					              {
					                \"color\": \"green\"
					              },
					              {
					                \"color\": \"red\",
					                \"value\": 80
					              }
					            ]
					          },
					          \"unit\": \"currencyJPY\"
					        },
					        \"overrides\": []
					      },
					      \"gridPos\": {
					        \"h\": 9,
					        \"w\": 12,
					        \"x\": 12,
					        \"y\": 9
					      },
					      \"id\": 5,
					      \"options\": {
					        \"colorMode\": \"background\",
					        \"graphMode\": \"none\",
					        \"justifyMode\": \"auto\",
					        \"orientation\": \"auto\",
					        \"reduceOptions\": {
					          \"calcs\": [
					            \"lastNotNull\"
					          ],
					          \"fields\": \"\",
					          \"values\": false
					        },
					        \"textMode\": \"auto\"
					      },
					      \"pluginVersion\": \"8.3.3\",
					      \"targets\": [
					        {
					          \"datasource\": {
					            \"type\": \"prometheus\",
					            \"uid\": \"PBFA97CFB590B2093\"
					          },
					          \"exemplar\": false,
					          \"expr\": \"sum(\\n    sum_over_time(namespace:container_cpu_usage_costs_hourly:sum_rate{namespace=\\\"$namespace\\\"}[$__range]) + \\n    sum_over_time(namespace:container_memory_usage_costs_hourly:sum_rate{namespace=\\\"$namespace\\\"}[$__range])\\n) by (namespace) * ($Discount/100.0)\",
					          \"format\": \"table\",
					          \"instant\": true,
					          \"interval\": \"\",
					          \"legendFormat\": \"\",
					          \"refId\": \"A\"
					        }
					      ],
					      \"title\": \"namespace(${namespace}) total usage costs\",
					      \"type\": \"stat\"
					    }
					  ],
					  \"refresh\": \"\",
					  \"schemaVersion\": 34,
					  \"style\": \"dark\",
					  \"tags\": [],
					  \"templating\": {
					    \"list\": [
					      {
					        \"current\": {
					          \"selected\": false,
					          \"text\": \"test\",
					          \"value\": \"test\"
					        },
					        \"definition\": \"label_values(kube_namespace_created{},namespace)\",
					        \"hide\": 0,
					        \"includeAll\": false,
					        \"multi\": false,
					        \"name\": \"namespace\",
					        \"options\": [],
					        \"query\": {
					          \"query\": \"label_values(kube_namespace_created{},namespace)\",
					          \"refId\": \"StandardVariableQuery\"
					        },
					        \"refresh\": 1,
					        \"regex\": \"\",
					        \"skipUrlSync\": false,
					        \"sort\": 0,
					        \"type\": \"query\"
					      },
					      {
					        \"current\": {
					          \"selected\": true,
					          \"text\": \"100\",
					          \"value\": \"100\"
					        },
					        \"hide\": 0,
					        \"name\": \"Discount\",
					        \"options\": [
					          {
					            \"selected\": true,
					            \"text\": \"100\",
					            \"value\": \"100\"
					          }
					        ],
					        \"query\": \"100\",
					        \"skipUrlSync\": false,
					        \"type\": \"textbox\"
					      }
					    ]
					  },
					  \"time\": {
					    \"from\": \"now-12h\",
					    \"to\": \"now\"
					  },
					  \"timepicker\": {},
					  \"timezone\": \"\",
					  \"title\": \"Namespace Costs\",
					  \"uid\": \"X78y9yAnk\",
					  \"version\": 6,
					  \"weekStart\": \"\"
					}

					"""

				//     cluster-costs:
			} //     cluster-costs: //     cluster-costs:

			//       url: https://raw.githubusercontent.com/gocrane/helm-charts/main/integration/grafana/dashboards/cluster-costs.json
			//     costs-dimension:
			//       url: https://raw.githubusercontent.com/gocrane/helm-charts/main/integration/grafana/dashboards/costs-dimension.json
			//     namespace-costs:
			//       url: https://raw.githubusercontent.com/gocrane/helm-charts/main/integration/grafana/dashboards/namespace-costs.json

			"grafana.ini": {
				security: allow_embedding: true
				paths: {
					data:         "/var/lib/grafana/"
					logs:         "/var/log/grafana"
					plugins:      "/var/lib/grafana/plugins"
					provisioning: "/etc/grafana/provisioning"
				}
				analytics: check_for_updates: true
				log: mode:                    "console"
				grafana_net: url:             "https://grafana.net"
				//# grafana Authentication can be enabled with the following values on grafana.ini
				// server:
				// The full public facing url you use in browser, used for redirects and emails
				//    root_url:
				// https://grafana.com/docs/grafana/latest/auth/github/#enable-github-in-grafana
				"auth.anonymous": {
					// enable anonymous access
					enabled: true

					// specify organization name that should be used for unauthenticated users
					org_name: "Main Org."

					// specify role for unauthenticated users
					org_role: "Viewer"
				}

				"auth.proxy": {
					// Defaults to false, but set to true to enable this feature
					enabled: false
					// HTTP Header name that will contain the username or email
					header_name: "X-WEBAUTH-USER"
					// HTTP Header property, defaults to `username` but can also be `email`
					header_property: "username"
					// Set to `true` to enable auto sign up of users who do not exist in Grafana DB. Defaults to `true`.
					auto_sign_up: true
					// Define cache time to live in minutes
					// If combined with Grafana LDAP integration it is also the sync interval
					sync_ttl: 60
					// Limit where auth proxy requests come from by configuring a list of IP addresses.
					// This can be used to prevent users spoofing the X-WEBAUTH-USER header.
					// Example `whitelist = 192.168.1.1, 192.168.1.0/24, 2001::23, 2001::0/120`
					whitelist: ""
					// Optionally define more headers to sync other user attributes
					// Example `headers = Name:X-WEBAUTH-NAME Role:X-WEBAUTH-ROLE Email:X-WEBAUTH-EMAIL Groups:X-WEBAUTH-GROUPS`
					headers: ""
					// Check out docs on this for more details on the below setting
					enable_login_token: false
				}

				server: {
					serve_from_sub_path: true
					root_url:            "%(protocol)s://%(domain)s:%(http_port)s/grafana/"
				}
			}
		}
	}
}
