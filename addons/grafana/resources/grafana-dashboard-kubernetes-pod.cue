package main

grafanaDashboardKubernetesPod: {
	name: "grafana-dashboard-kubernetes-pod"
	type: "grafana-dashboard"
	properties: {
		uid:     "kubernetes-pod"
		grafana: parameter.grafanaName
		data:    grafanaDashboardKubernetesPodData
	}
}

grafanaDashboardKubernetesPodData: #"""
	{
	  "description": "Kubernetes Pod Overview",
	  "editable": false,
	  "links": [{
	    "asDropdown": false,
	    "icon": "external link",
	    "includeVars": false,
	    "keepTime": false,
	    "tags": [
	      "kubevela",
	      "application"
	    ],
	    "targetBlank": false,
	    "title": "KubeVela",
	    "tooltip": "",
	    "type": "dashboards",
	    "url": ""
	  }, {
	    "asDropdown": true,
	    "icon": "external link",
	    "includeVars": false,
	    "keepTime": true,
	    "tags": [
	      "kubernetes",
	      "resource"
	    ],
	    "targetBlank": false,
	    "title": "Kubernetes Resources",
	    "tooltip": "",
	    "type": "dashboards",
	    "url": ""
	  }],
	  "panels": [
	    {
	      "collapsed": false,
	      "gridPos": {
	        "h": 1,
	        "w": 24,
	        "x": 0,
	        "y": 0
	      },
	      "id": 12,
	      "panels": [],
	      "title": "Overview",
	      "type": "row"
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
	        "h": 3,
	        "w": 12,
	        "x": 0,
	        "y": 1
	      },
	      "id": 2,
	      "options": {
	        "colorMode": "background",
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
	        "textMode": "name"
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
	          "expr": "kube_pod_info{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\"}",
	          "format": "time_series",
	          "instant": true,
	          "legendFormat": "$pod",
	          "range": false,
	          "refId": "A"
	        }
	      ],
	      "title": "Pod Name",
	      "type": "stat"
	    },
	    {
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "description": "Time since pod created.",
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
	          "unit": "s"
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 3,
	        "w": 4,
	        "x": 12,
	        "y": 1
	      },
	      "id": 5,
	      "options": {
	        "colorMode": "background",
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
	          "valueSize": 36
	        },
	        "textMode": "value"
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
	          "expr": "time() - kube_pod_created{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\"}",
	          "format": "table",
	          "instant": true,
	          "legendFormat": "__auto",
	          "range": false,
	          "refId": "A"
	        }
	      ],
	      "title": "Age",
	      "transformations": [],
	      "type": "stat"
	    },
	    {
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "description": "The pods current phase",
	      "fieldConfig": {
	        "defaults": {
	          "color": {
	            "mode": "thresholds"
	          },
	          "mappings": [
	            {
	              "options": {
	                "pattern": "Running|Succeed",
	                "result": {
	                  "color": "green",
	                  "index": 0
	                }
	              },
	              "type": "regex"
	            },
	            {
	              "options": {
	                "pattern": "Pending|Unknown",
	                "result": {
	                  "color": "yellow",
	                  "index": 1
	                }
	              },
	              "type": "regex"
	            },
	            {
	              "options": {
	                "pattern": "Failed",
	                "result": {
	                  "color": "red",
	                  "index": 2
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
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 3,
	        "w": 4,
	        "x": 16,
	        "y": 1
	      },
	      "id": 3,
	      "options": {
	        "colorMode": "background",
	        "graphMode": "none",
	        "justifyMode": "auto",
	        "orientation": "auto",
	        "reduceOptions": {
	          "calcs": [
	            "lastNotNull"
	          ],
	          "fields": "/^Phase$/",
	          "values": false
	        },
	        "text": {
	          "valueSize": 36
	        },
	        "textMode": "value"
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
	          "expr": "kube_pod_status_phase{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\"} * (kube_pod_status_phase{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\"} > 0)",
	          "format": "table",
	          "instant": true,
	          "legendFormat": "__auto",
	          "range": false,
	          "refId": "A"
	        }
	      ],
	      "title": "Phase",
	      "transformations": [
	        {
	          "id": "organize",
	          "options": {
	            "excludeByName": {},
	            "indexByName": {},
	            "renameByName": {
	              "phase": "Phase"
	            }
	          }
	        }
	      ],
	      "type": "stat"
	    },
	    {
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "description": "Describes whether the pod is ready to serve requests.",
	      "fieldConfig": {
	        "defaults": {
	          "color": {
	            "mode": "thresholds"
	          },
	          "mappings": [
	            {
	              "options": {
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
	        "h": 3,
	        "w": 4,
	        "x": 20,
	        "y": 1
	      },
	      "id": 4,
	      "options": {
	        "colorMode": "background",
	        "graphMode": "none",
	        "justifyMode": "auto",
	        "orientation": "auto",
	        "reduceOptions": {
	          "calcs": [
	            "lastNotNull"
	          ],
	          "fields": "/^condition$/",
	          "values": false
	        },
	        "text": {
	          "valueSize": 36
	        },
	        "textMode": "value"
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
	          "expr": "kube_pod_status_ready{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\"} * (kube_pod_status_ready{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\"} > 0)",
	          "format": "table",
	          "instant": true,
	          "legendFormat": "__auto",
	          "range": false,
	          "refId": "A"
	        }
	      ],
	      "title": "Ready",
	      "transformations": [],
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
	                "color": "#313131",
	                "value": null
	              }
	            ]
	          }
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 2,
	        "w": 12,
	        "x": 0,
	        "y": 4
	      },
	      "id": 9,
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
	          "valueSize": 24
	        },
	        "textMode": "name"
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "kube_pod_owner{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\",owner_kind!=\"\",owner_name!=\"\"}",
	          "legendFormat": "{{owner_kind}}/{{owner_name}}",
	          "range": true,
	          "refId": "A"
	        }
	      ],
	      "title": "Owner",
	      "transformations": [],
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
	                "color": "text",
	                "value": null
	              }
	            ]
	          }
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 2,
	        "w": 4,
	        "x": 12,
	        "y": 4
	      },
	      "id": 10,
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
	          "valueSize": 24
	        },
	        "textMode": "name"
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "kube_pod_info{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\",node!=\"\"}",
	          "legendFormat": "{{node}}",
	          "range": true,
	          "refId": "A"
	        }
	      ],
	      "title": "Node",
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
	          }
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 2,
	        "w": 4,
	        "x": 16,
	        "y": 4
	      },
	      "id": 7,
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
	          "valueSize": 24
	        },
	        "textMode": "name"
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "kube_pod_info{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\",pod_ip!=\"\"}",
	          "legendFormat": "{{pod_ip}}",
	          "range": true,
	          "refId": "A"
	        }
	      ],
	      "title": "Pod IP",
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
	          }
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 2,
	        "w": 4,
	        "x": 20,
	        "y": 4
	      },
	      "id": 8,
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
	          "valueSize": 24
	        },
	        "textMode": "name"
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "kube_pod_info{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\",host_ip!=\"\"}",
	          "legendFormat": "{{host_ip}}",
	          "range": true,
	          "refId": "A"
	        }
	      ],
	      "title": "Host IP",
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
	            "align": "left",
	            "displayMode": "color-text",
	            "inspect": false
	          },
	          "mappings": [
	            {
	              "options": {
	                "10000": {
	                  "color": "yellow",
	                  "index": 4,
	                  "text": "False"
	                },
	                "10001": {
	                  "color": "green",
	                  "index": 5,
	                  "text": "True"
	                },
	                "30000": {
	                  "color": "yellow",
	                  "index": 0,
	                  "text": "Unknown"
	                },
	                "30001": {
	                  "color": "yellow",
	                  "index": 1,
	                  "text": "Waiting"
	                },
	                "30002": {
	                  "color": "green",
	                  "index": 2,
	                  "text": "Running"
	                },
	                "30004": {
	                  "color": "red",
	                  "index": 3,
	                  "text": "Terminated"
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
	              "options": "(Time .+)|(Value .+)|Waiting|Running|Terminated"
	            },
	            "properties": [
	              {
	                "id": "custom.hidden",
	                "value": true
	              }
	            ]
	          },
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
	              "options": "Age|Status|Ready|Restart"
	            },
	            "properties": [
	              {
	                "id": "custom.width",
	                "value": 100
	              }
	            ]
	          },
	          {
	            "matcher": {
	              "id": "byRegexp",
	              "options": "Restart"
	            },
	            "properties": [
	              {
	                "id": "mappings",
	                "value": [
	                  {
	                    "options": {
	                      "0": {
	                        "color": "green",
	                        "index": 0
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
	              "options": "(CPU|Memory) Usage"
	            },
	            "properties": [
	              {
	                "id": "unit",
	                "value": "percentunit"
	              },
	              {
	                "id": "thresholds",
	                "value": {
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
	                }
	              },
	              {
	                "id": "custom.displayMode",
	                "value": "lcd-gauge"
	              },
	              {
	                "id": "max",
	                "value": 1
	              },
	              {
	                "id": "decimals",
	                "value": 2
	              }
	            ]
	          },
	          {
	            "matcher": {
	              "id": "byRegexp",
	              "options": "(Memory|CPU) Limit"
	            },
	            "properties": [
	              {
	                "id": "custom.width",
	                "value": 120
	              },
	              {
	                "id": "decimals",
	                "value": 2
	              }
	            ]
	          },
	          {
	            "matcher": {
	              "id": "byRegexp",
	              "options": "Memory Limit"
	            },
	            "properties": [
	              {
	                "id": "unit",
	                "value": "bytes"
	              }
	            ]
	          },
	          {
	            "matcher": {
	              "id": "byRegexp",
	              "options": "CPU Limit"
	            },
	            "properties": [
	              {
	                "id": "unit",
	                "value": "cores"
	              }
	            ]
	          }
	        ]
	      },
	      "gridPos": {
	        "h": 5,
	        "w": 24,
	        "x": 0,
	        "y": 6
	      },
	      "id": 21,
	      "options": {
	        "footer": {
	          "fields": "",
	          "reducer": [
	            "sum"
	          ],
	          "show": false
	        },
	        "frameIndex": 3,
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
	          "expr": "sum(kube_pod_container_info{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\"}) by (container,image)",
	          "format": "table",
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
	          "expr": "time() - sum(kube_pod_container_state_started{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\"}) by (container)",
	          "format": "table",
	          "hide": false,
	          "instant": true,
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
	          "expr": "10000 + max(kube_pod_container_status_waiting{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\"}) by (container)",
	          "format": "table",
	          "hide": false,
	          "instant": true,
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
	          "expr": "10000 + 2 * max(kube_pod_container_status_running{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\"}) by (container)",
	          "format": "table",
	          "hide": false,
	          "instant": true,
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
	          "expr": "10000 + 4 * max(kube_pod_container_status_terminated{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\"}) by (container)",
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
	          "exemplar": false,
	          "expr": "10000 + max(kube_pod_container_status_ready{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\"}) by (container)",
	          "format": "table",
	          "hide": false,
	          "instant": true,
	          "range": false,
	          "refId": "F"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "exemplar": false,
	          "expr": "max(kube_pod_container_status_restarts_total{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\"}) by (container)",
	          "format": "table",
	          "hide": false,
	          "instant": true,
	          "range": false,
	          "refId": "G"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "exemplar": false,
	          "expr": "sum(container_memory_working_set_bytes{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\",container!=\"\"}) by (container) / sum(container_spec_memory_limit_bytes{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\",container!=\"\"}) by (container)",
	          "format": "table",
	          "hide": false,
	          "instant": true,
	          "range": false,
	          "refId": "H"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "exemplar": false,
	          "expr": "sum(rate(container_cpu_usage_seconds_total{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\",container!=\"\"}[5m])) by (container) / sum(container_spec_cpu_quota{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\",container!=\"\"}/100000) by (container)",
	          "format": "table",
	          "hide": false,
	          "instant": true,
	          "range": false,
	          "refId": "I"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "exemplar": false,
	          "expr": "sum(container_spec_memory_limit_bytes{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\",container!=\"\"}) by (container)",
	          "format": "table",
	          "hide": false,
	          "instant": true,
	          "range": false,
	          "refId": "J"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "exemplar": false,
	          "expr": "sum(container_spec_cpu_quota{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\",container!=\"\"}/100000) by (container)",
	          "format": "table",
	          "hide": false,
	          "instant": true,
	          "range": false,
	          "refId": "K"
	        }
	      ],
	      "title": "Containers",
	      "transformations": [
	        {
	          "id": "seriesToColumns",
	          "options": {
	            "byField": "container"
	          }
	        },
	        {
	          "id": "calculateField",
	          "options": {
	            "alias": "Status",
	            "mode": "reduceRow",
	            "reduce": {
	              "include": [
	                "Value #C",
	                "Value #D",
	                "Value #E"
	              ],
	              "reducer": "sum"
	            },
	            "replaceFields": false
	          }
	        },
	        {
	          "id": "organize",
	          "options": {
	            "excludeByName": {},
	            "indexByName": {
	              "Status": 13,
	              "Time 1": 1,
	              "Time 10": 21,
	              "Time 11": 24,
	              "Time 2": 3,
	              "Time 3": 4,
	              "Time 4": 6,
	              "Time 5": 8,
	              "Time 6": 10,
	              "Time 7": 15,
	              "Time 8": 17,
	              "Time 9": 18,
	              "Value #A": 2,
	              "Value #B": 12,
	              "Value #C": 5,
	              "Value #D": 7,
	              "Value #E": 9,
	              "Value #F": 14,
	              "Value #G": 16,
	              "Value #H": 23,
	              "Value #I": 20,
	              "Value #J": 22,
	              "Value #K": 19,
	              "container": 0,
	              "image": 11
	            },
	            "renameByName": {
	              "Value #A": "",
	              "Value #B": "Age",
	              "Value #C": "Waiting",
	              "Value #D": "Running",
	              "Value #E": "Terminated",
	              "Value #F": "Ready",
	              "Value #G": "Restart",
	              "Value #H": "Memory Usage",
	              "Value #I": "CPU Usage",
	              "Value #J": "Memory Limit",
	              "Value #K": "CPU Limit",
	              "container": "Container",
	              "image": "Image"
	            }
	          }
	        }
	      ],
	      "type": "table"
	    },
	    {
	      "collapsed": false,
	      "gridPos": {
	        "h": 1,
	        "w": 24,
	        "x": 0,
	        "y": 11
	      },
	      "id": 43,
	      "panels": [],
	      "title": "Resource",
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
	            "fixedColor": "#2879c27d",
	            "mode": "fixed"
	          },
	          "decimals": 2,
	          "mappings": [],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "text",
	                "value": null
	              }
	            ]
	          },
	          "unit": "bytes"
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 3,
	        "w": 4,
	        "x": 0,
	        "y": 12
	      },
	      "id": 24,
	      "options": {
	        "colorMode": "none",
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
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(container_memory_working_set_bytes{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\",container!=\"\"})",
	          "legendFormat": "Usage",
	          "range": true,
	          "refId": "A"
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
	      "description": "",
	      "fieldConfig": {
	        "defaults": {
	          "color": {
	            "fixedColor": "green",
	            "mode": "continuous-BlPu"
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
	            "lineStyle": {
	              "fill": "solid"
	            },
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
	          "mappings": [],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "text",
	                "value": null
	              }
	            ]
	          },
	          "unit": "bytes"
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 6,
	        "w": 8,
	        "x": 4,
	        "y": 12
	      },
	      "id": 31,
	      "options": {
	        "legend": {
	          "calcs": [],
	          "displayMode": "list",
	          "placement": "bottom"
	        },
	        "tooltip": {
	          "mode": "single",
	          "sort": "none"
	        }
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(container_memory_working_set_bytes{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\",container!=\"\"}) by (container)",
	          "legendFormat": "{{container}}",
	          "range": true,
	          "refId": "A"
	        }
	      ],
	      "title": "Memory Usage (by container)",
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
	            "fixedColor": "#2879c27d",
	            "mode": "fixed"
	          },
	          "decimals": 2,
	          "mappings": [],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "text",
	                "value": null
	              }
	            ]
	          },
	          "unit": "cores"
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 3,
	        "w": 4,
	        "x": 12,
	        "y": 12
	      },
	      "id": 27,
	      "options": {
	        "colorMode": "none",
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
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(rate(container_cpu_usage_seconds_total{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\",container!=\"\"}[5m]))",
	          "legendFormat": "Usage",
	          "range": true,
	          "refId": "A"
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
	      "description": "",
	      "fieldConfig": {
	        "defaults": {
	          "color": {
	            "fixedColor": "green",
	            "mode": "continuous-BlPu"
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
	            "lineStyle": {
	              "fill": "solid"
	            },
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
	          "mappings": [],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "text",
	                "value": null
	              }
	            ]
	          },
	          "unit": "cores"
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 6,
	        "w": 8,
	        "x": 16,
	        "y": 12
	      },
	      "id": 32,
	      "options": {
	        "legend": {
	          "calcs": [],
	          "displayMode": "list",
	          "placement": "bottom"
	        },
	        "tooltip": {
	          "mode": "single",
	          "sort": "none"
	        }
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(rate(container_cpu_usage_seconds_total{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\",container!=\"\"}[5m])) by (container)",
	          "legendFormat": "{{container}}",
	          "range": true,
	          "refId": "A"
	        }
	      ],
	      "title": "CPU Usage (by container)",
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
	            "fixedColor": "#2879c27d",
	            "mode": "fixed"
	          },
	          "decimals": 2,
	          "mappings": [],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "text",
	                "value": null
	              }
	            ]
	          },
	          "unit": "bytes"
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 3,
	        "w": 4,
	        "x": 0,
	        "y": 15
	      },
	      "id": 25,
	      "options": {
	        "colorMode": "none",
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
	            "uid": "${datasource}"
	          },
	          "expr": "sum(container_spec_memory_limit_bytes{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\",container!=\"\"})",
	          "hide": false,
	          "refId": "A"
	        }
	      ],
	      "title": "Memory Limit",
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
	            "fixedColor": "#2879c27d",
	            "mode": "fixed"
	          },
	          "decimals": 2,
	          "mappings": [],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "text",
	                "value": null
	              }
	            ]
	          },
	          "unit": "cores"
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 3,
	        "w": 4,
	        "x": 12,
	        "y": 15
	      },
	      "id": 28,
	      "options": {
	        "colorMode": "none",
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
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(container_spec_cpu_quota{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\",container!=\"\"}/100000)",
	          "legendFormat": "Usage",
	          "range": true,
	          "refId": "A"
	        }
	      ],
	      "title": "CPU Limit",
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
	            "fixedColor": "#2879c27d",
	            "mode": "fixed"
	          },
	          "decimals": 2,
	          "mappings": [],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "text",
	                "value": null
	              }
	            ]
	          },
	          "unit": "binBps"
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 3,
	        "w": 4,
	        "x": 0,
	        "y": 18
	      },
	      "id": 34,
	      "options": {
	        "colorMode": "none",
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
	            "uid": "${datasource}"
	          },
	          "expr": "sum(rate(container_network_receive_bytes_total{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\"}[5m]))",
	          "hide": false,
	          "refId": "A"
	        }
	      ],
	      "title": "Network In",
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
	            "fixedColor": "#2879c27d",
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
	          "mappings": [],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "text",
	                "value": null
	              }
	            ]
	          },
	          "unit": "binBps"
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 6,
	        "w": 8,
	        "x": 4,
	        "y": 18
	      },
	      "id": 30,
	      "options": {
	        "legend": {
	          "calcs": [],
	          "displayMode": "list",
	          "placement": "bottom"
	        },
	        "tooltip": {
	          "mode": "single",
	          "sort": "none"
	        }
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(rate(container_network_receive_bytes_total{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\"}[5m]))",
	          "legendFormat": "In",
	          "range": true,
	          "refId": "A"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "-sum(rate(container_network_transmit_bytes_total{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\"}[5m]))",
	          "hide": false,
	          "legendFormat": "Out",
	          "range": true,
	          "refId": "B"
	        }
	      ],
	      "title": "Network IO",
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
	            "fixedColor": "#2879c27d",
	            "mode": "fixed"
	          },
	          "decimals": 2,
	          "mappings": [],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "text",
	                "value": null
	              }
	            ]
	          },
	          "unit": "binBps"
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 3,
	        "w": 4,
	        "x": 12,
	        "y": 18
	      },
	      "id": 36,
	      "options": {
	        "colorMode": "none",
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
	            "uid": "${datasource}"
	          },
	          "expr": "sum(rate(container_fs_reads_bytes_total{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\",container!=\"\"}[5m]))",
	          "hide": false,
	          "refId": "A"
	        }
	      ],
	      "title": "Disk Read",
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
	            "fixedColor": "#2879c27d",
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
	          "mappings": [],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "text",
	                "value": null
	              }
	            ]
	          },
	          "unit": "binBps"
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 6,
	        "w": 8,
	        "x": 16,
	        "y": 18
	      },
	      "id": 33,
	      "options": {
	        "legend": {
	          "calcs": [],
	          "displayMode": "list",
	          "placement": "bottom"
	        },
	        "tooltip": {
	          "mode": "single",
	          "sort": "none"
	        }
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(rate(container_fs_reads_bytes_total{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\",container!=\"\"}[5m]))",
	          "legendFormat": "Read",
	          "range": true,
	          "refId": "A"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "-sum(rate(container_fs_writes_bytes_total{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\",container!=\"\"}[5m]))",
	          "hide": false,
	          "legendFormat": "Write",
	          "range": true,
	          "refId": "B"
	        }
	      ],
	      "title": "Disk IO",
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
	            "fixedColor": "#2879c27d",
	            "mode": "fixed"
	          },
	          "decimals": 2,
	          "mappings": [],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "text",
	                "value": null
	              }
	            ]
	          },
	          "unit": "binBps"
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 3,
	        "w": 4,
	        "x": 0,
	        "y": 21
	      },
	      "id": 35,
	      "options": {
	        "colorMode": "none",
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
	            "uid": "${datasource}"
	          },
	          "expr": "sum(rate(container_network_transmit_bytes_total{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\"}[5m]))",
	          "hide": false,
	          "refId": "A"
	        }
	      ],
	      "title": "Network Out",
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
	            "fixedColor": "#2879c27d",
	            "mode": "fixed"
	          },
	          "decimals": 2,
	          "mappings": [],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "text",
	                "value": null
	              }
	            ]
	          },
	          "unit": "binBps"
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 3,
	        "w": 4,
	        "x": 12,
	        "y": 21
	      },
	      "id": 37,
	      "options": {
	        "colorMode": "none",
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
	            "uid": "${datasource}"
	          },
	          "expr": "sum(rate(container_fs_writes_bytes_total{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\",container!=\"\"}[5m]))",
	          "hide": false,
	          "refId": "A"
	        }
	      ],
	      "title": "Disk Write",
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
	            "fixedColor": "#2879c27d",
	            "mode": "fixed"
	          },
	          "decimals": 0,
	          "mappings": [],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "text",
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
	        "w": 4,
	        "x": 0,
	        "y": 24
	      },
	      "id": 46,
	      "options": {
	        "colorMode": "none",
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
	            "uid": "${datasource}"
	          },
	          "expr": "sum(container_processes{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\",container!=\"\"})",
	          "hide": false,
	          "refId": "A"
	        }
	      ],
	      "title": "Processes",
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
	            "fixedColor": "#2879c27d",
	            "mode": "fixed"
	          },
	          "decimals": 0,
	          "mappings": [],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "text",
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
	        "w": 4,
	        "x": 4,
	        "y": 24
	      },
	      "id": 47,
	      "options": {
	        "colorMode": "none",
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
	            "uid": "${datasource}"
	          },
	          "expr": "sum(container_threads{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\",container!=\"\"})",
	          "hide": false,
	          "refId": "A"
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
	      "description": "",
	      "fieldConfig": {
	        "defaults": {
	          "color": {
	            "fixedColor": "#2879c27d",
	            "mode": "fixed"
	          },
	          "decimals": 0,
	          "mappings": [],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "text",
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
	        "w": 4,
	        "x": 8,
	        "y": 24
	      },
	      "id": 48,
	      "options": {
	        "colorMode": "none",
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
	            "uid": "${datasource}"
	          },
	          "expr": "sum(container_sockets{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\",container!=\"\"})",
	          "hide": false,
	          "refId": "A"
	        }
	      ],
	      "title": "Sockets",
	      "type": "stat"
	    },
	    {
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "description": "The usage of high-speed cache between CPU and Memory.",
	      "fieldConfig": {
	        "defaults": {
	          "color": {
	            "fixedColor": "#2879c27d",
	            "mode": "fixed"
	          },
	          "decimals": 2,
	          "mappings": [],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "text",
	                "value": null
	              }
	            ]
	          },
	          "unit": "bytes"
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 3,
	        "w": 4,
	        "x": 12,
	        "y": 24
	      },
	      "id": 49,
	      "options": {
	        "colorMode": "none",
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
	            "uid": "${datasource}"
	          },
	          "expr": "sum(container_memory_cache{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\",container!=\"\"})",
	          "hide": false,
	          "refId": "A"
	        }
	      ],
	      "title": "Memory Cache",
	      "type": "stat"
	    },
	    {
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "description": "User cpu time consumed percentage.",
	      "fieldConfig": {
	        "defaults": {
	          "color": {
	            "fixedColor": "#2879c27d",
	            "mode": "fixed"
	          },
	          "decimals": 2,
	          "mappings": [],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "text",
	                "value": null
	              }
	            ]
	          },
	          "unit": "percentunit"
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 3,
	        "w": 4,
	        "x": 16,
	        "y": 24
	      },
	      "id": 50,
	      "options": {
	        "colorMode": "none",
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
	            "uid": "${datasource}"
	          },
	          "expr": "sum(rate(container_cpu_user_seconds_total{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\",container!=\"\"}[5m])) / sum(rate(container_cpu_usage_seconds_total{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\",container!=\"\"}[5m]))",
	          "hide": false,
	          "refId": "A"
	        }
	      ],
	      "title": "CPU User Time Percent",
	      "type": "stat"
	    },
	    {
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "description": "The number of network errors including receiving and transmitting.",
	      "fieldConfig": {
	        "defaults": {
	          "color": {
	            "fixedColor": "#2879c27d",
	            "mode": "thresholds"
	          },
	          "decimals": 2,
	          "mappings": [],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "green",
	                "value": null
	              },
	              {
	                "color": "red",
	                "value": 1
	              }
	            ]
	          },
	          "unit": "none"
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 3,
	        "w": 4,
	        "x": 20,
	        "y": 24
	      },
	      "id": 51,
	      "options": {
	        "colorMode": "value",
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
	            "uid": "${datasource}"
	          },
	          "expr": "sum(container_network_receive_errors_total{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\"}) + sum(container_network_transmit_errors_total{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\"})",
	          "hide": false,
	          "refId": "A"
	        }
	      ],
	      "title": "Network Errors",
	      "type": "stat"
	    },
	    {
	      "collapsed": false,
	      "gridPos": {
	        "h": 1,
	        "w": 24,
	        "x": 0,
	        "y": 27
	      },
	      "id": 40,
	      "panels": [],
	      "title": "Logs",
	      "type": "row"
	    },
	    {
	      "datasource": {
	        "type": "loki",
	        "uid": "${logsource}"
	      },
	      "gridPos": {
	        "h": 10,
	        "w": 24,
	        "x": 0,
	        "y": 28
	      },
	      "id": 6,
	      "options": {
	        "dedupStrategy": "none",
	        "enableLogDetails": true,
	        "prettifyLogMessage": false,
	        "showCommonLabels": false,
	        "showLabels": false,
	        "showTime": false,
	        "sortOrder": "Descending",
	        "wrapLogMessage": false
	      },
	      "pluginVersion": "8.5.3",
	      "repeat": "container",
	      "repeatDirection": "v",
	      "targets": [
	        {
	          "datasource": {
	            "type": "loki",
	            "uid": "${logsource}"
	          },
	          "expr": "{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\",container=\"$container\"} | json | line_format \"{{.message}}\"",
	          "queryType": "range",
	          "refId": "A"
	        }
	      ],
	      "title": "Logs ($container)",
	      "type": "logs"
	    }
	  ],
	  "style": "dark",
	  "tags": ["kubernetes", "resource"],
	  "templating": {
	    "list": [
	      {
	        "hide": 2,
	        "includeAll": false,
	        "label": "Data Source",
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
	        "hide": 2,
	        "includeAll": false,
	        "label": "Log Source",
	        "multi": false,
	        "name": "logsource",
	        "options": [],
	        "query": "loki",
	        "refresh": 1,
	        "regex": "",
	        "skipUrlSync": false,
	        "type": "datasource"
	      },
	      {
	        "current": {
	          "selected": true,
	          "text": "local",
	          "value": "local"
	        },
	        "datasource": {
	          "type": "prometheus",
	          "uid": "${datasource}"
	        },
	        "definition": "label_values(up,cluster)",
	        "hide": 0,
	        "includeAll": false,
	        "label": "Cluster",
	        "multi": false,
	        "name": "cluster",
	        "options": [],
	        "query": {
	          "query": "label_values(up,cluster)",
	          "refId": "StandardVariableQuery"
	        },
	        "refresh": 1,
	        "regex": "",
	        "skipUrlSync": false,
	        "sort": 0,
	        "type": "query"
	      },
	      {
	        "current": {
	          "selected": true,
	          "text": "vela-system",
	          "value": "vela-system"
	        },
	        "datasource": {
	          "type": "prometheus",
	          "uid": "${datasource}"
	        },
	        "definition": "label_values(kube_pod_info{cluster=\"$cluster\"},namespace)",
	        "hide": 0,
	        "includeAll": false,
	        "label": "Namespace",
	        "multi": false,
	        "name": "namespace",
	        "options": [],
	        "query": {
	          "query": "label_values(kube_pod_info{cluster=\"$cluster\"},namespace)",
	          "refId": "StandardVariableQuery"
	        },
	        "refresh": 1,
	        "regex": "",
	        "skipUrlSync": false,
	        "sort": 0,
	        "type": "query"
	      },
	      {
	        "datasource": {
	          "type": "prometheus",
	          "uid": "${datasource}"
	        },
	        "definition": "label_values(kube_pod_info{cluster=\"$cluster\",namespace=\"$namespace\"},pod)",
	        "hide": 0,
	        "includeAll": false,
	        "label": "Pod",
	        "multi": false,
	        "name": "pod",
	        "options": [],
	        "query": {
	          "query": "label_values(kube_pod_info{cluster=\"$cluster\",namespace=\"$namespace\"},pod)",
	          "refId": "StandardVariableQuery"
	        },
	        "refresh": 1,
	        "regex": "",
	        "skipUrlSync": false,
	        "sort": 0,
	        "type": "query"
	      },
	      {
	        "current": {
	          "selected": false,
	          "text": "kubevela",
	          "value": "kubevela"
	        },
	        "datasource": {
	          "type": "prometheus",
	          "uid": "${datasource}"
	        },
	        "definition": "label_values(kube_pod_container_info{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\"},container)",
	        "hide": 2,
	        "includeAll": false,
	        "label": "Container",
	        "multi": true,
	        "name": "container",
	        "options": [],
	        "query": {
	          "query": "label_values(kube_pod_container_info{cluster=\"$cluster\",namespace=\"$namespace\",pod=\"$pod\"},container)",
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
	  "timepicker": {},
	  "timezone": "",
	  "title": "Kubernetes Pod",
	  "uid": "kubernetes-pod",
	  "version": 2,
	  "weekStart": ""
	}
	"""#
