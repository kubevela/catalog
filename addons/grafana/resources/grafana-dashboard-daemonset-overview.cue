package main

grafanaDashboardDaemonSetOverview: {
	name: "grafana-dashboard-daemonset-overview"
	type: "grafana-dashboard"
	properties: {
		uid:     "kubernetes-daemonset"
		grafana: parameter.grafanaName
		data:    grafanaDashboardDaemonSetOverviewData
	}
}

grafanaDashboardDaemonSetOverviewData: #"""
	{
	  "description": "Kubernetes DaemonSet Overview",
	  "editable": true,
	  "panels": [
	    {
	      "gridPos": {
	        "h": 1,
	        "w": 24,
	        "x": 0,
	        "y": 0
	      },
	      "id": 55,
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
	      "id": 38,
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
	        "textMode": "name"
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "prometheus:local"
	          },
	          "editorMode": "code",
	          "exemplar": false,
	          "expr": "kube_daemonset_created{cluster=\"$cluster\",namespace=\"$namespace\",daemonset=\"$name\"}",
	          "instant": true,
	          "legendFormat": "$name",
	          "range": false,
	          "refId": "A"
	        }
	      ],
	      "title": "DaemonSet Name",
	      "type": "stat"
	    },
	    {
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "description": "Number of desired replicas to schedule.",
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
	        "w": 4,
	        "x": 12,
	        "y": 1
	      },
	      "id": 44,
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
	        "textMode": "value"
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "prometheus:local"
	          },
	          "editorMode": "code",
	          "exemplar": false,
	          "expr": "kube_daemonset_status_desired_number_scheduled{cluster=\"$cluster\",namespace=\"$namespace\",daemonset=\"$name\"}",
	          "instant": true,
	          "legendFormat": "__auto",
	          "range": false,
	          "refId": "A"
	        }
	      ],
	      "title": "Replicas",
	      "type": "stat"
	    },
	    {
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "description": "The portion of ready replicas.",
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
	        "overrides": [
	          {
	            "matcher": {
	              "id": "byName",
	              "options": "Percentage"
	            },
	            "properties": [
	              {
	                "id": "unit",
	                "value": "percentunit"
	              },
	              {
	                "id": "mappings",
	                "value": [
	                  {
	                    "options": {
	                      "0": {
	                        "color": "red",
	                        "index": 0
	                      },
	                      "1": {
	                        "color": "green",
	                        "index": 2
	                      }
	                    },
	                    "type": "value"
	                  },
	                  {
	                    "options": {
	                      "from": 0,
	                      "result": {
	                        "color": "yellow",
	                        "index": 1
	                      },
	                      "to": 1
	                    },
	                    "type": "range"
	                  }
	                ]
	              }
	            ]
	          }
	        ]
	      },
	      "gridPos": {
	        "h": 3,
	        "w": 4,
	        "x": 16,
	        "y": 1
	      },
	      "id": 50,
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
	          "expr": "kube_daemonset_status_number_ready{cluster=\"$cluster\",namespace=\"$namespace\",daemonset=\"$name\"} / kube_daemonset_status_desired_number_scheduled{cluster=\"$cluster\",namespace=\"$namespace\",daemonset=\"$name\"}",
	          "hide": false,
	          "instant": true,
	          "legendFormat": "Percentage",
	          "range": false,
	          "refId": "B"
	        }
	      ],
	      "title": "Ready",
	      "type": "stat"
	    },
	    {
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "description": "Whether all replicas are up-to-date.",
	      "fieldConfig": {
	        "defaults": {
	          "color": {
	            "mode": "thresholds"
	          },
	          "mappings": [
	            {
	              "options": {
	                "0": {
	                  "color": "green",
	                  "index": 0,
	                  "text": "True"
	                }
	              },
	              "type": "value"
	            },
	            {
	              "options": {
	                "from": 0,
	                "result": {
	                  "color": "red",
	                  "index": 1,
	                  "text": "False"
	                }
	              },
	              "type": "range"
	            }
	          ],
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
	        "w": 4,
	        "x": 20,
	        "y": 1
	      },
	      "id": 60,
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
	        "textMode": "value"
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "prometheus:local"
	          },
	          "editorMode": "code",
	          "exemplar": false,
	          "expr": "(kube_daemonset_metadata_generation{cluster=\"$cluster\",daemonset=\"$name\",namespace=\"$namespace\"} - kube_daemonset_status_observed_generation{cluster=\"$cluster\",daemonset=\"$name\",namespace=\"$namespace\"}) ^ 2 + (kube_daemonset_status_desired_number_scheduled{cluster=\"$cluster\",daemonset=\"$name\",namespace=\"$namespace\"} - kube_daemonset_status_updated_number_scheduled{cluster=\"$cluster\",daemonset=\"$name\",namespace=\"$namespace\"}) ^ 2",
	          "instant": true,
	          "legendFormat": "__auto",
	          "range": false,
	          "refId": "A"
	        }
	      ],
	      "title": "Updated",
	      "type": "stat"
	    },
	    {
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "description": "The image of the container in daemonset pods. If multiple images exist, a random one will be displayed.",
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
	        "w": 12,
	        "x": 0,
	        "y": 4
	      },
	      "id": 45,
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
	          "valueSize": 24
	        },
	        "textMode": "name"
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "prometheus:local"
	          },
	          "editorMode": "code",
	          "exemplar": false,
	          "expr": "sum(kube_pod_info{cluster=\"$cluster\",namespace=\"$namespace\",created_by_kind=\"DaemonSet\",created_by_name=\"$name\"}) by (uid)\n* on(uid) group_right() sum(kube_pod_container_info{cluster=\"$cluster\",namespace=\"$namespace\"}) by (uid, image)",
	          "format": "time_series",
	          "instant": true,
	          "legendFormat": "{{image}}",
	          "range": false,
	          "refId": "A"
	        }
	      ],
	      "title": "Image",
	      "transformations": [
	        {
	          "id": "merge",
	          "options": {}
	        }
	      ],
	      "type": "stat"
	    },
	    {
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "description": "The pod name of the daemonset. If multiple pods exist, a random one will be displayed.",
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
	        "w": 8,
	        "x": 12,
	        "y": 4
	      },
	      "id": 65,
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
	          "valueSize": 24
	        },
	        "textMode": "name"
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "prometheus:local"
	          },
	          "editorMode": "code",
	          "exemplar": false,
	          "expr": "sum(kube_pod_info{cluster=\"$cluster\",namespace=\"$namespace\",created_by_kind=\"DaemonSet\",created_by_name=\"$name\"}) by (pod, uid)",
	          "instant": true,
	          "legendFormat": "{{pod}}",
	          "range": false,
	          "refId": "A"
	        }
	      ],
	      "title": "Pod",
	      "transformations": [
	        {
	          "id": "merge",
	          "options": {}
	        }
	      ],
	      "type": "stat"
	    },
	    {
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "description": "Time since daemonset created.",
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
	        "h": 2,
	        "w": 4,
	        "x": 20,
	        "y": 4
	      },
	      "id": 61,
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
	          "valueSize": 24
	        },
	        "textMode": "value"
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "prometheus:local"
	          },
	          "editorMode": "code",
	          "exemplar": false,
	          "expr": "time() - kube_daemonset_created{cluster=\"$cluster\",namespace=\"$namespace\",daemonset=\"$name\"}",
	          "instant": true,
	          "legendFormat": "__auto",
	          "range": false,
	          "refId": "A"
	        }
	      ],
	      "title": "Age",
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
	              "options": "Restarts|Age|Dashboard"
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
	              "options": "IP|Node|Dashboard"
	            },
	            "properties": [
	              {
	                "id": "custom.width",
	                "value": 120
	              }
	            ]
	          }
	        ]
	      },
	      "gridPos": {
	        "h": 6,
	        "w": 16,
	        "x": 0,
	        "y": 6
	      },
	      "id": 36,
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
	          "expr": "sum(kube_pod_info{cluster=\"$cluster\",namespace=\"$namespace\",created_by_kind=\"DaemonSet\",created_by_name=\"$name\"}) by (uid, pod, pod_ip, node)",
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
	          "expr": "sum(kube_pod_status_phase{cluster=\"$cluster\",namespace=\"$namespace\"} * (kube_pod_status_phase{cluster=\"$cluster\",namespace=\"$namespace\"} > 0)) by (uid, phase)",
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
	          "expr": "sum(kube_pod_status_ready{cluster=\"$cluster\",namespace=\"$namespace\"} * (kube_pod_status_ready{cluster=\"$cluster\",namespace=\"$namespace\"} > 0)) by (uid, condition)",
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
	          "expr": "time() - max(kube_pod_created{cluster=\"$cluster\",namespace=\"$namespace\"}) by (uid)",
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
	          "expr": "sum(max(kube_pod_container_status_restarts_total{cluster=\"$cluster\",namespace=\"$namespace\"}) by (uid, container)) by (uid)",
	          "format": "table",
	          "hide": false,
	          "instant": true,
	          "range": false,
	          "refId": "E"
	        }
	      ],
	      "title": "Pods",
	      "transformations": [
	        {
	          "id": "seriesToColumns",
	          "options": {
	            "byField": "uid"
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
	              "Time 1": 9,
	              "Time 2": 12,
	              "Time 3": 14,
	              "Time 4": 16,
	              "Time 5": 17,
	              "Value #A": 11,
	              "Value #B": 13,
	              "Value #C": 15,
	              "Value #D": 5,
	              "Value #E": 4,
	              "condition": 2,
	              "created_by_name": 10,
	              "node": 7,
	              "phase": 3,
	              "pod": 1,
	              "pod_ip": 6,
	              "replicaset": 8,
	              "uid": 0
	            },
	            "renameByName": {
	              "Value #C": "",
	              "Value #D": "Age",
	              "Value #E": "Restarts",
	              "condition": "Ready",
	              "created_by_name": "",
	              "node": "Node",
	              "phase": "Status",
	              "pod": "Pod",
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
	                "Node"
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
	      "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	      },
	      "description": "",
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
	        "h": 6,
	        "w": 8,
	        "x": 16,
	        "y": 6
	      },
	      "id": 1,
	      "links": [],
	      "options": {
	        "legend": {
	          "calcs": [],
	          "displayMode": "list",
	          "placement": "bottom"
	        },
	        "tooltip": {
	          "mode": "multi",
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
	          "expr": "max(kube_daemonset_status_desired_number_scheduled{daemonset=\"$name\",namespace=\"$namespace\",cluster=\"$cluster\"}) without (instance, pod)",
	          "intervalFactor": 1,
	          "legendFormat": "Desired",
	          "range": true,
	          "refId": "A",
	          "step": 30
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "max(kube_daemonset_status_current_number_scheduled{daemonset=\"$name\",namespace=\"$namespace\",cluster=\"$cluster\"}) without (instance, pod)",
	          "intervalFactor": 1,
	          "legendFormat": "Current",
	          "range": true,
	          "refId": "B",
	          "step": 30
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "min(kube_daemonset_status_number_ready{daemonset=\"$name\",namespace=\"$namespace\",cluster=\"$cluster\"}) without (instance, pod)",
	          "intervalFactor": 1,
	          "legendFormat": "Ready",
	          "range": true,
	          "refId": "C",
	          "step": 30
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "min(kube_daemonset_status_number_available{daemonset=\"$name\",namespace=\"$namespace\",cluster=\"$cluster\"}) without (instance, pod)",
	          "intervalFactor": 1,
	          "legendFormat": "Available",
	          "range": true,
	          "refId": "D",
	          "step": 30
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "min(kube_daemonset_status_updated_number_scheduled{daemonset=\"$name\",namespace=\"$namespace\",cluster=\"$cluster\"}) without (instance, pod)",
	          "intervalFactor": 1,
	          "legendFormat": "Updated",
	          "range": true,
	          "refId": "E",
	          "step": 30
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "min(kube_daemonset_status_number_unavailable{daemonset=\"$name\",namespace=\"$namespace\",cluster=\"$cluster\"}) without (instance, pod)",
	          "hide": false,
	          "intervalFactor": 1,
	          "legendFormat": "Unavailable",
	          "range": true,
	          "refId": "F",
	          "step": 30
	        }
	      ],
	      "title": "Replicas",
	      "type": "timeseries"
	    },
	    {
	      "gridPos": {
	        "h": 1,
	        "w": 24,
	        "x": 0,
	        "y": 12
	      },
	      "id": 22,
	      "title": "Resource",
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
	        "h": 3,
	        "w": 4,
	        "x": 0,
	        "y": 13
	      },
	      "id": 8,
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
	          "expr": "sum(sum(kube_pod_info{cluster=\"$cluster\",namespace=\"$namespace\",created_by_kind=\"DaemonSet\",created_by_name=\"$name\"}) by (pod)\n* on(pod) group_right() sum(container_memory_working_set_bytes{cluster=\"$cluster\",namespace=\"$namespace\",container!=\"\"}) by (pod))",
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
	        "h": 6,
	        "w": 8,
	        "x": 4,
	        "y": 13
	      },
	      "id": 13,
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
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(kube_pod_info{cluster=\"$cluster\",namespace=\"$namespace\",created_by_kind=\"DaemonSet\",created_by_name=\"$name\"}) by (pod)\n* on(pod) group_right() sum(container_memory_working_set_bytes{cluster=\"$cluster\",namespace=\"$namespace\",container!=\"\"}) by (pod)",
	          "legendFormat": "__auto",
	          "range": true,
	          "refId": "A"
	        }
	      ],
	      "title": "Memory Usage (by pod)",
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
	        "h": 3,
	        "w": 4,
	        "x": 12,
	        "y": 13
	      },
	      "id": 15,
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
	        "textMode": "auto"
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "expr": "sum(sum(kube_pod_info{cluster=\"$cluster\",namespace=\"$namespace\",created_by_kind=\"DaemonSet\",created_by_name=\"$name\"}) by (pod)\n* on(pod) group_right() sum(rate(container_cpu_usage_seconds_total{cluster=\"$cluster\",namespace=\"$namespace\",container!=\"\"}[5m])) by (pod))",
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
	        "h": 6,
	        "w": 8,
	        "x": 16,
	        "y": 13
	      },
	      "id": 11,
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
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(kube_pod_info{cluster=\"$cluster\",namespace=\"$namespace\",created_by_kind=\"DaemonSet\",created_by_name=\"$name\"}) by (pod)\n* on(pod) group_right() sum(rate(container_cpu_usage_seconds_total{cluster=\"$cluster\",namespace=\"$namespace\",container!=\"\"}[5m])) by (pod)",
	          "legendFormat": "{{pod}}",
	          "range": true,
	          "refId": "A"
	        }
	      ],
	      "title": "CPU Usage (by pod)",
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
	        "h": 3,
	        "w": 4,
	        "x": 0,
	        "y": 16
	      },
	      "id": 16,
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
	        "textMode": "auto"
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "expr": "sum(sum(kube_pod_info{cluster=\"$cluster\",namespace=\"$namespace\",created_by_kind=\"DaemonSet\",created_by_name=\"$name\"}) by (pod)\n* on(pod) group_right() sum(container_spec_memory_limit_bytes{cluster=\"$cluster\",namespace=\"$namespace\",container!=\"\"}) by (pod))",
	          "intervalFactor": 2,
	          "refId": "A",
	          "step": 600
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
	        "h": 3,
	        "w": 4,
	        "x": 12,
	        "y": 16
	      },
	      "id": 17,
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
	        "textMode": "auto"
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "expr": "sum(sum(kube_pod_info{cluster=\"$cluster\",namespace=\"$namespace\",created_by_kind=\"DaemonSet\",created_by_name=\"$name\"}) by (pod)\n* on(pod) group_right() sum(container_spec_cpu_quota{cluster=\"$cluster\",namespace=\"$namespace\",container!=\"\"}/100000) by (pod))",
	          "intervalFactor": 2,
	          "refId": "A",
	          "step": 600
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
	        "h": 3,
	        "w": 4,
	        "x": 0,
	        "y": 19
	      },
	      "id": 68,
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
	          "expr": "sum(sum(kube_pod_info{cluster=\"$cluster\",namespace=\"$namespace\",created_by_kind=\"DaemonSet\",created_by_name=\"$name\"}) by (pod)\n* on(pod) group_right() sum(rate(container_network_receive_bytes_total{cluster=\"$cluster\",namespace=\"$namespace\"}[5m])) by (pod))",
	          "intervalFactor": 2,
	          "refId": "A",
	          "step": 600
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
	          "unit": "binBps"
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 6,
	        "w": 8,
	        "x": 4,
	        "y": 19
	      },
	      "id": 70,
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
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(sum(kube_pod_info{cluster=\"$cluster\",namespace=\"$namespace\",created_by_kind=\"DaemonSet\",created_by_name=\"$name\"}) by (pod)\n* on(pod) group_right() sum(rate(container_network_receive_bytes_total{cluster=\"$cluster\",namespace=\"$namespace\"}[5m])) by (pod))",
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
	          "expr": "-sum(sum(kube_pod_info{cluster=\"$cluster\",namespace=\"$namespace\",created_by_kind=\"DaemonSet\",created_by_name=\"$name\"}) by (pod)\n* on(pod) group_right() sum(rate(container_network_transmit_bytes_total{cluster=\"$cluster\",namespace=\"$namespace\"}[5m])) by (pod))",
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
	        "h": 3,
	        "w": 4,
	        "x": 12,
	        "y": 19
	      },
	      "id": 71,
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
	          "expr": "sum(sum(kube_pod_info{cluster=\"$cluster\",namespace=\"$namespace\",created_by_kind=\"DaemonSet\",created_by_name=\"$name\"}) by (pod)\n* on(pod) group_right() sum(rate(container_fs_reads_bytes_total{cluster=\"$cluster\",namespace=\"$namespace\",container!=\"\"}[5m])) by (pod))",
	          "intervalFactor": 2,
	          "refId": "A",
	          "step": 600
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
	          "unit": "binBps"
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 6,
	        "w": 8,
	        "x": 16,
	        "y": 19
	      },
	      "id": 73,
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
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(sum(kube_pod_info{cluster=\"$cluster\",namespace=\"$namespace\",created_by_kind=\"DaemonSet\",created_by_name=\"$name\"}) by (pod)\n* on(pod) group_right() sum(rate(container_fs_reads_bytes_total{cluster=\"$cluster\",namespace=\"$namespace\"}[5m])) by (pod))",
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
	          "expr": "-sum(sum(kube_pod_info{cluster=\"$cluster\",namespace=\"$namespace\",created_by_kind=\"DaemonSet\",created_by_name=\"$name\"}) by (pod)\n* on(pod) group_right() sum(rate(container_fs_writes_bytes_total{cluster=\"$cluster\",namespace=\"$namespace\"}[5m])) by (pod))",
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
	        "h": 3,
	        "w": 4,
	        "x": 0,
	        "y": 22
	      },
	      "id": 69,
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
	          "expr": "sum(sum(kube_pod_info{cluster=\"$cluster\",namespace=\"$namespace\",created_by_kind=\"DaemonSet\",created_by_name=\"$name\"}) by (pod)\n* on(pod) group_right() sum(rate(container_network_transmit_bytes_total{cluster=\"$cluster\",namespace=\"$namespace\"}[5m])) by (pod))",
	          "intervalFactor": 2,
	          "refId": "A",
	          "step": 600
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
	        "h": 3,
	        "w": 4,
	        "x": 12,
	        "y": 22
	      },
	      "id": 72,
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
	          "expr": "sum(sum(kube_pod_info{cluster=\"$cluster\",namespace=\"$namespace\",created_by_kind=\"DaemonSet\",created_by_name=\"$name\"}) by (pod)\n* on(pod) group_right() sum(rate(container_fs_writes_bytes_total{cluster=\"$cluster\",namespace=\"$namespace\",container!=\"\"}[5m])) by (pod))",
	          "intervalFactor": 2,
	          "refId": "A",
	          "step": 600
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
	          "unit": "none"
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 3,
	        "w": 4,
	        "x": 0,
	        "y": 25
	      },
	      "id": 74,
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
	          "expr": "sum(sum(kube_pod_info{cluster=\"$cluster\",namespace=\"$namespace\",created_by_kind=\"DaemonSet\",created_by_name=\"$name\"}) by (pod)\n* on(pod) group_right() sum(container_processes{cluster=\"$cluster\",namespace=\"$namespace\",container!=\"\"}) by (pod))",
	          "intervalFactor": 2,
	          "refId": "A",
	          "step": 600
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
	          "unit": "none"
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 3,
	        "w": 4,
	        "x": 4,
	        "y": 25
	      },
	      "id": 75,
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
	          "expr": "sum(sum(kube_pod_info{cluster=\"$cluster\",namespace=\"$namespace\",created_by_kind=\"DaemonSet\",created_by_name=\"$name\"}) by (pod)\n* on(pod) group_right() sum(container_threads{cluster=\"$cluster\",namespace=\"$namespace\",container!=\"\"}) by (pod))",
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
	          "unit": "none"
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 3,
	        "w": 4,
	        "x": 8,
	        "y": 25
	      },
	      "id": 76,
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
	          "expr": "sum(sum(kube_pod_info{cluster=\"$cluster\",namespace=\"$namespace\",created_by_kind=\"DaemonSet\",created_by_name=\"$name\"}) by (pod)\n* on(pod) group_right() sum(container_sockets{cluster=\"$cluster\",namespace=\"$namespace\",container!=\"\"}) by (pod))",
	          "intervalFactor": 2,
	          "refId": "A",
	          "step": 600
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
	        "h": 3,
	        "w": 4,
	        "x": 12,
	        "y": 25
	      },
	      "id": 77,
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
	          "expr": "sum(sum(kube_pod_info{cluster=\"$cluster\",namespace=\"$namespace\",created_by_kind=\"DaemonSet\",created_by_name=\"$name\"}) by (pod)\n* on(pod) group_right() sum(container_memory_cache{cluster=\"$cluster\",namespace=\"$namespace\",container!=\"\"}) by (pod))",
	          "intervalFactor": 2,
	          "refId": "A",
	          "step": 600
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
	          "unit": "percentunit"
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 3,
	        "w": 4,
	        "x": 16,
	        "y": 25
	      },
	      "id": 78,
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
	          "expr": "avg(sum(kube_pod_info{cluster=\"$cluster\",namespace=\"$namespace\",created_by_kind=\"DaemonSet\",created_by_name=\"$name\"}) by (pod)\n* on(pod) group_right() (sum(rate(container_cpu_user_seconds_total{cluster=\"$cluster\",namespace=\"$namespace\",container!=\"\"}[5m])) by (pod) / sum(rate(container_cpu_usage_seconds_total{cluster=\"$cluster\",namespace=\"$namespace\",container!=\"\"}[5m])) by (pod)))",
	          "intervalFactor": 2,
	          "refId": "A",
	          "step": 600
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
	            "mode": "thresholds"
	          },
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
	        "y": 25
	      },
	      "id": 26,
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
	          "expr": "sum(sum(kube_pod_info{cluster=\"$cluster\",namespace=\"$namespace\",created_by_kind=\"DaemonSet\",created_by_name=\"$name\"}) by (pod)\n* on(pod) group_right() (sum(container_network_receive_errors_total{cluster=\"$cluster\",namespace=\"$namespace\"}) by (pod) + sum(container_network_transmit_errors_total{cluster=\"$cluster\",namespace=\"$namespace\"}) by (pod)))",
	          "hide": false,
	          "legendFormat": "__auto",
	          "range": true,
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
	        "y": 28
	      },
	      "id": 67,
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
	        "h": 8,
	        "w": 24,
	        "x": 0,
	        "y": 29
	      },
	      "id": 57,
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
	      "targets": [
	        {
	          "datasource": {
	            "type": "loki",
	            "uid": "loki:local"
	          },
	          "expr": "{cluster=\"$cluster\",namespace=\"$namespace\",pod=~\"$name-[a-z0-9]+\"}",
	          "refId": "A"
	        }
	      ],
	      "title": "Logs",
	      "type": "logs"
	    }
	  ],
	  "refresh": "",
	  "schemaVersion": 36,
	  "style": "dark",
	  "tags": ["kubernetes", "resource"],
	  "templating": {
	    "list": [
	      {
	        "current": {
	          "selected": false,
	          "text": "prometheus:local",
	          "value": "prometheus:local"
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
	        "current": {
	          "selected": false,
	          "text": "loki:local",
	          "value": "loki:local"
	        },
	        "hide": 2,
	        "includeAll": false,
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
	        "definition": "label_values(kube_daemonset_metadata_generation, cluster)",
	        "hide": 0,
	        "includeAll": false,
	        "label": "Cluster",
	        "multi": false,
	        "name": "cluster",
	        "options": [],
	        "query": {
	          "query": "label_values(kube_daemonset_metadata_generation, cluster)",
	          "refId": "StandardVariableQuery"
	        },
	        "refresh": 1,
	        "regex": "",
	        "skipUrlSync": false,
	        "sort": 0,
	        "type": "query"
	      },
	      {
	        "allValue": "",
	        "current": {
	          "selected": true,
	          "text": "o11y-system",
	          "value": "o11y-system"
	        },
	        "datasource": {
	          "type": "prometheus",
	          "uid": "${datasource}"
	        },
	        "definition": "label_values(kube_daemonset_metadata_generation, namespace)",
	        "hide": 0,
	        "includeAll": false,
	        "label": "Namespace",
	        "multi": false,
	        "name": "namespace",
	        "options": [],
	        "query": {
	          "query": "label_values(kube_daemonset_metadata_generation, namespace)",
	          "refId": "StandardVariableQuery"
	        },
	        "refresh": 1,
	        "regex": "",
	        "skipUrlSync": false,
	        "sort": 0,
	        "tagsQuery": "",
	        "type": "query",
	        "useTags": false
	      },
	      {
	        "allValue": "",
	        "current": {
	          "selected": true,
	          "text": "vector",
	          "value": "vector"
	        },
	        "datasource": {
	          "type": "prometheus",
	          "uid": "${datasource}"
	        },
	        "definition": "label_values(kube_daemonset_metadata_generation{namespace=\"$namespace\"}, daemonset)",
	        "hide": 0,
	        "includeAll": false,
	        "label": "DaemonSet",
	        "multi": false,
	        "name": "name",
	        "options": [],
	        "query": {
	          "query": "label_values(kube_daemonset_metadata_generation{namespace=\"$namespace\"}, daemonset)",
	          "refId": "StandardVariableQuery"
	        },
	        "refresh": 1,
	        "regex": "",
	        "skipUrlSync": false,
	        "sort": 0,
	        "tagValuesQuery": "",
	        "type": "query",
	        "useTags": false
	      }
	    ]
	  },
	  "time": {
	    "from": "now-30m",
	    "to": "now"
	  },
	  "timepicker": {
	    "refresh_intervals": [
	      "5s",
	      "10s",
	      "30s",
	      "1m",
	      "5m",
	      "15m",
	      "30m",
	      "1h",
	      "2h",
	      "1d"
	    ],
	    "time_options": [
	      "5m",
	      "15m",
	      "1h",
	      "6h",
	      "12h",
	      "24h",
	      "2d",
	      "7d",
	      "30d"
	    ]
	  },
	  "timezone": "browser",
	  "title": "Kubernetes DaemonSet",
	  "uid": "kubernetes-daemonset",
	  "version": 10,
	  "weekStart": ""
	}
	"""#
