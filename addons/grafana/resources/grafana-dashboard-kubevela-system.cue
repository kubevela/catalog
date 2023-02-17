package main

grafanaDashboardKubevelaSystem: {
	name: "grafana-dashboard-kubevela-system"
	type: "grafana-dashboard"
	properties: {
		uid:     "kubevela-system"
		grafana: parameter.grafanaName
		data:    grafanaDashboardKubevelaSystemData
	}
}

grafanaDashboardKubevelaSystemData: #"""
	{
	  "description": "KubeVela System Overview",
	  "editable": false,
	  "links": [
	    {
	      "asDropdown": false,
	      "icon": "external link",
	      "includeVars": false,
	      "keepTime": true,
	      "tags": [
	        "kubernetes",
	        "system"
	      ],
	      "targetBlank": true,
	      "title": "Kubernetes System",
	      "tooltip": "",
	      "type": "dashboards",
	      "url": ""
	    },
	    {
	      "asDropdown": false,
	      "icon": "external link",
	      "includeVars": false,
	      "keepTime": true,
	      "tags": [
	        "kubevela",
	        "application"
	      ],
	      "targetBlank": true,
	      "title": "KubeVela Application",
	      "tooltip": "",
	      "type": "dashboards",
	      "url": ""
	    }
	  ],
	  "liveNow": false,
	  "panels": [
	    {
	      "collapsed": false,
	      "gridPos": {
	        "h": 1,
	        "w": 24,
	        "x": 0,
	        "y": 0
	      },
	      "id": 114,
	      "panels": [],
	      "title": "Overview of vela-core",
	      "type": "row"
	    },
	    {
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "description": "",
	      "fieldConfig": {
	        "defaults": {
	          "color": {
	            "mode": "thresholds"
	          },
	          "mappings": [],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "#5f5f5f",
	                "value": null
	              }
	            ]
	          }
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 6,
	        "w": 6,
	        "x": 0,
	        "y": 1
	      },
	      "id": 100,
	      "options": {
	        "colorMode": "background",
	        "graphMode": "area",
	        "justifyMode": "auto",
	        "orientation": "auto",
	        "reduceOptions": {
	          "calcs": [
	            "lastNotNull"
	          ],
	          "fields": "",
	          "values": false
	        },
	        "text": {
	          "valueSize": 64
	        },
	        "textMode": "auto"
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "prometheus_vela"
	          },
	          "expr": "sum(application_phase_number{cluster=\"local\",app_kubernetes_io_name=\"vela-core\",pod=~\"$pod\"}) or vector(0)",
	          "refId": "A"
	        }
	      ],
	      "title": "Number of Applications",
	      "type": "stat"
	    },
	    {
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "description": "",
	      "fieldConfig": {
	        "defaults": {
	          "color": {
	            "mode": "thresholds"
	          },
	          "mappings": [],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "green",
	                "value": null
	              }
	            ]
	          },
	          "unit": "none"
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 3,
	        "w": 3,
	        "x": 6,
	        "y": 1
	      },
	      "id": 110,
	      "options": {
	        "colorMode": "background",
	        "graphMode": "area",
	        "justifyMode": "auto",
	        "orientation": "auto",
	        "reduceOptions": {
	          "calcs": [
	            "lastNotNull"
	          ],
	          "fields": "",
	          "values": false
	        },
	        "text": {
	          "valueSize": 32
	        },
	        "textMode": "auto"
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "prometheus_vela"
	          },
	          "expr": "sum(application_phase_number{cluster=\"local\",app_kubernetes_io_name=\"vela-core\",phase=\"running\",pod=~\"$pod\"}) or vector(0)",
	          "refId": "A"
	        }
	      ],
	      "title": "Running",
	      "type": "stat"
	    },
	    {
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "description": "",
	      "fieldConfig": {
	        "defaults": {
	          "color": {
	            "mode": "thresholds"
	          },
	          "mappings": [],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "#5f5f5f",
	                "value": null
	              }
	            ]
	          },
	          "unit": "none"
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 3,
	        "w": 3,
	        "x": 9,
	        "y": 1
	      },
	      "id": 122,
	      "options": {
	        "colorMode": "background",
	        "graphMode": "area",
	        "justifyMode": "auto",
	        "orientation": "auto",
	        "reduceOptions": {
	          "calcs": [
	            "lastNotNull"
	          ],
	          "fields": "",
	          "values": false
	        },
	        "text": {
	          "valueSize": 32
	        },
	        "textMode": "auto"
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "prometheus_vela"
	          },
	          "expr": "sum(application_phase_number{cluster=\"local\",app_kubernetes_io_name=\"vela-core\",phase=\"runningWorkflow\",pod=~\"$pod\"}) or vector(0)",
	          "refId": "A"
	        }
	      ],
	      "title": "RunningWorkflow",
	      "type": "stat"
	    },
	    {
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "fieldConfig": {
	        "defaults": {
	          "color": {
	            "fixedColor": "rgb(31, 120, 193)",
	            "mode": "thresholds"
	          },
	          "decimals": 2,
	          "mappings": [
	            {
	              "options": {
	                "match": "null",
	                "result": {
	                  "text": "0"
	                }
	              },
	              "type": "special"
	            }
	          ],
	          "max": 1,
	          "min": 0,
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "green",
	                "value": null
	              },
	              {
	                "color": "#EAB839",
	                "value": 0.6
	              },
	              {
	                "color": "red",
	                "value": 0.8
	              }
	            ]
	          },
	          "unit": "percentunit"
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 6,
	        "w": 6,
	        "x": 12,
	        "y": 1
	      },
	      "id": 116,
	      "links": [],
	      "maxDataPoints": 100,
	      "options": {
	        "orientation": "horizontal",
	        "reduceOptions": {
	          "calcs": [
	            "lastNotNull"
	          ],
	          "fields": "",
	          "values": false
	        },
	        "showThresholdLabels": false,
	        "showThresholdMarkers": true
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "expr": "sum(rate(container_cpu_usage_seconds_total{cluster=\"local\",container=\"kubevela\",pod=~\"$pod\"}[5m])) /\nsum(container_spec_cpu_quota{cluster=\"local\",container=\"kubevela\",pod=~\"$pod\"}) * 1e5",
	          "intervalFactor": 2,
	          "refId": "A",
	          "step": 600
	        }
	      ],
	      "title": "CPU Usage",
	      "type": "gauge"
	    },
	    {
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "fieldConfig": {
	        "defaults": {
	          "color": {
	            "fixedColor": "rgb(31, 120, 193)",
	            "mode": "thresholds"
	          },
	          "decimals": 2,
	          "mappings": [
	            {
	              "options": {
	                "match": "null",
	                "result": {
	                  "text": "0"
	                }
	              },
	              "type": "special"
	            }
	          ],
	          "max": 1,
	          "min": 0,
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "green",
	                "value": null
	              },
	              {
	                "color": "#EAB839",
	                "value": 0.6
	              },
	              {
	                "color": "red",
	                "value": 0.8
	              }
	            ]
	          },
	          "unit": "percentunit"
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 6,
	        "w": 6,
	        "x": 18,
	        "y": 1
	      },
	      "id": 115,
	      "links": [],
	      "maxDataPoints": 100,
	      "options": {
	        "orientation": "horizontal",
	        "reduceOptions": {
	          "calcs": [
	            "lastNotNull"
	          ],
	          "fields": "",
	          "values": false
	        },
	        "showThresholdLabels": false,
	        "showThresholdMarkers": true,
	        "text": {}
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "expr": "sum(container_memory_working_set_bytes{cluster=\"local\",container=\"kubevela\",pod=~\"$pod\"}) / sum(container_spec_memory_limit_bytes{cluster=\"local\",container=\"kubevela\",pod=~\"$pod\"})",
	          "intervalFactor": 2,
	          "refId": "A",
	          "step": 600
	        }
	      ],
	      "title": "Memory Usage",
	      "type": "gauge"
	    },
	    {
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "description": "",
	      "fieldConfig": {
	        "defaults": {
	          "color": {
	            "mode": "thresholds"
	          },
	          "mappings": [],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "#5f5f5f",
	                "value": null
	              }
	            ]
	          },
	          "unit": "none"
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 3,
	        "w": 3,
	        "x": 6,
	        "y": 4
	      },
	      "id": 124,
	      "options": {
	        "colorMode": "background",
	        "graphMode": "area",
	        "justifyMode": "auto",
	        "orientation": "auto",
	        "reduceOptions": {
	          "calcs": [
	            "lastNotNull"
	          ],
	          "fields": "",
	          "values": false
	        },
	        "text": {
	          "valueSize": 32
	        },
	        "textMode": "auto"
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "prometheus_vela"
	          },
	          "expr": "sum(application_phase_number{cluster=\"local\",app_kubernetes_io_name=\"vela-core\",phase=\"rendering\",pod=~\"$pod\"}) or vector(0)",
	          "refId": "A"
	        }
	      ],
	      "title": "Rendering",
	      "type": "stat"
	    },
	    {
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "description": "",
	      "fieldConfig": {
	        "defaults": {
	          "color": {
	            "mode": "thresholds"
	          },
	          "mappings": [],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "#5f5f5f",
	                "value": null
	              }
	            ]
	          },
	          "unit": "none"
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 3,
	        "w": 3,
	        "x": 9,
	        "y": 4
	      },
	      "id": 123,
	      "options": {
	        "colorMode": "background",
	        "graphMode": "area",
	        "justifyMode": "auto",
	        "orientation": "auto",
	        "reduceOptions": {
	          "calcs": [
	            "lastNotNull"
	          ],
	          "fields": "",
	          "values": false
	        },
	        "text": {
	          "valueSize": 32
	        },
	        "textMode": "auto"
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "prometheus_vela"
	          },
	          "expr": "sum(application_phase_number{cluster=\"local\",app_kubernetes_io_name=\"vela-core\",phase=\"deleting\",pod=~\"$pod\"}) or vector(0)",
	          "refId": "A"
	        }
	      ],
	      "title": "Deleting",
	      "type": "stat"
	    },
	    {
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "description": "",
	      "fieldConfig": {
	        "defaults": {
	          "color": {
	            "fixedColor": "#1f78c1",
	            "mode": "fixed"
	          },
	          "mappings": [],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "#5f5f5f",
	                "value": null
	              }
	            ]
	          },
	          "unit": "none"
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 4,
	        "w": 3,
	        "x": 0,
	        "y": 7
	      },
	      "id": 121,
	      "options": {
	        "colorMode": "none",
	        "graphMode": "none",
	        "justifyMode": "auto",
	        "orientation": "auto",
	        "reduceOptions": {
	          "calcs": [
	            "lastNotNull"
	          ],
	          "fields": "",
	          "values": false
	        },
	        "text": {
	          "valueSize": 32
	        },
	        "textMode": "auto"
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "prometheus_vela"
	          },
	          "expr": "count(sum(kube_pod_container_info{cluster=\"local\",container=\"kubevela\",pod=~\"$pod\"}) by (pod))",
	          "refId": "A"
	        }
	      ],
	      "title": "Pods",
	      "type": "stat"
	    },
	    {
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "description": "",
	      "fieldConfig": {
	        "defaults": {
	          "color": {
	            "fixedColor": "#1f78c1",
	            "mode": "fixed"
	          },
	          "mappings": [],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "#5f5f5f",
	                "value": null
	              }
	            ]
	          },
	          "unit": "none"
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 4,
	        "w": 3,
	        "x": 3,
	        "y": 7
	      },
	      "id": 120,
	      "options": {
	        "colorMode": "none",
	        "graphMode": "none",
	        "justifyMode": "auto",
	        "orientation": "auto",
	        "reduceOptions": {
	          "calcs": [
	            "lastNotNull"
	          ],
	          "fields": "",
	          "values": false
	        },
	        "text": {
	          "valueSize": 32
	        },
	        "textMode": "auto"
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "prometheus_vela"
	          },
	          "expr": "count(sum(application_phase_number{cluster=\"local\",app_kubernetes_io_name=\"vela-core\",pod=~\"$pod\"}) by (controller_core_oam_dev_shard_id))",
	          "refId": "A"
	        }
	      ],
	      "title": "Shards",
	      "type": "stat"
	    },
	    {
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "fieldConfig": {
	        "defaults": {
	          "color": {
	            "fixedColor": "#1f78c1",
	            "mode": "fixed"
	          },
	          "mappings": [
	            {
	              "options": {
	                "match": "null",
	                "result": {
	                  "text": "0"
	                }
	              },
	              "type": "special"
	            }
	          ],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "green",
	                "value": null
	              }
	            ]
	          },
	          "unit": "none"
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 4,
	        "w": 3,
	        "x": 6,
	        "y": 7
	      },
	      "id": 117,
	      "links": [],
	      "maxDataPoints": 100,
	      "options": {
	        "colorMode": "none",
	        "graphMode": "none",
	        "justifyMode": "auto",
	        "orientation": "horizontal",
	        "reduceOptions": {
	          "calcs": [
	            "mean"
	          ],
	          "fields": "",
	          "values": false
	        },
	        "text": {
	          "valueSize": 32
	        },
	        "textMode": "auto"
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "expr": "sum(container_threads{cluster=\"local\",container=\"kubevela\",pod=~\"$pod\"})",
	          "intervalFactor": 2,
	          "refId": "A",
	          "step": 600
	        }
	      ],
	      "title": "Threads",
	      "type": "stat"
	    },
	    {
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "fieldConfig": {
	        "defaults": {
	          "color": {
	            "fixedColor": "rgb(31, 120, 193)",
	            "mode": "fixed"
	          },
	          "mappings": [
	            {
	              "options": {
	                "match": "null",
	                "result": {
	                  "text": "0"
	                }
	              },
	              "type": "special"
	            }
	          ],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "green",
	                "value": null
	              }
	            ]
	          },
	          "unit": "binBps"
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 4,
	        "w": 3,
	        "x": 9,
	        "y": 7
	      },
	      "id": 112,
	      "links": [],
	      "maxDataPoints": 100,
	      "options": {
	        "colorMode": "none",
	        "graphMode": "area",
	        "justifyMode": "auto",
	        "orientation": "horizontal",
	        "reduceOptions": {
	          "calcs": [
	            "mean"
	          ],
	          "fields": "",
	          "values": false
	        },
	        "text": {
	          "valueSize": 32
	        },
	        "textMode": "auto"
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "expr": "sum(sum(kube_pod_container_info{cluster=\"local\",container=\"kubevela\",pod=~\"$pod\"}) by (pod)\n* on(pod) group_right() sum(rate(container_network_receive_bytes_total[5m])) by (pod)) + \nsum(sum(kube_pod_container_info{cluster=\"local\",container=\"kubevela\",pod=~\"$pod\"}) by (pod)\n* on(pod) group_right() sum(rate(container_network_transmit_bytes_total[5m])) by (pod))",
	          "intervalFactor": 2,
	          "refId": "A",
	          "step": 600
	        }
	      ],
	      "title": "Network IO",
	      "type": "stat"
	    },
	    {
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "fieldConfig": {
	        "defaults": {
	          "color": {
	            "fixedColor": "rgb(31, 120, 193)",
	            "mode": "fixed"
	          },
	          "decimals": 2,
	          "mappings": [
	            {
	              "options": {
	                "match": "null",
	                "result": {
	                  "text": "0"
	                }
	              },
	              "type": "special"
	            }
	          ],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "green",
	                "value": null
	              }
	            ]
	          },
	          "unit": "cores"
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 4,
	        "w": 6,
	        "x": 12,
	        "y": 7
	      },
	      "id": 108,
	      "links": [],
	      "maxDataPoints": 100,
	      "options": {
	        "colorMode": "none",
	        "graphMode": "area",
	        "justifyMode": "auto",
	        "orientation": "horizontal",
	        "reduceOptions": {
	          "calcs": [
	            "mean"
	          ],
	          "fields": "",
	          "values": false
	        },
	        "text": {
	          "valueSize": 32
	        },
	        "textMode": "auto"
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "expr": "sum(rate(container_cpu_usage_seconds_total{cluster=\"local\",container=\"kubevela\",pod=~\"$pod\"}[5m]))",
	          "intervalFactor": 2,
	          "refId": "A",
	          "step": 600
	        }
	      ],
	      "title": "CPU Usage",
	      "type": "stat"
	    },
	    {
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "fieldConfig": {
	        "defaults": {
	          "color": {
	            "fixedColor": "rgb(31, 120, 193)",
	            "mode": "fixed"
	          },
	          "mappings": [
	            {
	              "options": {
	                "match": "null",
	                "result": {
	                  "text": "0"
	                }
	              },
	              "type": "special"
	            }
	          ],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "green",
	                "value": null
	              }
	            ]
	          },
	          "unit": "bytes"
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 4,
	        "w": 6,
	        "x": 18,
	        "y": 7
	      },
	      "id": 106,
	      "links": [],
	      "maxDataPoints": 100,
	      "options": {
	        "colorMode": "none",
	        "graphMode": "area",
	        "justifyMode": "auto",
	        "orientation": "horizontal",
	        "reduceOptions": {
	          "calcs": [
	            "mean"
	          ],
	          "fields": "",
	          "values": false
	        },
	        "text": {
	          "valueSize": 32
	        },
	        "textMode": "auto"
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "expr": "sum(container_memory_working_set_bytes{cluster=\"local\",container=\"kubevela\",pod=~\"$pod\"})",
	          "intervalFactor": 2,
	          "refId": "A",
	          "step": 600
	        }
	      ],
	      "title": "Memory Usage",
	      "type": "stat"
	    },
	    {
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "fieldConfig": {
	        "defaults": {
	          "color": {
	            "mode": "thresholds"
	          },
	          "custom": {
	            "align": "auto",
	            "displayMode": "color-text",
	            "inspect": false
	          },
	          "links": [],
	          "mappings": [
	            {
	              "options": {
	                "0": {
	                  "color": "green",
	                  "index": 7
	                },
	                "Running": {
	                  "color": "green",
	                  "index": 3
	                },
	                "false": {
	                  "color": "red",
	                  "index": 1,
	                  "text": "False"
	                },
	                "true": {
	                  "color": "green",
	                  "index": 0,
	                  "text": "True"
	                },
	                "unknown": {
	                  "color": "yellow",
	                  "index": 2,
	                  "text": "Unknown"
	                }
	              },
	              "type": "value"
	            },
	            {
	              "options": {
	                "pattern": "Waiting|Unknown",
	                "result": {
	                  "color": "yellow",
	                  "index": 4
	                }
	              },
	              "type": "regex"
	            },
	            {
	              "options": {
	                "pattern": "Terminated",
	                "result": {
	                  "color": "red",
	                  "index": 5
	                }
	              },
	              "type": "regex"
	            }
	          ],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "text",
	                "value": null
	              }
	            ]
	          }
	        },
	        "overrides": [
	          {
	            "matcher": {
	              "id": "byRegexp",
	              "options": "Age"
	            },
	            "properties": [
	              {
	                "id": "unit",
	                "value": "s"
	              }
	            ]
	          },
	          {
	            "matcher": {
	              "id": "byRegexp",
	              "options": "Restarts|Age|Dashboard|#Apps"
	            },
	            "properties": [
	              {
	                "id": "custom.align",
	                "value": "left"
	              }
	            ]
	          },
	          {
	            "matcher": {
	              "id": "byRegexp",
	              "options": "Age|Status|Ready|Restarts"
	            },
	            "properties": [
	              {
	                "id": "custom.width",
	                "value": 80
	              }
	            ]
	          },
	          {
	            "matcher": {
	              "id": "byRegexp",
	              "options": "Dashboard"
	            },
	            "properties": [
	              {
	                "id": "links",
	                "value": [
	                  {
	                    "targetBlank": true,
	                    "title": "Detail",
	                    "url": "/d/kubernetes-pod/kubernetes-pod?${namespace:queryparam}&${cluster:queryparam}&${datasource:queryparam}&var-pod=${__data.fields.Pod}"
	                  }
	                ]
	              },
	              {
	                "id": "mappings",
	                "value": [
	                  {
	                    "options": {
	                      "1": {
	                        "color": "yellow",
	                        "index": 0,
	                        "text": "Detail"
	                      }
	                    },
	                    "type": "value"
	                  }
	                ]
	              }
	            ]
	          },
	          {
	            "matcher": {
	              "id": "byRegexp",
	              "options": "IP|Node|Dashboard|ShardID|#Apps"
	            },
	            "properties": [
	              {
	                "id": "custom.width",
	                "value": 120
	              }
	            ]
	          },
	          {
	            "matcher": {
	              "id": "byRegexp",
	              "options": "Memory|CPU"
	            },
	            "properties": [
	              {
	                "id": "custom.width",
	                "value": 120
	              },
	              {
	                "id": "unit",
	                "value": "percentunit"
	              },
	              {
	                "id": "decimals",
	                "value": 2
	              },
	              {
	                "id": "mappings",
	                "value": [
	                  {
	                    "options": {
	                      "from": 0,
	                      "result": {
	                        "color": "green",
	                        "index": 0
	                      },
	                      "to": 0.6
	                    },
	                    "type": "range"
	                  },
	                  {
	                    "options": {
	                      "from": 0.6,
	                      "result": {
	                        "color": "yellow",
	                        "index": 1
	                      },
	                      "to": 0.8
	                    },
	                    "type": "range"
	                  },
	                  {
	                    "options": {
	                      "from": 0.8,
	                      "result": {
	                        "color": "red",
	                        "index": 2
	                      },
	                      "to": 1
	                    },
	                    "type": "range"
	                  }
	                ]
	              },
	              {
	                "id": "custom.align",
	                "value": "left"
	              }
	            ]
	          }
	        ]
	      },
	      "gridPos": {
	        "h": 6,
	        "w": 24,
	        "x": 0,
	        "y": 11
	      },
	      "id": 102,
	      "options": {
	        "footer": {
	          "fields": "",
	          "reducer": [
	            "sum"
	          ],
	          "show": false
	        },
	        "frameIndex": 0,
	        "showHeader": true
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "exemplar": false,
	          "expr": "sum(kube_pod_info{cluster=\"local\",pod=~\"$pod\"}) by (created_by_name, uid, pod, pod_ip, node) * on(pod) group_left() sum(kube_pod_container_info{cluster=\"local\",container=\"kubevela\"}) by (pod)",
	          "format": "table",
	          "hide": false,
	          "instant": true,
	          "legendFormat": "__auto",
	          "range": false,
	          "refId": "A"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "exemplar": false,
	          "expr": "sum(kube_pod_status_phase{cluster=\"local\"} * (kube_pod_status_phase{cluster=\"local\"} > 0)) by (pod, phase)",
	          "format": "table",
	          "hide": false,
	          "instant": true,
	          "legendFormat": "__auto",
	          "range": false,
	          "refId": "B"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "exemplar": false,
	          "expr": "sum(kube_pod_status_ready{cluster=\"local\"} * (kube_pod_status_ready{cluster=\"local\"} > 0)) by (pod, condition)",
	          "format": "table",
	          "hide": false,
	          "instant": true,
	          "legendFormat": "__auto",
	          "range": false,
	          "refId": "C"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "exemplar": false,
	          "expr": "time() - max(kube_pod_created{cluster=\"local\"}) by (pod)",
	          "format": "table",
	          "hide": false,
	          "instant": true,
	          "legendFormat": "__auto",
	          "range": false,
	          "refId": "D"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "exemplar": false,
	          "expr": "sum(max(kube_pod_container_status_restarts_total{cluster=\"local\"}) by (pod, container)) by (pod)",
	          "format": "table",
	          "hide": false,
	          "instant": true,
	          "range": false,
	          "refId": "E"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(container_memory_working_set_bytes{cluster=\"local\",container=\"kubevela\"}) by (pod) / sum(container_spec_memory_limit_bytes{cluster=\"local\",container=\"kubevela\"}) by (pod)",
	          "format": "table",
	          "hide": false,
	          "range": true,
	          "refId": "F"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(rate(container_cpu_usage_seconds_total{cluster=\"local\",container=\"kubevela\"}[5m])) by (pod) / sum(container_spec_cpu_quota{cluster=\"local\",container=\"kubevela\"}) by (pod) * 1e5",
	          "format": "table",
	          "hide": false,
	          "range": true,
	          "refId": "G"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(application_phase_number{cluster=\"local\"}) by (pod, controller_core_oam_dev_shard_id)",
	          "format": "table",
	          "hide": false,
	          "range": true,
	          "refId": "H"
	        }
	      ],
	      "title": "Pods",
	      "transformations": [
	        {
	          "id": "seriesToColumns",
	          "options": {
	            "byField": "pod"
	          }
	        },
	        {
	          "id": "filterByValue",
	          "options": {
	            "filters": [
	              {
	                "config": {
	                  "id": "greater",
	                  "options": {
	                    "value": 0
	                  }
	                },
	                "fieldName": "Value #A"
	              }
	            ],
	            "match": "any",
	            "type": "include"
	          }
	        },
	        {
	          "id": "organize",
	          "options": {
	            "excludeByName": {},
	            "indexByName": {
	              "Time 1": 7,
	              "Time 2": 10,
	              "Time 3": 11,
	              "Time 4": 12,
	              "Time 5": 20,
	              "Time 6": 21,
	              "Time 7": 22,
	              "Time 8": 23,
	              "Value #A": 9,
	              "Value #B": 18,
	              "Value #C": 19,
	              "Value #D": 4,
	              "Value #E": 3,
	              "Value #F": 15,
	              "Value #G": 14,
	              "Value #H": 16,
	              "condition": 1,
	              "controller_core_oam_dev_shard_id": 13,
	              "created_by_name": 8,
	              "node": 6,
	              "phase": 2,
	              "pod": 0,
	              "pod_ip": 5,
	              "uid": 17
	            },
	            "renameByName": {
	              "Value #C": "",
	              "Value #D": "Age",
	              "Value #E": "Restarts",
	              "Value #F": "Memory",
	              "Value #G": "CPU",
	              "Value #H": "#Apps",
	              "condition": "Ready",
	              "controller_core_oam_dev_shard_id": "ShardID",
	              "created_by_name": "",
	              "node": "Node",
	              "phase": "Status",
	              "pod": "Pod",
	              "pod 1": "Pod",
	              "pod 2": "",
	              "pod_ip": "IP",
	              "replicaset": "ReplicaSet",
	              "uid": "UID"
	            }
	          }
	        },
	        {
	          "id": "filterFieldsByName",
	          "options": {
	            "include": {
	              "names": [
	                "Pod",
	                "Ready",
	                "Status",
	                "Restarts",
	                "Age",
	                "IP",
	                "Node",
	                "ShardID",
	                "CPU",
	                "Memory",
	                "#Apps"
	              ]
	            }
	          }
	        },
	        {
	          "id": "calculateField",
	          "options": {
	            "alias": "Dashboard",
	            "mode": "reduceRow",
	            "reduce": {
	              "include": [
	                "Pod"
	              ],
	              "reducer": "count"
	            }
	          }
	        }
	      ],
	      "type": "table"
	    },
	    {
	      "collapsed": false,
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "gridPos": {
	        "h": 1,
	        "w": 24,
	        "x": 0,
	        "y": 17
	      },
	      "id": 56,
	      "panels": [],
	      "title": "Controller Details",
	      "type": "row"
	    },
	    {
	      "aliasColors": {},
	      "bars": false,
	      "dashLength": 10,
	      "dashes": false,
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "decimals": 2,
	      "fill": 1,
	      "fillGradient": 0,
	      "gridPos": {
	        "h": 8,
	        "w": 6,
	        "x": 0,
	        "y": 18
	      },
	      "hiddenSeries": false,
	      "id": 70,
	      "legend": {
	        "alignAsTable": true,
	        "avg": true,
	        "current": true,
	        "max": false,
	        "min": false,
	        "show": true,
	        "total": false,
	        "values": true
	      },
	      "lines": true,
	      "linewidth": 1,
	      "nullPointMode": "null",
	      "options": {
	        "alertThreshold": true
	      },
	      "percentage": false,
	      "pluginVersion": "8.5.3",
	      "pointradius": 2,
	      "points": false,
	      "renderer": "flot",
	      "seriesOverrides": [],
	      "spaceLength": 10,
	      "stack": false,
	      "steppedLine": false,
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(workqueue_depth{app_kubernetes_io_name=\"vela-core\",cluster=\"local\",pod=~\"$pod\"}) by (name)",
	          "hide": false,
	          "interval": "",
	          "legendFormat": "{{name}}",
	          "range": true,
	          "refId": "A"
	        }
	      ],
	      "thresholds": [],
	      "timeRegions": [],
	      "title": "Controller Queue",
	      "tooltip": {
	        "shared": true,
	        "sort": 0,
	        "value_type": "individual"
	      },
	      "type": "graph",
	      "xaxis": {
	        "mode": "time",
	        "show": true,
	        "values": []
	      },
	      "yaxes": [
	        {
	          "$$hashKey": "object:524",
	          "decimals": 2,
	          "format": "none",
	          "label": "count",
	          "logBase": 1,
	          "min": "0",
	          "show": true
	        },
	        {
	          "$$hashKey": "object:525",
	          "format": "short",
	          "logBase": 1,
	          "show": true
	        }
	      ],
	      "yaxis": {
	        "align": false
	      }
	    },
	    {
	      "aliasColors": {},
	      "bars": false,
	      "dashLength": 10,
	      "dashes": false,
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "decimals": 2,
	      "fill": 1,
	      "fillGradient": 0,
	      "gridPos": {
	        "h": 8,
	        "w": 6,
	        "x": 6,
	        "y": 18
	      },
	      "hiddenSeries": false,
	      "id": 71,
	      "legend": {
	        "alignAsTable": true,
	        "avg": true,
	        "current": true,
	        "max": false,
	        "min": false,
	        "show": true,
	        "total": false,
	        "values": true
	      },
	      "lines": true,
	      "linewidth": 1,
	      "nullPointMode": "null",
	      "options": {
	        "alertThreshold": true
	      },
	      "percentage": false,
	      "pluginVersion": "8.5.3",
	      "pointradius": 2,
	      "points": false,
	      "renderer": "flot",
	      "seriesOverrides": [],
	      "spaceLength": 10,
	      "stack": false,
	      "steppedLine": false,
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(rate(workqueue_adds_total{app_kubernetes_io_name=\"vela-core\",cluster=\"local\",pod=~\"$pod\"}[$rate_interval])) by (name)",
	          "hide": false,
	          "interval": "",
	          "legendFormat": "__auto",
	          "range": true,
	          "refId": "A"
	        }
	      ],
	      "thresholds": [],
	      "timeRegions": [],
	      "title": "Controller Queue Add Rate",
	      "tooltip": {
	        "shared": true,
	        "sort": 0,
	        "value_type": "individual"
	      },
	      "type": "graph",
	      "xaxis": {
	        "mode": "time",
	        "show": true,
	        "values": []
	      },
	      "yaxes": [
	        {
	          "$$hashKey": "object:604",
	          "decimals": 2,
	          "format": "none",
	          "label": "count/s",
	          "logBase": 1,
	          "show": true
	        },
	        {
	          "$$hashKey": "object:605",
	          "format": "short",
	          "logBase": 1,
	          "min": "0",
	          "show": true
	        }
	      ],
	      "yaxis": {
	        "align": false
	      }
	    },
	    {
	      "aliasColors": {},
	      "bars": false,
	      "dashLength": 10,
	      "dashes": false,
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "decimals": 2,
	      "fill": 1,
	      "fillGradient": 0,
	      "gridPos": {
	        "h": 8,
	        "w": 6,
	        "x": 12,
	        "y": 18
	      },
	      "hiddenSeries": false,
	      "id": 68,
	      "legend": {
	        "alignAsTable": true,
	        "avg": true,
	        "current": true,
	        "max": false,
	        "min": false,
	        "show": true,
	        "sort": "avg",
	        "sortDesc": true,
	        "total": false,
	        "values": true
	      },
	      "lines": true,
	      "linewidth": 1,
	      "nullPointMode": "null",
	      "options": {
	        "alertThreshold": true
	      },
	      "percentage": false,
	      "pluginVersion": "8.5.3",
	      "pointradius": 2,
	      "points": false,
	      "renderer": "flot",
	      "seriesOverrides": [],
	      "spaceLength": 10,
	      "stack": false,
	      "steppedLine": false,
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(rate(controller_runtime_reconcile_total{app_kubernetes_io_name=\"vela-core\",cluster=\"local\",pod=~\"$pod\"}[$rate_interval])) by (result, controller)",
	          "legendFormat": "{{result}}: {{controller}}",
	          "range": true,
	          "refId": "A"
	        }
	      ],
	      "thresholds": [],
	      "timeRegions": [],
	      "title": "Reconcile Rate",
	      "tooltip": {
	        "shared": true,
	        "sort": 0,
	        "value_type": "individual"
	      },
	      "type": "graph",
	      "xaxis": {
	        "mode": "time",
	        "show": true,
	        "values": []
	      },
	      "yaxes": [
	        {
	          "$$hashKey": "object:684",
	          "decimals": 2,
	          "format": "none",
	          "label": "count/s",
	          "logBase": 1,
	          "min": "0",
	          "show": true
	        },
	        {
	          "$$hashKey": "object:685",
	          "format": "short",
	          "logBase": 1,
	          "min": "0",
	          "show": true
	        }
	      ],
	      "yaxis": {
	        "align": false
	      }
	    },
	    {
	      "aliasColors": {},
	      "bars": false,
	      "dashLength": 10,
	      "dashes": false,
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "decimals": 2,
	      "fieldConfig": {
	        "defaults": {
	          "unit": "s"
	        },
	        "overrides": []
	      },
	      "fill": 1,
	      "fillGradient": 0,
	      "gridPos": {
	        "h": 8,
	        "w": 6,
	        "x": 18,
	        "y": 18
	      },
	      "hiddenSeries": false,
	      "id": 69,
	      "legend": {
	        "alignAsTable": true,
	        "avg": true,
	        "current": true,
	        "max": false,
	        "min": false,
	        "show": true,
	        "sort": "avg",
	        "sortDesc": true,
	        "total": false,
	        "values": true
	      },
	      "lines": true,
	      "linewidth": 1,
	      "nullPointMode": "null",
	      "options": {
	        "alertThreshold": true
	      },
	      "percentage": false,
	      "pluginVersion": "8.5.3",
	      "pointradius": 2,
	      "points": false,
	      "renderer": "flot",
	      "seriesOverrides": [],
	      "spaceLength": 10,
	      "stack": false,
	      "steppedLine": false,
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(rate(controller_runtime_reconcile_time_seconds_sum{app_kubernetes_io_name=\"vela-core\",cluster=\"local\",pod=~\"$pod\"}[$rate_interval])) by (controller) / sum(rate(controller_runtime_reconcile_time_seconds_count{app_kubernetes_io_name=\"vela-core\",cluster=\"local\",pod=~\"$pod\"}[$rate_interval])) by (controller)",
	          "hide": false,
	          "legendFormat": "{{controller}}",
	          "range": true,
	          "refId": "A"
	        }
	      ],
	      "thresholds": [],
	      "timeRegions": [],
	      "title": "Average Reconcile Time",
	      "tooltip": {
	        "shared": true,
	        "sort": 0,
	        "value_type": "individual"
	      },
	      "type": "graph",
	      "xaxis": {
	        "mode": "time",
	        "show": true,
	        "values": []
	      },
	      "yaxes": [
	        {
	          "$$hashKey": "object:764",
	          "decimals": 2,
	          "format": "s",
	          "label": "",
	          "logBase": 1,
	          "show": true
	        },
	        {
	          "$$hashKey": "object:765",
	          "format": "short",
	          "logBase": 1,
	          "show": true
	        }
	      ],
	      "yaxis": {
	        "align": false
	      }
	    },
	    {
	      "aliasColors": {},
	      "bars": false,
	      "dashLength": 10,
	      "dashes": false,
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "decimals": 2,
	      "fieldConfig": {
	        "defaults": {
	          "unit": "s"
	        },
	        "overrides": []
	      },
	      "fill": 1,
	      "fillGradient": 0,
	      "gridPos": {
	        "h": 8,
	        "w": 6,
	        "x": 0,
	        "y": 26
	      },
	      "hiddenSeries": false,
	      "id": 85,
	      "legend": {
	        "alignAsTable": true,
	        "avg": true,
	        "current": true,
	        "max": false,
	        "min": false,
	        "show": true,
	        "total": false,
	        "values": true
	      },
	      "lines": true,
	      "linewidth": 1,
	      "nullPointMode": "null",
	      "options": {
	        "alertThreshold": true
	      },
	      "percentage": false,
	      "pluginVersion": "8.5.3",
	      "pointradius": 2,
	      "points": false,
	      "renderer": "flot",
	      "seriesOverrides": [],
	      "spaceLength": 10,
	      "stack": false,
	      "steppedLine": false,
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(rate(controller_runtime_reconcile_time_seconds_sum{controller=\"application\",app_kubernetes_io_name=\"vela-core\",cluster=\"local\",pod=~\"$pod\"}[$rate_interval])) / sum(rate(controller_runtime_reconcile_time_seconds_count{controller=\"application\",app_kubernetes_io_name=\"vela-core\",cluster=\"local\",pod=~\"$pod\"}[$rate_interval]))",
	          "hide": false,
	          "legendFormat": "avg",
	          "range": true,
	          "refId": "A"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "histogram_quantile(0.95, sum(rate(controller_runtime_reconcile_time_seconds_bucket{controller=\"application\",app_kubernetes_io_name=\"vela-core\"}[$rate_interval])) by (le))",
	          "hide": false,
	          "legendFormat": "p95",
	          "range": true,
	          "refId": "B"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "histogram_quantile(0.75, sum(rate(controller_runtime_reconcile_time_seconds_bucket{controller=\"application\",app_kubernetes_io_name=\"vela-core\"}[$rate_interval])) by (le))",
	          "hide": false,
	          "legendFormat": "p75",
	          "range": true,
	          "refId": "C"
	        }
	      ],
	      "thresholds": [],
	      "timeRegions": [],
	      "title": "Reconcile Time",
	      "tooltip": {
	        "shared": true,
	        "sort": 0,
	        "value_type": "individual"
	      },
	      "type": "graph",
	      "xaxis": {
	        "mode": "time",
	        "show": true,
	        "values": []
	      },
	      "yaxes": [
	        {
	          "$$hashKey": "object:764",
	          "decimals": 2,
	          "format": "s",
	          "logBase": 1,
	          "show": true
	        },
	        {
	          "$$hashKey": "object:765",
	          "format": "short",
	          "logBase": 1,
	          "show": true
	        }
	      ],
	      "yaxis": {
	        "align": false
	      }
	    },
	    {
	      "aliasColors": {},
	      "bars": false,
	      "dashLength": 10,
	      "dashes": false,
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "decimals": 2,
	      "fieldConfig": {
	        "defaults": {
	          "unit": "s"
	        },
	        "overrides": []
	      },
	      "fill": 1,
	      "fillGradient": 0,
	      "gridPos": {
	        "h": 8,
	        "w": 6,
	        "x": 6,
	        "y": 26
	      },
	      "hiddenSeries": false,
	      "id": 76,
	      "legend": {
	        "alignAsTable": true,
	        "avg": true,
	        "current": true,
	        "max": false,
	        "min": false,
	        "rightSide": false,
	        "show": true,
	        "sort": "avg",
	        "sortDesc": true,
	        "total": false,
	        "values": true
	      },
	      "lines": true,
	      "linewidth": 1,
	      "nullPointMode": "null",
	      "options": {
	        "alertThreshold": true
	      },
	      "percentage": false,
	      "pluginVersion": "8.5.3",
	      "pointradius": 2,
	      "points": false,
	      "renderer": "flot",
	      "seriesOverrides": [],
	      "spaceLength": 10,
	      "stack": false,
	      "steppedLine": false,
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(rate(create_app_handler_time_seconds_sum{app_kubernetes_io_name=\"vela-core\",cluster=\"local\",pod=~\"$pod\"}[$rate_interval])) / sum(rate(create_app_handler_time_seconds_count{app_kubernetes_io_name=\"vela-core\",cluster=\"local\",pod=~\"$pod\"}[$rate_interval]))",
	          "hide": false,
	          "legendFormat": "CreateAppHandler",
	          "range": true,
	          "refId": "A"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(rate(handle_finalizers_time_seconds_sum{app_kubernetes_io_name=\"vela-core\",cluster=\"local\",pod=~\"$pod\"}[$rate_interval])) / sum(rate(handle_finalizers_time_seconds_count{app_kubernetes_io_name=\"vela-core\",cluster=\"local\",pod=~\"$pod\"}[$rate_interval]))",
	          "hide": false,
	          "legendFormat": "HandleFinalizers",
	          "range": true,
	          "refId": "B"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(rate(parse_appFile_time_seconds_sum{app_kubernetes_io_name=\"vela-core\",cluster=\"local\",pod=~\"$pod\"}[$rate_interval])) / sum(rate(parse_appFile_time_seconds_count{app_kubernetes_io_name=\"vela-core\",cluster=\"local\",pod=~\"$pod\"}[$rate_interval]))",
	          "hide": false,
	          "legendFormat": "ParseAppFile",
	          "range": true,
	          "refId": "C"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(rate(prepare_current_appRevision_time_seconds_sum{app_kubernetes_io_name=\"vela-core\",cluster=\"local\",pod=~\"$pod\"}[$rate_interval])) / sum(rate(prepare_current_appRevision_time_seconds_count{app_kubernetes_io_name=\"vela-core\",cluster=\"local\",pod=~\"$pod\"}[$rate_interval]))",
	          "hide": false,
	          "legendFormat": "PrepareCurrentAppRevision",
	          "range": true,
	          "refId": "D"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(rate(apply_appRevision_time_seconds_sum{app_kubernetes_io_name=\"vela-core\",cluster=\"local\",pod=~\"$pod\"}[$rate_interval])) / sum(rate(apply_appRevision_time_seconds_count{app_kubernetes_io_name=\"vela-core\",cluster=\"local\",pod=~\"$pod\"}[$rate_interval]))",
	          "hide": false,
	          "legendFormat": "ApplyAppRevision",
	          "range": true,
	          "refId": "E"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(rate(apply_policies_sum{app_kubernetes_io_name=\"vela-core\",cluster=\"local\",pod=~\"$pod\"}[$rate_interval])) / sum(rate(apply_policies_count{app_kubernetes_io_name=\"vela-core\",cluster=\"local\",pod=~\"$pod\"}[$rate_interval]))",
	          "hide": false,
	          "legendFormat": "ApplyPolicies",
	          "range": true,
	          "refId": "F"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(rate(gc_resourceTrackers_time_seconds_sum{app_kubernetes_io_name=\"vela-core\",stage=\"-\",cluster=\"local\",pod=~\"$pod\"}[$rate_interval])) / sum(rate(gc_resourceTrackers_time_seconds_count{app_kubernetes_io_name=\"vela-core\",stage=\"-\",cluster=\"local\",pod=~\"$pod\"}[$rate_interval]))",
	          "hide": false,
	          "legendFormat": "GCResourceTrackers",
	          "range": true,
	          "refId": "G"
	        }
	      ],
	      "thresholds": [],
	      "timeRegions": [],
	      "title": "Reconcile Stage Time",
	      "tooltip": {
	        "shared": true,
	        "sort": 0,
	        "value_type": "individual"
	      },
	      "type": "graph",
	      "xaxis": {
	        "mode": "time",
	        "show": true,
	        "values": []
	      },
	      "yaxes": [
	        {
	          "$$hashKey": "object:918",
	          "decimals": 2,
	          "format": "s",
	          "logBase": 1,
	          "show": true
	        },
	        {
	          "$$hashKey": "object:919",
	          "format": "short",
	          "logBase": 1,
	          "show": true
	        }
	      ],
	      "yaxis": {
	        "align": false
	      }
	    },
	    {
	      "aliasColors": {},
	      "bars": false,
	      "dashLength": 10,
	      "dashes": false,
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "decimals": 2,
	      "fieldConfig": {
	        "defaults": {
	          "unit": "reqps"
	        },
	        "overrides": []
	      },
	      "fill": 1,
	      "fillGradient": 0,
	      "gridPos": {
	        "h": 8,
	        "w": 6,
	        "x": 12,
	        "y": 26
	      },
	      "hiddenSeries": false,
	      "id": 75,
	      "legend": {
	        "alignAsTable": true,
	        "avg": true,
	        "current": true,
	        "max": false,
	        "min": false,
	        "rightSide": false,
	        "show": true,
	        "sort": "avg",
	        "sortDesc": true,
	        "total": false,
	        "values": true
	      },
	      "lines": true,
	      "linewidth": 1,
	      "nullPointMode": "null",
	      "options": {
	        "alertThreshold": true
	      },
	      "percentage": false,
	      "pluginVersion": "8.5.3",
	      "pointradius": 2,
	      "points": false,
	      "renderer": "flot",
	      "seriesOverrides": [],
	      "spaceLength": 10,
	      "stack": false,
	      "steppedLine": false,
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(rate(kubevela_controller_client_request_time_seconds_count{app_kubernetes_io_name=\"vela-core\",cluster=\"local\",pod=~\"$pod\"}[$rate_interval])) by (Kind, verb)",
	          "hide": false,
	          "legendFormat": "{{verb}}: {{Kind}}",
	          "range": true,
	          "refId": "A"
	        }
	      ],
	      "thresholds": [],
	      "timeRegions": [],
	      "title": "Client Request Throughput",
	      "tooltip": {
	        "shared": true,
	        "sort": 0,
	        "value_type": "individual"
	      },
	      "type": "graph",
	      "xaxis": {
	        "mode": "time",
	        "show": true,
	        "values": []
	      },
	      "yaxes": [
	        {
	          "$$hashKey": "object:998",
	          "decimals": 2,
	          "format": "reqps",
	          "logBase": 1,
	          "show": true
	        },
	        {
	          "$$hashKey": "object:999",
	          "format": "short",
	          "logBase": 1,
	          "show": true
	        }
	      ],
	      "yaxis": {
	        "align": false
	      }
	    },
	    {
	      "aliasColors": {},
	      "bars": false,
	      "dashLength": 10,
	      "dashes": false,
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "decimals": 2,
	      "description": "",
	      "fieldConfig": {
	        "defaults": {
	          "unit": "s"
	        },
	        "overrides": []
	      },
	      "fill": 1,
	      "fillGradient": 0,
	      "gridPos": {
	        "h": 8,
	        "w": 6,
	        "x": 18,
	        "y": 26
	      },
	      "hiddenSeries": false,
	      "id": 74,
	      "legend": {
	        "alignAsTable": true,
	        "avg": true,
	        "current": true,
	        "max": false,
	        "min": false,
	        "rightSide": false,
	        "show": true,
	        "sort": "avg",
	        "sortDesc": true,
	        "total": false,
	        "values": true
	      },
	      "lines": true,
	      "linewidth": 1,
	      "nullPointMode": "null",
	      "options": {
	        "alertThreshold": true
	      },
	      "percentage": false,
	      "pluginVersion": "8.5.3",
	      "pointradius": 2,
	      "points": false,
	      "renderer": "flot",
	      "seriesOverrides": [],
	      "spaceLength": 10,
	      "stack": false,
	      "steppedLine": false,
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(rate(kubevela_controller_client_request_time_seconds_sum{app_kubernetes_io_name=\"vela-core\",cluster=\"local\",pod=~\"$pod\"}[$rate_interval])) by (Kind, verb) / sum(rate(kubevela_controller_client_request_time_seconds_count{app_kubernetes_io_name=\"vela-core\",cluster=\"local\",pod=~\"$pod\"}[$rate_interval])) by (Kind, verb)",
	          "hide": false,
	          "legendFormat": "{{verb}}: {{Kind}}",
	          "range": true,
	          "refId": "A"
	        }
	      ],
	      "thresholds": [],
	      "timeRegions": [],
	      "title": "Client Request Avg Time",
	      "tooltip": {
	        "shared": true,
	        "sort": 0,
	        "value_type": "individual"
	      },
	      "type": "graph",
	      "xaxis": {
	        "mode": "time",
	        "show": true,
	        "values": []
	      },
	      "yaxes": [
	        {
	          "$$hashKey": "object:1078",
	          "decimals": 2,
	          "format": "s",
	          "logBase": 1,
	          "show": true
	        },
	        {
	          "$$hashKey": "object:1079",
	          "decimals": 2,
	          "format": "short",
	          "logBase": 1,
	          "show": true
	        }
	      ],
	      "yaxis": {
	        "align": false
	      }
	    },
	    {
	      "collapsed": false,
	      "gridPos": {
	        "h": 1,
	        "w": 24,
	        "x": 0,
	        "y": 34
	      },
	      "id": 66,
	      "panels": [],
	      "title": "Application",
	      "type": "row"
	    },
	    {
	      "aliasColors": {},
	      "bars": false,
	      "dashLength": 10,
	      "dashes": false,
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "fieldConfig": {
	        "defaults": {
	          "unit": "short"
	        },
	        "overrides": []
	      },
	      "fill": 1,
	      "fillGradient": 0,
	      "gridPos": {
	        "h": 8,
	        "w": 4,
	        "x": 0,
	        "y": 35
	      },
	      "hiddenSeries": false,
	      "id": 60,
	      "legend": {
	        "alignAsTable": true,
	        "avg": false,
	        "current": true,
	        "max": false,
	        "min": false,
	        "show": true,
	        "total": false,
	        "values": true
	      },
	      "lines": true,
	      "linewidth": 1,
	      "nullPointMode": "null",
	      "options": {
	        "alertThreshold": true
	      },
	      "percentage": false,
	      "pluginVersion": "8.5.3",
	      "pointradius": 2,
	      "points": false,
	      "renderer": "flot",
	      "seriesOverrides": [],
	      "spaceLength": 10,
	      "stack": false,
	      "steppedLine": false,
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(application_phase_number{app_kubernetes_io_name=\"vela-core\",cluster=\"local\",pod=~\"$pod\"})",
	          "hide": false,
	          "interval": "",
	          "legendFormat": "All",
	          "range": true,
	          "refId": "B"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(application_phase_number{app_kubernetes_io_name=\"vela-core\",cluster=\"local\",pod=~\"$pod\"}) by (phase)",
	          "interval": "",
	          "legendFormat": "Phase: {{phase}}",
	          "range": true,
	          "refId": "A"
	        }
	      ],
	      "thresholds": [],
	      "timeRegions": [],
	      "title": "Number of Applications",
	      "tooltip": {
	        "shared": true,
	        "sort": 0,
	        "value_type": "individual"
	      },
	      "type": "graph",
	      "xaxis": {
	        "mode": "time",
	        "show": true,
	        "values": []
	      },
	      "yaxes": [
	        {
	          "$$hashKey": "object:50",
	          "format": "short",
	          "logBase": 1,
	          "show": true
	        },
	        {
	          "$$hashKey": "object:51",
	          "format": "short",
	          "logBase": 1,
	          "show": true
	        }
	      ],
	      "yaxis": {
	        "align": false
	      }
	    },
	    {
	      "aliasColors": {},
	      "bars": false,
	      "dashLength": 10,
	      "dashes": false,
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "fieldConfig": {
	        "defaults": {
	          "unit": "short"
	        },
	        "overrides": []
	      },
	      "fill": 1,
	      "fillGradient": 0,
	      "gridPos": {
	        "h": 8,
	        "w": 5,
	        "x": 4,
	        "y": 35
	      },
	      "hiddenSeries": false,
	      "id": 61,
	      "legend": {
	        "alignAsTable": true,
	        "avg": false,
	        "current": true,
	        "max": false,
	        "min": false,
	        "show": true,
	        "total": false,
	        "values": true
	      },
	      "lines": true,
	      "linewidth": 1,
	      "nullPointMode": "null",
	      "options": {
	        "alertThreshold": true
	      },
	      "percentage": false,
	      "pluginVersion": "8.5.3",
	      "pointradius": 2,
	      "points": false,
	      "renderer": "flot",
	      "seriesOverrides": [],
	      "spaceLength": 10,
	      "stack": false,
	      "steppedLine": false,
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(workflow_step_phase_number{app_kubernetes_io_name=\"vela-core\",cluster=\"local\",pod=~\"$pod\"})",
	          "hide": false,
	          "interval": "",
	          "legendFormat": "All",
	          "range": true,
	          "refId": "B"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(workflow_step_phase_number{app_kubernetes_io_name=\"vela-core\",cluster=\"local\",pod=~\"$pod\"}) by (step_type)",
	          "interval": "",
	          "legendFormat": "Type: {{step_type}}",
	          "range": true,
	          "refId": "A"
	        }
	      ],
	      "thresholds": [],
	      "timeRegions": [],
	      "title": "Number of Steps",
	      "tooltip": {
	        "shared": true,
	        "sort": 0,
	        "value_type": "individual"
	      },
	      "type": "graph",
	      "xaxis": {
	        "mode": "time",
	        "show": true,
	        "values": []
	      },
	      "yaxes": [
	        {
	          "$$hashKey": "object:130",
	          "format": "short",
	          "logBase": 1,
	          "show": true
	        },
	        {
	          "$$hashKey": "object:131",
	          "format": "short",
	          "logBase": 1,
	          "show": true
	        }
	      ],
	      "yaxis": {
	        "align": false
	      }
	    },
	    {
	      "aliasColors": {},
	      "bars": false,
	      "dashLength": 10,
	      "dashes": false,
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "fieldConfig": {
	        "defaults": {
	          "unit": "short"
	        },
	        "overrides": []
	      },
	      "fill": 1,
	      "fillGradient": 0,
	      "gridPos": {
	        "h": 8,
	        "w": 5,
	        "x": 9,
	        "y": 35
	      },
	      "hiddenSeries": false,
	      "id": 62,
	      "legend": {
	        "alignAsTable": true,
	        "avg": false,
	        "current": true,
	        "max": false,
	        "min": false,
	        "show": true,
	        "total": false,
	        "values": true
	      },
	      "lines": true,
	      "linewidth": 1,
	      "nullPointMode": "null",
	      "options": {
	        "alertThreshold": true
	      },
	      "percentage": false,
	      "pluginVersion": "8.5.3",
	      "pointradius": 2,
	      "points": false,
	      "renderer": "flot",
	      "seriesOverrides": [],
	      "spaceLength": 10,
	      "stack": false,
	      "steppedLine": false,
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(workflow_step_phase_number{app_kubernetes_io_name=\"vela-core\",cluster=\"local\",pod=~\"$pod\"}) by (phase)",
	          "hide": false,
	          "interval": "",
	          "legendFormat": "Status: {{phase}}",
	          "range": true,
	          "refId": "B"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(workflow_step_phase_number{app_kubernetes_io_name=\"vela-core\",cluster=\"local\",pod=~\"$pod\"}) by (step_type, phase)",
	          "interval": "",
	          "legendFormat": "{{step_type}}: {{phase}}",
	          "range": true,
	          "refId": "A"
	        }
	      ],
	      "thresholds": [],
	      "timeRegions": [],
	      "title": "StepStatus Distribution",
	      "tooltip": {
	        "shared": true,
	        "sort": 0,
	        "value_type": "individual"
	      },
	      "type": "graph",
	      "xaxis": {
	        "mode": "time",
	        "show": true,
	        "values": []
	      },
	      "yaxes": [
	        {
	          "$$hashKey": "object:210",
	          "format": "short",
	          "logBase": 1,
	          "show": true
	        },
	        {
	          "$$hashKey": "object:211",
	          "format": "short",
	          "logBase": 1,
	          "show": true
	        }
	      ],
	      "yaxis": {
	        "align": false
	      }
	    },
	    {
	      "aliasColors": {},
	      "bars": false,
	      "dashLength": 10,
	      "dashes": false,
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "fieldConfig": {
	        "defaults": {
	          "unit": "cps"
	        },
	        "overrides": []
	      },
	      "fill": 1,
	      "fillGradient": 0,
	      "gridPos": {
	        "h": 8,
	        "w": 5,
	        "x": 14,
	        "y": 35
	      },
	      "hiddenSeries": false,
	      "id": 63,
	      "legend": {
	        "alignAsTable": true,
	        "avg": false,
	        "current": true,
	        "max": false,
	        "min": false,
	        "show": true,
	        "total": false,
	        "values": true
	      },
	      "lines": true,
	      "linewidth": 1,
	      "nullPointMode": "null",
	      "options": {
	        "alertThreshold": true
	      },
	      "percentage": false,
	      "pluginVersion": "8.5.3",
	      "pointradius": 2,
	      "points": false,
	      "renderer": "flot",
	      "seriesOverrides": [],
	      "spaceLength": 10,
	      "stack": false,
	      "steppedLine": false,
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(rate(workflow_initialized_num{app_kubernetes_io_name=\"vela-core\",cluster=\"local\",pod=~\"$pod\"}[$rate_interval]))",
	          "hide": false,
	          "interval": "",
	          "legendFormat": "Initialize Rate",
	          "range": true,
	          "refId": "A"
	        }
	      ],
	      "thresholds": [],
	      "timeRegions": [],
	      "title": "Workflow Initialize Rate",
	      "tooltip": {
	        "shared": true,
	        "sort": 0,
	        "value_type": "individual"
	      },
	      "type": "graph",
	      "xaxis": {
	        "mode": "time",
	        "show": true,
	        "values": []
	      },
	      "yaxes": [
	        {
	          "$$hashKey": "object:290",
	          "format": "cps",
	          "logBase": 1,
	          "min": "0",
	          "show": true
	        },
	        {
	          "$$hashKey": "object:291",
	          "format": "short",
	          "logBase": 1,
	          "show": true
	        }
	      ],
	      "yaxis": {
	        "align": false
	      }
	    },
	    {
	      "aliasColors": {},
	      "bars": false,
	      "dashLength": 10,
	      "dashes": false,
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "fieldConfig": {
	        "defaults": {
	          "unit": "s"
	        },
	        "overrides": []
	      },
	      "fill": 1,
	      "fillGradient": 0,
	      "gridPos": {
	        "h": 8,
	        "w": 5,
	        "x": 19,
	        "y": 35
	      },
	      "hiddenSeries": false,
	      "id": 64,
	      "legend": {
	        "alignAsTable": true,
	        "avg": true,
	        "current": true,
	        "max": false,
	        "min": false,
	        "show": true,
	        "total": false,
	        "values": true
	      },
	      "lines": true,
	      "linewidth": 1,
	      "nullPointMode": "null",
	      "options": {
	        "alertThreshold": true
	      },
	      "percentage": false,
	      "pluginVersion": "8.5.3",
	      "pointradius": 2,
	      "points": false,
	      "renderer": "flot",
	      "seriesOverrides": [],
	      "spaceLength": 10,
	      "stack": false,
	      "steppedLine": false,
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(rate(workflow_finished_time_seconds_sum{app_kubernetes_io_name=\"vela-core\",cluster=\"local\",pod=~\"$pod\"}[$rate_interval])) by (phase) / sum(rate(workflow_finished_time_seconds_count{app_kubernetes_io_name=\"vela-core\",cluster=\"local\",pod=~\"$pod\"}[$rate_interval])) by (phase)",
	          "hide": false,
	          "interval": "",
	          "legendFormat": "{{phase}}",
	          "range": true,
	          "refId": "B"
	        }
	      ],
	      "thresholds": [],
	      "timeRegions": [],
	      "title": "Workflow Average Complete Time",
	      "tooltip": {
	        "shared": true,
	        "sort": 0,
	        "value_type": "individual"
	      },
	      "type": "graph",
	      "xaxis": {
	        "mode": "time",
	        "show": true,
	        "values": []
	      },
	      "yaxes": [
	        {
	          "$$hashKey": "object:444",
	          "format": "s",
	          "logBase": 1,
	          "min": "0",
	          "show": true
	        },
	        {
	          "$$hashKey": "object:445",
	          "format": "short",
	          "logBase": 1,
	          "show": true
	        }
	      ],
	      "yaxis": {
	        "align": false
	      }
	    },
	    {
	      "collapsed": true,
	      "gridPos": {
	        "h": 1,
	        "w": 24,
	        "x": 0,
	        "y": 43
	      },
	      "id": 133,
	      "panels": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "fieldConfig": {
	            "defaults": {
	              "color": {
	                "mode": "palette-classic"
	              },
	              "custom": {
	                "axisLabel": "",
	                "axisPlacement": "auto",
	                "barAlignment": 0,
	                "drawStyle": "line",
	                "fillOpacity": 0,
	                "gradientMode": "none",
	                "hideFrom": {
	                  "legend": false,
	                  "tooltip": false,
	                  "viz": false
	                },
	                "lineInterpolation": "linear",
	                "lineWidth": 1,
	                "pointSize": 5,
	                "scaleDistribution": {
	                  "type": "linear"
	                },
	                "showPoints": "auto",
	                "spanNulls": false,
	                "stacking": {
	                  "group": "A",
	                  "mode": "none"
	                },
	                "thresholdsStyle": {
	                  "mode": "off"
	                }
	              },
	              "decimals": 2,
	              "mappings": [],
	              "thresholds": {
	                "mode": "absolute",
	                "steps": [
	                  {
	                    "color": "green",
	                    "value": null
	                  }
	                ]
	              },
	              "unit": "s"
	            },
	            "overrides": []
	          },
	          "gridPos": {
	            "h": 7,
	            "w": 6,
	            "x": 0,
	            "y": 1
	          },
	          "id": 128,
	          "options": {
	            "legend": {
	              "calcs": [
	                "mean",
	                "lastNotNull"
	              ],
	              "displayMode": "table",
	              "placement": "bottom"
	            },
	            "tooltip": {
	              "mode": "single",
	              "sort": "none"
	            }
	          },
	          "targets": [
	            {
	              "datasource": {
	                "type": "prometheus",
	                "uid": "prometheus_vela"
	              },
	              "editorMode": "code",
	              "expr": "sum(rate(ocm_proxy_proxied_request_duration_seconds_sum[$rate_interval])) by (verb, resource) / sum(rate(ocm_proxy_proxied_request_duration_seconds_count[$rate_interval])) by (verb, resource)",
	              "legendFormat": "{{verb}} {{resource}}",
	              "range": true,
	              "refId": "A"
	            }
	          ],
	          "title": "Avg Latency (by verb & resource)",
	          "type": "timeseries"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "fieldConfig": {
	            "defaults": {
	              "color": {
	                "mode": "palette-classic"
	              },
	              "custom": {
	                "axisLabel": "",
	                "axisPlacement": "auto",
	                "barAlignment": 0,
	                "drawStyle": "line",
	                "fillOpacity": 0,
	                "gradientMode": "none",
	                "hideFrom": {
	                  "legend": false,
	                  "tooltip": false,
	                  "viz": false
	                },
	                "lineInterpolation": "linear",
	                "lineWidth": 1,
	                "pointSize": 5,
	                "scaleDistribution": {
	                  "type": "linear"
	                },
	                "showPoints": "auto",
	                "spanNulls": false,
	                "stacking": {
	                  "group": "A",
	                  "mode": "none"
	                },
	                "thresholdsStyle": {
	                  "mode": "off"
	                }
	              },
	              "decimals": 2,
	              "mappings": [],
	              "thresholds": {
	                "mode": "absolute",
	                "steps": [
	                  {
	                    "color": "green",
	                    "value": null
	                  }
	                ]
	              },
	              "unit": "qps"
	            },
	            "overrides": []
	          },
	          "gridPos": {
	            "h": 7,
	            "w": 6,
	            "x": 6,
	            "y": 1
	          },
	          "id": 130,
	          "options": {
	            "legend": {
	              "calcs": [
	                "mean",
	                "lastNotNull"
	              ],
	              "displayMode": "table",
	              "placement": "bottom",
	              "sortBy": "Last *",
	              "sortDesc": true
	            },
	            "tooltip": {
	              "mode": "single",
	              "sort": "none"
	            }
	          },
	          "targets": [
	            {
	              "datasource": {
	                "type": "prometheus",
	                "uid": "prometheus_vela"
	              },
	              "editorMode": "code",
	              "expr": "sum(rate(ocm_proxy_proxied_request_duration_seconds_count[$rate_interval])) by (verb, resource)",
	              "legendFormat": "{{verb}} {{resource}}",
	              "range": true,
	              "refId": "A"
	            }
	          ],
	          "title": "QPS (by verb & resource)",
	          "type": "timeseries"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "fieldConfig": {
	            "defaults": {
	              "color": {
	                "mode": "palette-classic"
	              },
	              "custom": {
	                "axisLabel": "",
	                "axisPlacement": "auto",
	                "barAlignment": 0,
	                "drawStyle": "line",
	                "fillOpacity": 0,
	                "gradientMode": "none",
	                "hideFrom": {
	                  "legend": false,
	                  "tooltip": false,
	                  "viz": false
	                },
	                "lineInterpolation": "linear",
	                "lineWidth": 1,
	                "pointSize": 5,
	                "scaleDistribution": {
	                  "type": "linear"
	                },
	                "showPoints": "auto",
	                "spanNulls": false,
	                "stacking": {
	                  "group": "A",
	                  "mode": "none"
	                },
	                "thresholdsStyle": {
	                  "mode": "off"
	                }
	              },
	              "decimals": 2,
	              "mappings": [],
	              "thresholds": {
	                "mode": "absolute",
	                "steps": [
	                  {
	                    "color": "green",
	                    "value": null
	                  }
	                ]
	              },
	              "unit": "s"
	            },
	            "overrides": []
	          },
	          "gridPos": {
	            "h": 7,
	            "w": 6,
	            "x": 12,
	            "y": 1
	          },
	          "id": 129,
	          "options": {
	            "legend": {
	              "calcs": [
	                "mean",
	                "lastNotNull"
	              ],
	              "displayMode": "table",
	              "placement": "bottom",
	              "sortBy": "Last *",
	              "sortDesc": true
	            },
	            "tooltip": {
	              "mode": "single",
	              "sort": "none"
	            }
	          },
	          "targets": [
	            {
	              "datasource": {
	                "type": "prometheus",
	                "uid": "prometheus_vela"
	              },
	              "editorMode": "code",
	              "expr": "sum(rate(ocm_proxy_proxied_request_duration_seconds_sum[$rate_interval])) by (cluster) / sum(rate(ocm_proxy_proxied_request_duration_seconds_count[$rate_interval])) by (cluster)",
	              "legendFormat": "{{cluster}}",
	              "range": true,
	              "refId": "A"
	            }
	          ],
	          "title": "Avg Latency (by cluster)",
	          "type": "timeseries"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "fieldConfig": {
	            "defaults": {
	              "color": {
	                "mode": "palette-classic"
	              },
	              "custom": {
	                "axisLabel": "",
	                "axisPlacement": "auto",
	                "barAlignment": 0,
	                "drawStyle": "line",
	                "fillOpacity": 0,
	                "gradientMode": "none",
	                "hideFrom": {
	                  "legend": false,
	                  "tooltip": false,
	                  "viz": false
	                },
	                "lineInterpolation": "linear",
	                "lineWidth": 1,
	                "pointSize": 5,
	                "scaleDistribution": {
	                  "type": "linear"
	                },
	                "showPoints": "auto",
	                "spanNulls": false,
	                "stacking": {
	                  "group": "A",
	                  "mode": "none"
	                },
	                "thresholdsStyle": {
	                  "mode": "off"
	                }
	              },
	              "decimals": 2,
	              "mappings": [],
	              "thresholds": {
	                "mode": "absolute",
	                "steps": [
	                  {
	                    "color": "green",
	                    "value": null
	                  }
	                ]
	              },
	              "unit": "qps"
	            },
	            "overrides": []
	          },
	          "gridPos": {
	            "h": 7,
	            "w": 6,
	            "x": 18,
	            "y": 1
	          },
	          "id": 131,
	          "options": {
	            "legend": {
	              "calcs": [
	                "mean",
	                "lastNotNull"
	              ],
	              "displayMode": "table",
	              "placement": "bottom",
	              "sortBy": "Last *",
	              "sortDesc": true
	            },
	            "tooltip": {
	              "mode": "single",
	              "sort": "none"
	            }
	          },
	          "targets": [
	            {
	              "datasource": {
	                "type": "prometheus",
	                "uid": "prometheus_vela"
	              },
	              "editorMode": "code",
	              "expr": "sum(rate(ocm_proxy_proxied_request_duration_seconds_count[$rate_interval])) by (cluster)",
	              "legendFormat": "{{cluster}}",
	              "range": true,
	              "refId": "A"
	            }
	          ],
	          "title": "QPS (by cluster)",
	          "type": "timeseries"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "description": "",
	          "fieldConfig": {
	            "defaults": {
	              "color": {
	                "fixedColor": "#1f78c1",
	                "mode": "fixed"
	              },
	              "mappings": [],
	              "thresholds": {
	                "mode": "absolute",
	                "steps": [
	                  {
	                    "color": "#5f5f5f",
	                    "value": null
	                  }
	                ]
	              },
	              "unit": "none"
	            },
	            "overrides": []
	          },
	          "gridPos": {
	            "h": 4,
	            "w": 3,
	            "x": 0,
	            "y": 8
	          },
	          "id": 145,
	          "options": {
	            "colorMode": "none",
	            "graphMode": "none",
	            "justifyMode": "auto",
	            "orientation": "auto",
	            "reduceOptions": {
	              "calcs": [
	                "lastNotNull"
	              ],
	              "fields": "",
	              "values": false
	            },
	            "text": {
	              "valueSize": 32
	            },
	            "textMode": "auto"
	          },
	          "pluginVersion": "8.5.3",
	          "targets": [
	            {
	              "datasource": {
	                "type": "prometheus",
	                "uid": "prometheus_vela"
	              },
	              "expr": "count(sum(kube_pod_container_info{cluster=\"local\",container=\"kubevela-vela-core-cluster-gateway\"}) by (pod))",
	              "refId": "A"
	            }
	          ],
	          "title": "Pods",
	          "type": "stat"
	        },
	        {
	          "datasource": {
	            "type": "marcusolsson-json-datasource",
	            "uid": "kubernetes-api"
	          },
	          "description": "",
	          "fieldConfig": {
	            "defaults": {
	              "color": {
	                "fixedColor": "#1f78c1",
	                "mode": "fixed"
	              },
	              "mappings": [],
	              "thresholds": {
	                "mode": "absolute",
	                "steps": [
	                  {
	                    "color": "#5f5f5f",
	                    "value": null
	                  }
	                ]
	              },
	              "unit": "none"
	            },
	            "overrides": []
	          },
	          "gridPos": {
	            "h": 4,
	            "w": 3,
	            "x": 3,
	            "y": 8
	          },
	          "id": 138,
	          "options": {
	            "colorMode": "none",
	            "graphMode": "none",
	            "justifyMode": "auto",
	            "orientation": "auto",
	            "reduceOptions": {
	              "calcs": [],
	              "fields": "/.*/",
	              "values": false
	            },
	            "text": {
	              "valueSize": 32
	            },
	            "textMode": "auto"
	          },
	          "pluginVersion": "8.5.3",
	          "targets": [
	            {
	              "cacheDurationSeconds": 300,
	              "datasource": {
	                "type": "marcusolsson-json-datasource",
	                "uid": "kubernetes-api"
	              },
	              "fields": [
	                {
	                  "jsonPath": "$count(items)",
	                  "language": "jsonata"
	                }
	              ],
	              "method": "GET",
	              "queryParams": "",
	              "refId": "A",
	              "urlPath": "/apis/cluster.core.oam.dev/v1alpha1/clustergateways"
	            }
	          ],
	          "title": "Clusters",
	          "type": "stat"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "fieldConfig": {
	            "defaults": {
	              "color": {
	                "fixedColor": "#1f78c1",
	                "mode": "fixed"
	              },
	              "mappings": [
	                {
	                  "options": {
	                    "match": "null",
	                    "result": {
	                      "text": "0"
	                    }
	                  },
	                  "type": "special"
	                }
	              ],
	              "thresholds": {
	                "mode": "absolute",
	                "steps": [
	                  {
	                    "color": "green",
	                    "value": null
	                  }
	                ]
	              },
	              "unit": "none"
	            },
	            "overrides": []
	          },
	          "gridPos": {
	            "h": 4,
	            "w": 3,
	            "x": 6,
	            "y": 8
	          },
	          "id": 140,
	          "links": [],
	          "maxDataPoints": 100,
	          "options": {
	            "colorMode": "none",
	            "graphMode": "none",
	            "justifyMode": "auto",
	            "orientation": "horizontal",
	            "reduceOptions": {
	              "calcs": [
	                "mean"
	              ],
	              "fields": "",
	              "values": false
	            },
	            "text": {
	              "valueSize": 32
	            },
	            "textMode": "auto"
	          },
	          "pluginVersion": "8.5.3",
	          "targets": [
	            {
	              "datasource": {
	                "type": "prometheus",
	                "uid": "${datasource}"
	              },
	              "expr": "sum(container_threads{cluster=\"local\",container=\"kubevela-vela-core-cluster-gateway\"})",
	              "intervalFactor": 2,
	              "refId": "A",
	              "step": 600
	            }
	          ],
	          "title": "Threads",
	          "type": "stat"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "fieldConfig": {
	            "defaults": {
	              "color": {
	                "fixedColor": "rgb(31, 120, 193)",
	                "mode": "fixed"
	              },
	              "mappings": [
	                {
	                  "options": {
	                    "match": "null",
	                    "result": {
	                      "text": "0"
	                    }
	                  },
	                  "type": "special"
	                }
	              ],
	              "thresholds": {
	                "mode": "absolute",
	                "steps": [
	                  {
	                    "color": "green",
	                    "value": null
	                  }
	                ]
	              },
	              "unit": "binBps"
	            },
	            "overrides": []
	          },
	          "gridPos": {
	            "h": 4,
	            "w": 3,
	            "x": 9,
	            "y": 8
	          },
	          "id": 142,
	          "links": [],
	          "maxDataPoints": 100,
	          "options": {
	            "colorMode": "none",
	            "graphMode": "area",
	            "justifyMode": "auto",
	            "orientation": "horizontal",
	            "reduceOptions": {
	              "calcs": [
	                "mean"
	              ],
	              "fields": "",
	              "values": false
	            },
	            "text": {
	              "valueSize": 32
	            },
	            "textMode": "auto"
	          },
	          "pluginVersion": "8.5.3",
	          "targets": [
	            {
	              "datasource": {
	                "type": "prometheus",
	                "uid": "${datasource}"
	              },
	              "expr": "sum(sum(kube_pod_container_info{cluster=\"local\",container=\"kubevela-vela-core-cluster-gateway\"}) by (pod)\n* on(pod) group_right() sum(rate(container_network_receive_bytes_total[5m])) by (pod)) + \nsum(sum(kube_pod_container_info{cluster=\"local\",container=\"kubevela-vela-core-cluster-gateway\"}) by (pod)\n* on(pod) group_right() sum(rate(container_network_transmit_bytes_total[5m])) by (pod))",
	              "intervalFactor": 2,
	              "refId": "A",
	              "step": 600
	            }
	          ],
	          "title": "Network IO",
	          "type": "stat"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "fieldConfig": {
	            "defaults": {
	              "color": {
	                "fixedColor": "rgb(31, 120, 193)",
	                "mode": "thresholds"
	              },
	              "decimals": 2,
	              "mappings": [
	                {
	                  "options": {
	                    "match": "null",
	                    "result": {
	                      "text": "0"
	                    }
	                  },
	                  "type": "special"
	                }
	              ],
	              "max": 1,
	              "min": 0,
	              "thresholds": {
	                "mode": "absolute",
	                "steps": [
	                  {
	                    "color": "green",
	                    "value": null
	                  },
	                  {
	                    "color": "#EAB839",
	                    "value": 0.6
	                  },
	                  {
	                    "color": "red",
	                    "value": 0.8
	                  }
	                ]
	              },
	              "unit": "percentunit"
	            },
	            "overrides": []
	          },
	          "gridPos": {
	            "h": 4,
	            "w": 3,
	            "x": 12,
	            "y": 8
	          },
	          "id": 134,
	          "links": [],
	          "maxDataPoints": 100,
	          "options": {
	            "orientation": "horizontal",
	            "reduceOptions": {
	              "calcs": [
	                "lastNotNull"
	              ],
	              "fields": "",
	              "values": false
	            },
	            "showThresholdLabels": false,
	            "showThresholdMarkers": true
	          },
	          "pluginVersion": "8.5.3",
	          "targets": [
	            {
	              "datasource": {
	                "type": "prometheus",
	                "uid": "${datasource}"
	              },
	              "expr": "sum(rate(container_cpu_usage_seconds_total{cluster=\"local\",container=\"kubevela-vela-core-cluster-gateway\"}[5m])) /\nsum(container_spec_cpu_quota{cluster=\"local\",container=\"kubevela-vela-core-cluster-gateway\"}) * 1e5",
	              "intervalFactor": 2,
	              "refId": "A",
	              "step": 600
	            }
	          ],
	          "title": "CPU Usage",
	          "type": "gauge"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "fieldConfig": {
	            "defaults": {
	              "color": {
	                "fixedColor": "rgb(31, 120, 193)",
	                "mode": "fixed"
	              },
	              "decimals": 2,
	              "mappings": [
	                {
	                  "options": {
	                    "match": "null",
	                    "result": {
	                      "text": "0"
	                    }
	                  },
	                  "type": "special"
	                }
	              ],
	              "thresholds": {
	                "mode": "absolute",
	                "steps": [
	                  {
	                    "color": "green",
	                    "value": null
	                  }
	                ]
	              },
	              "unit": "cores"
	            },
	            "overrides": []
	          },
	          "gridPos": {
	            "h": 4,
	            "w": 3,
	            "x": 15,
	            "y": 8
	          },
	          "id": 143,
	          "links": [],
	          "maxDataPoints": 100,
	          "options": {
	            "colorMode": "none",
	            "graphMode": "area",
	            "justifyMode": "auto",
	            "orientation": "horizontal",
	            "reduceOptions": {
	              "calcs": [
	                "mean"
	              ],
	              "fields": "",
	              "values": false
	            },
	            "text": {
	              "valueSize": 32
	            },
	            "textMode": "auto"
	          },
	          "pluginVersion": "8.5.3",
	          "targets": [
	            {
	              "datasource": {
	                "type": "prometheus",
	                "uid": "${datasource}"
	              },
	              "expr": "sum(rate(container_cpu_usage_seconds_total{cluster=\"local\",container=\"kubevela-vela-core-cluster-gateway\"}[5m]))",
	              "intervalFactor": 2,
	              "refId": "A",
	              "step": 600
	            }
	          ],
	          "title": "CPU Usage",
	          "type": "stat"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "fieldConfig": {
	            "defaults": {
	              "color": {
	                "fixedColor": "rgb(31, 120, 193)",
	                "mode": "thresholds"
	              },
	              "decimals": 2,
	              "mappings": [
	                {
	                  "options": {
	                    "match": "null",
	                    "result": {
	                      "text": "0"
	                    }
	                  },
	                  "type": "special"
	                }
	              ],
	              "max": 1,
	              "min": 0,
	              "thresholds": {
	                "mode": "absolute",
	                "steps": [
	                  {
	                    "color": "green",
	                    "value": null
	                  },
	                  {
	                    "color": "#EAB839",
	                    "value": 0.6
	                  },
	                  {
	                    "color": "red",
	                    "value": 0.8
	                  }
	                ]
	              },
	              "unit": "percentunit"
	            },
	            "overrides": []
	          },
	          "gridPos": {
	            "h": 4,
	            "w": 3,
	            "x": 18,
	            "y": 8
	          },
	          "id": 135,
	          "links": [],
	          "maxDataPoints": 100,
	          "options": {
	            "orientation": "horizontal",
	            "reduceOptions": {
	              "calcs": [
	                "lastNotNull"
	              ],
	              "fields": "",
	              "values": false
	            },
	            "showThresholdLabels": false,
	            "showThresholdMarkers": true,
	            "text": {}
	          },
	          "pluginVersion": "8.5.3",
	          "targets": [
	            {
	              "datasource": {
	                "type": "prometheus",
	                "uid": "${datasource}"
	              },
	              "expr": "sum(container_memory_working_set_bytes{cluster=\"local\",container=\"kubevela-vela-core-cluster-gateway\"}) / sum(container_spec_memory_limit_bytes{cluster=\"local\",container=\"kubevela-vela-core-cluster-gateway\"})",
	              "intervalFactor": 2,
	              "refId": "A",
	              "step": 600
	            }
	          ],
	          "title": "Memory Usage",
	          "type": "gauge"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "fieldConfig": {
	            "defaults": {
	              "color": {
	                "fixedColor": "rgb(31, 120, 193)",
	                "mode": "fixed"
	              },
	              "mappings": [
	                {
	                  "options": {
	                    "match": "null",
	                    "result": {
	                      "text": "0"
	                    }
	                  },
	                  "type": "special"
	                }
	              ],
	              "thresholds": {
	                "mode": "absolute",
	                "steps": [
	                  {
	                    "color": "green",
	                    "value": null
	                  }
	                ]
	              },
	              "unit": "bytes"
	            },
	            "overrides": []
	          },
	          "gridPos": {
	            "h": 4,
	            "w": 3,
	            "x": 21,
	            "y": 8
	          },
	          "id": 144,
	          "links": [],
	          "maxDataPoints": 100,
	          "options": {
	            "colorMode": "none",
	            "graphMode": "area",
	            "justifyMode": "auto",
	            "orientation": "horizontal",
	            "reduceOptions": {
	              "calcs": [
	                "mean"
	              ],
	              "fields": "",
	              "values": false
	            },
	            "text": {
	              "valueSize": 32
	            },
	            "textMode": "auto"
	          },
	          "pluginVersion": "8.5.3",
	          "targets": [
	            {
	              "datasource": {
	                "type": "prometheus",
	                "uid": "${datasource}"
	              },
	              "expr": "sum(container_memory_working_set_bytes{cluster=\"local\",container=\"kubevela-vela-core-cluster-gateway\"})",
	              "intervalFactor": 2,
	              "refId": "A",
	              "step": 600
	            }
	          ],
	          "title": "Memory Usage",
	          "type": "stat"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "fieldConfig": {
	            "defaults": {
	              "color": {
	                "mode": "thresholds"
	              },
	              "custom": {
	                "align": "auto",
	                "displayMode": "color-text",
	                "inspect": false
	              },
	              "links": [],
	              "mappings": [
	                {
	                  "options": {
	                    "0": {
	                      "color": "green",
	                      "index": 7
	                    },
	                    "Running": {
	                      "color": "green",
	                      "index": 3
	                    },
	                    "false": {
	                      "color": "red",
	                      "index": 1,
	                      "text": "False"
	                    },
	                    "true": {
	                      "color": "green",
	                      "index": 0,
	                      "text": "True"
	                    },
	                    "unknown": {
	                      "color": "yellow",
	                      "index": 2,
	                      "text": "Unknown"
	                    }
	                  },
	                  "type": "value"
	                },
	                {
	                  "options": {
	                    "pattern": "Waiting|Unknown",
	                    "result": {
	                      "color": "yellow",
	                      "index": 4
	                    }
	                  },
	                  "type": "regex"
	                },
	                {
	                  "options": {
	                    "pattern": "Terminated",
	                    "result": {
	                      "color": "red",
	                      "index": 5
	                    }
	                  },
	                  "type": "regex"
	                }
	              ],
	              "thresholds": {
	                "mode": "absolute",
	                "steps": [
	                  {
	                    "color": "text",
	                    "value": null
	                  }
	                ]
	              }
	            },
	            "overrides": [
	              {
	                "matcher": {
	                  "id": "byRegexp",
	                  "options": "Age"
	                },
	                "properties": [
	                  {
	                    "id": "unit",
	                    "value": "s"
	                  }
	                ]
	              },
	              {
	                "matcher": {
	                  "id": "byRegexp",
	                  "options": "Restarts|Age|Dashboard|#Apps"
	                },
	                "properties": [
	                  {
	                    "id": "custom.align",
	                    "value": "left"
	                  }
	                ]
	              },
	              {
	                "matcher": {
	                  "id": "byRegexp",
	                  "options": "Age|Status|Ready|Restarts"
	                },
	                "properties": [
	                  {
	                    "id": "custom.width",
	                    "value": 80
	                  }
	                ]
	              },
	              {
	                "matcher": {
	                  "id": "byRegexp",
	                  "options": "Dashboard"
	                },
	                "properties": [
	                  {
	                    "id": "links",
	                    "value": [
	                      {
	                        "targetBlank": true,
	                        "title": "Detail",
	                        "url": "/d/kubernetes-pod/kubernetes-pod?${namespace:queryparam}&${cluster:queryparam}&${datasource:queryparam}&var-pod=${__data.fields.Pod}"
	                      }
	                    ]
	                  },
	                  {
	                    "id": "mappings",
	                    "value": [
	                      {
	                        "options": {
	                          "1": {
	                            "color": "yellow",
	                            "index": 0,
	                            "text": "Detail"
	                          }
	                        },
	                        "type": "value"
	                      }
	                    ]
	                  }
	                ]
	              },
	              {
	                "matcher": {
	                  "id": "byRegexp",
	                  "options": "IP|Node|Dashboard|ShardID|#Apps"
	                },
	                "properties": [
	                  {
	                    "id": "custom.width",
	                    "value": 120
	                  }
	                ]
	              },
	              {
	                "matcher": {
	                  "id": "byRegexp",
	                  "options": "Memory|CPU"
	                },
	                "properties": [
	                  {
	                    "id": "custom.width",
	                    "value": 120
	                  },
	                  {
	                    "id": "unit",
	                    "value": "percentunit"
	                  },
	                  {
	                    "id": "decimals",
	                    "value": 2
	                  },
	                  {
	                    "id": "mappings",
	                    "value": [
	                      {
	                        "options": {
	                          "from": 0,
	                          "result": {
	                            "color": "green",
	                            "index": 0
	                          },
	                          "to": 0.6
	                        },
	                        "type": "range"
	                      },
	                      {
	                        "options": {
	                          "from": 0.6,
	                          "result": {
	                            "color": "yellow",
	                            "index": 1
	                          },
	                          "to": 0.8
	                        },
	                        "type": "range"
	                      },
	                      {
	                        "options": {
	                          "from": 0.8,
	                          "result": {
	                            "color": "red",
	                            "index": 2
	                          },
	                          "to": 1
	                        },
	                        "type": "range"
	                      }
	                    ]
	                  },
	                  {
	                    "id": "custom.align",
	                    "value": "left"
	                  }
	                ]
	              }
	            ]
	          },
	          "gridPos": {
	            "h": 4,
	            "w": 24,
	            "x": 0,
	            "y": 12
	          },
	          "id": 136,
	          "options": {
	            "footer": {
	              "fields": "",
	              "reducer": [
	                "sum"
	              ],
	              "show": false
	            },
	            "frameIndex": 0,
	            "showHeader": true
	          },
	          "pluginVersion": "8.5.3",
	          "targets": [
	            {
	              "datasource": {
	                "type": "prometheus",
	                "uid": "${datasource}"
	              },
	              "editorMode": "code",
	              "exemplar": false,
	              "expr": "sum(kube_pod_info{cluster=\"local\"}) by (created_by_name, uid, pod, pod_ip, node) * on(pod) group_left() sum(kube_pod_container_info{cluster=\"local\",container=\"kubevela-vela-core-cluster-gateway\"}) by (pod)",
	              "format": "table",
	              "hide": false,
	              "instant": true,
	              "legendFormat": "__auto",
	              "range": false,
	              "refId": "A"
	            },
	            {
	              "datasource": {
	                "type": "prometheus",
	                "uid": "${datasource}"
	              },
	              "editorMode": "code",
	              "exemplar": false,
	              "expr": "sum(kube_pod_status_phase{cluster=\"local\"} * (kube_pod_status_phase{cluster=\"local\"} > 0)) by (pod, phase)",
	              "format": "table",
	              "hide": false,
	              "instant": true,
	              "legendFormat": "__auto",
	              "range": false,
	              "refId": "B"
	            },
	            {
	              "datasource": {
	                "type": "prometheus",
	                "uid": "${datasource}"
	              },
	              "editorMode": "code",
	              "exemplar": false,
	              "expr": "sum(kube_pod_status_ready{cluster=\"local\"} * (kube_pod_status_ready{cluster=\"local\"} > 0)) by (pod, condition)",
	              "format": "table",
	              "hide": false,
	              "instant": true,
	              "legendFormat": "__auto",
	              "range": false,
	              "refId": "C"
	            },
	            {
	              "datasource": {
	                "type": "prometheus",
	                "uid": "${datasource}"
	              },
	              "editorMode": "code",
	              "exemplar": false,
	              "expr": "time() - max(kube_pod_created{cluster=\"local\"}) by (pod)",
	              "format": "table",
	              "hide": false,
	              "instant": true,
	              "legendFormat": "__auto",
	              "range": false,
	              "refId": "D"
	            },
	            {
	              "datasource": {
	                "type": "prometheus",
	                "uid": "${datasource}"
	              },
	              "editorMode": "code",
	              "exemplar": false,
	              "expr": "sum(max(kube_pod_container_status_restarts_total{cluster=\"local\"}) by (pod, container)) by (pod)",
	              "format": "table",
	              "hide": false,
	              "instant": true,
	              "range": false,
	              "refId": "E"
	            },
	            {
	              "datasource": {
	                "type": "prometheus",
	                "uid": "${datasource}"
	              },
	              "editorMode": "code",
	              "expr": "sum(container_memory_working_set_bytes{cluster=\"local\",container=\"kubevela-vela-core-cluster-gateway\"}) by (pod) / sum(container_spec_memory_limit_bytes{cluster=\"local\",container=\"kubevela-vela-core-cluster-gateway\"}) by (pod)",
	              "format": "table",
	              "hide": false,
	              "range": true,
	              "refId": "F"
	            },
	            {
	              "datasource": {
	                "type": "prometheus",
	                "uid": "${datasource}"
	              },
	              "editorMode": "code",
	              "expr": "sum(rate(container_cpu_usage_seconds_total{cluster=\"local\",container=\"kubevela-vela-core-cluster-gateway\"}[5m])) by (pod) / sum(container_spec_cpu_quota{cluster=\"local\",container=\"kubevela-vela-core-cluster-gateway\"}) by (pod) * 1e5",
	              "format": "table",
	              "hide": false,
	              "range": true,
	              "refId": "G"
	            }
	          ],
	          "title": "Pods",
	          "transformations": [
	            {
	              "id": "seriesToColumns",
	              "options": {
	                "byField": "pod"
	              }
	            },
	            {
	              "id": "filterByValue",
	              "options": {
	                "filters": [
	                  {
	                    "config": {
	                      "id": "greater",
	                      "options": {
	                        "value": 0
	                      }
	                    },
	                    "fieldName": "Value #A"
	                  }
	                ],
	                "match": "any",
	                "type": "include"
	              }
	            },
	            {
	              "id": "organize",
	              "options": {
	                "excludeByName": {},
	                "indexByName": {
	                  "Time 1": 7,
	                  "Time 2": 10,
	                  "Time 3": 11,
	                  "Time 4": 12,
	                  "Time 5": 20,
	                  "Time 6": 21,
	                  "Time 7": 22,
	                  "Time 8": 23,
	                  "Value #A": 9,
	                  "Value #B": 18,
	                  "Value #C": 19,
	                  "Value #D": 4,
	                  "Value #E": 3,
	                  "Value #F": 15,
	                  "Value #G": 14,
	                  "Value #H": 16,
	                  "condition": 1,
	                  "controller_core_oam_dev_shard_id": 13,
	                  "created_by_name": 8,
	                  "node": 6,
	                  "phase": 2,
	                  "pod": 0,
	                  "pod_ip": 5,
	                  "uid": 17
	                },
	                "renameByName": {
	                  "Value #C": "",
	                  "Value #D": "Age",
	                  "Value #E": "Restarts",
	                  "Value #F": "Memory",
	                  "Value #G": "CPU",
	                  "Value #H": "#Apps",
	                  "condition": "Ready",
	                  "controller_core_oam_dev_shard_id": "ShardID",
	                  "created_by_name": "",
	                  "node": "Node",
	                  "phase": "Status",
	                  "pod": "Pod",
	                  "pod 1": "Pod",
	                  "pod 2": "",
	                  "pod_ip": "IP",
	                  "replicaset": "ReplicaSet",
	                  "uid": "UID"
	                }
	              }
	            },
	            {
	              "id": "filterFieldsByName",
	              "options": {
	                "include": {
	                  "names": [
	                    "Pod",
	                    "Ready",
	                    "Status",
	                    "Restarts",
	                    "Age",
	                    "IP",
	                    "Node",
	                    "ShardID",
	                    "CPU",
	                    "Memory",
	                    "#Apps"
	                  ]
	                }
	              }
	            },
	            {
	              "id": "calculateField",
	              "options": {
	                "alias": "Dashboard",
	                "mode": "reduceRow",
	                "reduce": {
	                  "include": [
	                    "Pod"
	                  ],
	                  "reducer": "count"
	                }
	              }
	            }
	          ],
	          "type": "table"
	        }
	      ],
	      "title": "Overview of cluster-gateway",
	      "type": "row"
	    },
	    {
	      "collapsed": true,
	      "gridPos": {
	        "h": 1,
	        "w": 24,
	        "x": 0,
	        "y": 44
	      },
	      "id": 92,
	      "panels": [
	        {
	          "datasource": {
	            "type": "marcusolsson-json-datasource",
	            "uid": "kubernetes-api"
	          },
	          "fieldConfig": {
	            "defaults": {
	              "color": {
	                "mode": "thresholds"
	              },
	              "custom": {
	                "align": "auto",
	                "displayMode": "auto",
	                "inspect": false
	              },
	              "mappings": [],
	              "thresholds": {
	                "mode": "absolute",
	                "steps": [
	                  {
	                    "color": "green"
	                  },
	                  {
	                    "color": "red",
	                    "value": 80
	                  }
	                ]
	              }
	            },
	            "overrides": [
	              {
	                "matcher": {
	                  "id": "byRegexp",
	                  "options": "Description|CUE|CustomStatus|HealthPolicy"
	                },
	                "properties": [
	                  {
	                    "id": "custom.inspect",
	                    "value": true
	                  }
	                ]
	              },
	              {
	                "matcher": {
	                  "id": "byRegexp",
	                  "options": "^((?!Description).)*$"
	                },
	                "properties": [
	                  {
	                    "id": "custom.width",
	                    "value": 200
	                  }
	                ]
	              }
	            ]
	          },
	          "gridPos": {
	            "h": 8,
	            "w": 24,
	            "x": 0,
	            "y": 48
	          },
	          "id": 88,
	          "options": {
	            "footer": {
	              "fields": "",
	              "reducer": [
	                "sum"
	              ],
	              "show": false
	            },
	            "showHeader": true
	          },
	          "pluginVersion": "8.5.3",
	          "targets": [
	            {
	              "cacheDurationSeconds": 300,
	              "datasource": {
	                "type": "marcusolsson-json-datasource",
	                "uid": "kubernetes-api"
	              },
	              "fields": [
	                {
	                  "jsonPath": "$.items[*].metadata.name",
	                  "name": "Name"
	                },
	                {
	                  "jsonPath": "$.items[*].metadata.namespace",
	                  "language": "jsonpath",
	                  "name": "Namespace"
	                },
	                {
	                  "jsonPath": "$.items[*].metadata.annotations.\"definition.oam.dev/description\"",
	                  "language": "jsonata",
	                  "name": "Description"
	                },
	                {
	                  "jsonPath": "$.items[*].metadata.($exists(annotations.\"custom.definition.oam.dev/alias.config.oam.dev\") ? annotations.\"custom.definition.oam.dev/alias.config.oam.dev\" : '')",
	                  "language": "jsonata",
	                  "name": "Alias"
	                },
	                {
	                  "jsonPath": "$.items[*].spec.workload.type",
	                  "language": "jsonata",
	                  "name": "Workload"
	                },
	                {
	                  "jsonPath": "$.items[*].spec.schematic.cue.template",
	                  "language": "jsonpath",
	                  "name": "CUE"
	                },
	                {
	                  "jsonPath": "$.items[*].spec.($exists(status.customStatus) ? status.customStatus : '')",
	                  "language": "jsonata",
	                  "name": "CustomStatus"
	                },
	                {
	                  "jsonPath": "$.items[*].spec.($exists(status.healthPolicy) ? status.healthPolicy : '')",
	                  "language": "jsonata",
	                  "name": "HealthPolicy"
	                }
	              ],
	              "method": "GET",
	              "queryParams": "",
	              "refId": "A",
	              "urlPath": "/apis/core.oam.dev/v1beta1/componentdefinitions"
	            }
	          ],
	          "title": "ComponentDefinitions",
	          "type": "table"
	        },
	        {
	          "datasource": {
	            "type": "marcusolsson-json-datasource",
	            "uid": "kubernetes-api"
	          },
	          "fieldConfig": {
	            "defaults": {
	              "color": {
	                "mode": "thresholds"
	              },
	              "custom": {
	                "align": "auto",
	                "displayMode": "auto",
	                "inspect": false
	              },
	              "mappings": [],
	              "thresholds": {
	                "mode": "absolute",
	                "steps": [
	                  {
	                    "color": "green"
	                  },
	                  {
	                    "color": "red",
	                    "value": 80
	                  }
	                ]
	              }
	            },
	            "overrides": [
	              {
	                "matcher": {
	                  "id": "byRegexp",
	                  "options": "Description|CUE|CustomStatus|HealthPolicy"
	                },
	                "properties": [
	                  {
	                    "id": "custom.inspect",
	                    "value": true
	                  }
	                ]
	              },
	              {
	                "matcher": {
	                  "id": "byRegexp",
	                  "options": "^((?!Description).)*$"
	                },
	                "properties": [
	                  {
	                    "id": "custom.width",
	                    "value": 200
	                  }
	                ]
	              }
	            ]
	          },
	          "gridPos": {
	            "h": 8,
	            "w": 24,
	            "x": 0,
	            "y": 56
	          },
	          "id": 89,
	          "options": {
	            "footer": {
	              "fields": "",
	              "reducer": [
	                "sum"
	              ],
	              "show": false
	            },
	            "showHeader": true
	          },
	          "pluginVersion": "8.5.3",
	          "targets": [
	            {
	              "cacheDurationSeconds": 300,
	              "datasource": {
	                "type": "marcusolsson-json-datasource",
	                "uid": "kubernetes-api"
	              },
	              "fields": [
	                {
	                  "jsonPath": "$.items[*].metadata.name",
	                  "name": "Name"
	                },
	                {
	                  "jsonPath": "$.items[*].metadata.namespace",
	                  "language": "jsonpath",
	                  "name": "Namespace"
	                },
	                {
	                  "jsonPath": "$.items[*].metadata.annotations.\"definition.oam.dev/description\"",
	                  "language": "jsonata",
	                  "name": "Description"
	                },
	                {
	                  "jsonPath": "$.items[*].spec.schematic.cue.template",
	                  "language": "jsonpath",
	                  "name": "CUE"
	                },
	                {
	                  "jsonPath": "$.items[*].spec.($exists(status.customStatus) ? status.customStatus : '')",
	                  "language": "jsonata",
	                  "name": "CustomStatus"
	                },
	                {
	                  "jsonPath": "$.items[*].spec.($exists(status.healthPolicy) ? status.healthPolicy : '')",
	                  "language": "jsonata",
	                  "name": "HealthPolicy"
	                }
	              ],
	              "method": "GET",
	              "queryParams": "",
	              "refId": "A",
	              "urlPath": "/apis/core.oam.dev/v1beta1/traitdefinitions"
	            }
	          ],
	          "title": "TraitDefinitions",
	          "type": "table"
	        },
	        {
	          "datasource": {
	            "type": "marcusolsson-json-datasource",
	            "uid": "kubernetes-api"
	          },
	          "fieldConfig": {
	            "defaults": {
	              "color": {
	                "mode": "thresholds"
	              },
	              "custom": {
	                "align": "auto",
	                "displayMode": "auto",
	                "inspect": false
	              },
	              "mappings": [],
	              "thresholds": {
	                "mode": "absolute",
	                "steps": [
	                  {
	                    "color": "green"
	                  },
	                  {
	                    "color": "red",
	                    "value": 80
	                  }
	                ]
	              }
	            },
	            "overrides": [
	              {
	                "matcher": {
	                  "id": "byRegexp",
	                  "options": "Description|CUE|CustomStatus|HealthPolicy"
	                },
	                "properties": [
	                  {
	                    "id": "custom.inspect",
	                    "value": true
	                  }
	                ]
	              },
	              {
	                "matcher": {
	                  "id": "byRegexp",
	                  "options": "^((?!Description).)*$"
	                },
	                "properties": [
	                  {
	                    "id": "custom.width",
	                    "value": 200
	                  }
	                ]
	              },
	              {
	                "matcher": {
	                  "id": "byRegexp",
	                  "options": "CUE"
	                },
	                "properties": [
	                  {
	                    "id": "custom.width",
	                    "value": 600
	                  }
	                ]
	              }
	            ]
	          },
	          "gridPos": {
	            "h": 8,
	            "w": 24,
	            "x": 0,
	            "y": 64
	          },
	          "id": 90,
	          "options": {
	            "footer": {
	              "fields": "",
	              "reducer": [
	                "sum"
	              ],
	              "show": false
	            },
	            "showHeader": true
	          },
	          "pluginVersion": "8.5.3",
	          "targets": [
	            {
	              "cacheDurationSeconds": 300,
	              "datasource": {
	                "type": "marcusolsson-json-datasource",
	                "uid": "kubernetes-api"
	              },
	              "fields": [
	                {
	                  "jsonPath": "$.items[*].metadata.name",
	                  "name": "Name"
	                },
	                {
	                  "jsonPath": "$.items[*].metadata.namespace",
	                  "language": "jsonpath",
	                  "name": "Namespace"
	                },
	                {
	                  "jsonPath": "$.items[*].metadata.annotations.\"definition.oam.dev/description\"",
	                  "language": "jsonata",
	                  "name": "Description"
	                },
	                {
	                  "jsonPath": "$.items[*].spec.schematic.cue.template",
	                  "language": "jsonpath",
	                  "name": "CUE"
	                }
	              ],
	              "method": "GET",
	              "queryParams": "",
	              "refId": "A",
	              "urlPath": "/apis/core.oam.dev/v1beta1/traitdefinitions"
	            }
	          ],
	          "title": "WorkflowStepDefinitions",
	          "type": "table"
	        }
	      ],
	      "title": "X-Definitions",
	      "type": "row"
	    },
	    {
	      "collapsed": true,
	      "gridPos": {
	        "h": 1,
	        "w": 24,
	        "x": 0,
	        "y": 45
	      },
	      "id": 98,
	      "panels": [
	        {
	          "datasource": {
	            "type": "marcusolsson-json-datasource",
	            "uid": "kubernetes-api"
	          },
	          "fieldConfig": {
	            "defaults": {
	              "color": {
	                "mode": "thresholds"
	              },
	              "custom": {
	                "align": "auto",
	                "displayMode": "color-text",
	                "inspect": false
	              },
	              "mappings": [
	                {
	                  "options": {
	                    "running": {
	                      "color": "green",
	                      "index": 0
	                    }
	                  },
	                  "type": "value"
	                }
	              ],
	              "thresholds": {
	                "mode": "absolute",
	                "steps": [
	                  {
	                    "color": "text",
	                    "value": null
	                  }
	                ]
	              }
	            },
	            "overrides": []
	          },
	          "gridPos": {
	            "h": 8,
	            "w": 7,
	            "x": 0,
	            "y": 30
	          },
	          "id": 94,
	          "options": {
	            "footer": {
	              "fields": "",
	              "reducer": [
	                "sum"
	              ],
	              "show": false
	            },
	            "showHeader": true
	          },
	          "pluginVersion": "8.5.3",
	          "targets": [
	            {
	              "cacheDurationSeconds": 300,
	              "datasource": {
	                "type": "marcusolsson-json-datasource",
	                "uid": "kubernetes-api"
	              },
	              "fields": [
	                {
	                  "jsonPath": "$.items[*].metadata.labels.\"addons.oam.dev/name\"",
	                  "language": "jsonata",
	                  "name": "Name"
	                },
	                {
	                  "jsonPath": "$.items[*].metadata.labels.\"addons.oam.dev/version\"",
	                  "language": "jsonata",
	                  "name": "Version"
	                },
	                {
	                  "jsonPath": "$.items[*].metadata.labels.\"addons.oam.dev/registry\"",
	                  "language": "jsonata",
	                  "name": "Registry"
	                },
	                {
	                  "jsonPath": "$.items[*].($exists(status.status) ? status.status : '')",
	                  "language": "jsonata",
	                  "name": "Status"
	                }
	              ],
	              "method": "GET",
	              "queryParams": "",
	              "refId": "A",
	              "urlPath": "/apis/core.oam.dev/v1beta1/applications?labelSelector=addons.oam.dev%2Fname"
	            }
	          ],
	          "title": "Addons",
	          "type": "table"
	        },
	        {
	          "datasource": {
	            "type": "marcusolsson-json-datasource",
	            "uid": "kubernetes-api"
	          },
	          "fieldConfig": {
	            "defaults": {
	              "color": {
	                "mode": "thresholds"
	              },
	              "custom": {
	                "align": "left",
	                "displayMode": "color-text",
	                "inspect": false
	              },
	              "mappings": [
	                {
	                  "options": {
	                    "running": {
	                      "color": "green",
	                      "index": 0
	                    }
	                  },
	                  "type": "value"
	                }
	              ],
	              "thresholds": {
	                "mode": "absolute",
	                "steps": [
	                  {
	                    "color": "text",
	                    "value": null
	                  }
	                ]
	              }
	            },
	            "overrides": [
	              {
	                "matcher": {
	                  "id": "byRegexp",
	                  "options": "#.*|WorkflowMode"
	                },
	                "properties": [
	                  {
	                    "id": "custom.width",
	                    "value": 125
	                  }
	                ]
	              },
	              {
	                "matcher": {
	                  "id": "byRegexp",
	                  "options": "Namespace|Name|CreateTime|Status"
	                },
	                "properties": [
	                  {
	                    "id": "custom.width",
	                    "value": 150
	                  }
	                ]
	              },
	              {
	                "matcher": {
	                  "id": "byName",
	                  "options": "Json"
	                },
	                "properties": [
	                  {
	                    "id": "custom.displayMode",
	                    "value": "json-view"
	                  },
	                  {
	                    "id": "custom.inspect",
	                    "value": true
	                  }
	                ]
	              },
	              {
	                "matcher": {
	                  "id": "byRegexp",
	                  "options": "Namespace|Name|WorkflowMode|Status|ShardID"
	                },
	                "properties": [
	                  {
	                    "id": "custom.filterable",
	                    "value": true
	                  }
	                ]
	              }
	            ]
	          },
	          "gridPos": {
	            "h": 8,
	            "w": 17,
	            "x": 7,
	            "y": 30
	          },
	          "id": 96,
	          "options": {
	            "footer": {
	              "fields": "",
	              "reducer": [
	                "sum"
	              ],
	              "show": false
	            },
	            "showHeader": true
	          },
	          "pluginVersion": "8.5.3",
	          "targets": [
	            {
	              "cacheDurationSeconds": 300,
	              "datasource": {
	                "type": "marcusolsson-json-datasource",
	                "uid": "kubernetes-api"
	              },
	              "fields": [
	                {
	                  "jsonPath": "$.items[*].metadata.namespace",
	                  "name": "Namespace"
	                },
	                {
	                  "jsonPath": "$.items[*].metadata.name",
	                  "language": "jsonpath",
	                  "name": "Name"
	                },
	                {
	                  "jsonPath": "$.items[*].metadata.creationTimestamp",
	                  "language": "jsonpath",
	                  "name": "CreateTime"
	                },
	                {
	                  "jsonPath": "$.items[*].metadata.labels.\"controller.core.oam.dev/scheduled-shard-id\"",
	                  "language": "jsonata",
	                  "name": "ShardID"
	                },
	                {
	                  "jsonPath": "$.items[*].spec.($count(components))",
	                  "language": "jsonata",
	                  "name": "#Components"
	                },
	                {
	                  "jsonPath": "$.items[*].spec.($count(policies))",
	                  "language": "jsonata",
	                  "name": "#Traits"
	                },
	                {
	                  "jsonPath": "$.items[*].status.workflow.mode",
	                  "language": "jsonata",
	                  "name": "WorkflowMode"
	                },
	                {
	                  "jsonPath": "$.items[*].status.workflow.($count(steps))",
	                  "language": "jsonata",
	                  "name": "#WorkflowSteps"
	                },
	                {
	                  "jsonPath": "$.items[*].status.status",
	                  "language": "jsonpath",
	                  "name": "Status"
	                },
	                {
	                  "jsonPath": "$.items[*]",
	                  "language": "jsonpath",
	                  "name": "Json"
	                }
	              ],
	              "method": "GET",
	              "queryParams": "",
	              "refId": "A",
	              "urlPath": "/apis/core.oam.dev/v1beta1/applications"
	            }
	          ],
	          "title": "Applications",
	          "type": "table"
	        }
	      ],
	      "title": "Applications",
	      "type": "row"
	    }
	  ],
	  "refresh": "1m",
	  "schemaVersion": 36,
	  "style": "dark",
	  "tags": [
	    "kubevela",
	    "system"
	  ],
	  "templating": {
	    "list": [
	      {
	        "current": {
	          "selected": false,
	          "text": "prometheus-vela",
	          "value": "prometheus-vela"
	        },
	        "hide": 2,
	        "includeAll": false,
	        "multi": false,
	        "name": "datasource",
	        "options": [],
	        "query": "prometheus",
	        "refresh": 1,
	        "regex": "",
	        "skipUrlSync": false,
	        "type": "datasource"
	      },
	      {
	        "auto": false,
	        "auto_count": 30,
	        "auto_min": "10s",
	        "current": {
	          "selected": false,
	          "text": "5m",
	          "value": "5m"
	        },
	        "hide": 2,
	        "name": "rate_interval",
	        "options": [
	          {
	            "selected": false,
	            "text": "3m",
	            "value": "3m"
	          },
	          {
	            "selected": true,
	            "text": "5m",
	            "value": "5m"
	          },
	          {
	            "selected": false,
	            "text": "10m",
	            "value": "10m"
	          },
	          {
	            "selected": false,
	            "text": "30m",
	            "value": "30m"
	          },
	          {
	            "selected": false,
	            "text": "1h",
	            "value": "1h"
	          },
	          {
	            "selected": false,
	            "text": "6h",
	            "value": "6h"
	          },
	          {
	            "selected": false,
	            "text": "12h",
	            "value": "12h"
	          },
	          {
	            "selected": false,
	            "text": "1d",
	            "value": "1d"
	          },
	          {
	            "selected": false,
	            "text": "7d",
	            "value": "7d"
	          },
	          {
	            "selected": false,
	            "text": "14d",
	            "value": "14d"
	          },
	          {
	            "selected": false,
	            "text": "30d",
	            "value": "30d"
	          }
	        ],
	        "query": "3m,5m,10m,30m,1h,6h,12h,1d,7d,14d,30d",
	        "queryValue": "",
	        "refresh": 2,
	        "skipUrlSync": false,
	        "type": "interval"
	      },
	      {
	        "allValue": ".+",
	        "current": {
	          "selected": true,
	          "text": "All",
	          "value": "$__all"
	        },
	        "datasource": {
	          "type": "prometheus",
	          "uid": "${datasource}"
	        },
	        "definition": "label_values(application_phase_number, pod)",
	        "hide": 0,
	        "includeAll": true,
	        "label": "Pod",
	        "multi": false,
	        "name": "pod",
	        "options": [],
	        "query": {
	          "query": "label_values(application_phase_number, pod)",
	          "refId": "StandardVariableQuery"
	        },
	        "refresh": 1,
	        "regex": "",
	        "skipUrlSync": false,
	        "sort": 0,
	        "type": "query"
	      }
	    ]
	  },
	  "time": {
	    "from": "now-30m",
	    "to": "now"
	  },
	  "title": "KubeVela System",
	  "uid": "kubevela-system"
	}
	"""#
