package main

grafanaDashboardKubernetesEvents: {
	name: "grafana-dashboard-kubernetes-events"
	type: "grafana-dashboard"
	properties: {
		uid:     "kubernetes-events"
		grafana: parameter.grafanaName
		data:    grafanaDashboardKubernetesEventsData
	}
}

grafanaDashboardKubernetesEventsData: #"""
{
  "annotations": {
    "list": [
      {
        "builtIn": 1,
        "datasource": {
          "type": "datasource",
          "uid": "grafana"
        },
        "enable": true,
        "hide": true,
        "iconColor": "rgba(0, 211, 255, 1)",
        "name": "Annotations & Alerts",
        "target": {
          "limit": 100,
          "matchAny": false,
          "tags": [],
          "type": "dashboard"
        },
        "type": "dashboard"
      }
    ]
  },
  "description": "Kubernetes Events Dashboard(Loki as DataSource)",
  "editable": true,
  "fiscalYearStartMonth": 0,
  "gnetId": 16967,
  "graphTooltip": 0,
  "id": 9,
  "links": [],
  "liveNow": false,
  "panels": [
    {
      "datasource": {
        "type": "loki",
        "uid": "${logsource}"
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
            "drawStyle": "bars",
            "fillOpacity": 100,
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
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 0
      },
      "id": 2,
      "interval": "1m",
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
            "type": "loki",
            "uid": "${logsource}"
          },
          "expr": "sum by (type) (count_over_time({pod=~\"^event-log.*\"}| json |  __error__=\"\" | line_format \"{{.message}}\" | __error__=\"\"  | json | __error__=\"\" [$__interval]))",
          "refId": "A"
        }
      ],
      "title": "Kubernetes Events Overview",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "loki",
        "uid": "${logsource}"
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
            "fillOpacity": 29,
            "gradientMode": "hue",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "lineInterpolation": "smooth",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "auto",
            "spanNulls": true,
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
                "color": "red",
                "value": null
              },
              {
                "color": "red",
                "value": 1
              }
            ]
          },
          "unit": "short"
        },
        "overrides": [
          {
            "matcher": {
              "id": "byName",
              "options": "Warning"
            },
            "properties": [
              {
                "id": "color",
                "value": {
                  "fixedColor": "red",
                  "mode": "fixed"
                }
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 12,
        "y": 0
      },
      "id": 4,
      "interval": "1m",
      "options": {
        "legend": {
          "calcs": [
            "sum"
          ],
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
            "type": "loki",
            "uid": "${logsource}"
          },
          "expr": "sum(count_over_time({pod=~\"^event-log.*\"}| json |  __error__=\"\" | line_format \"{{.message}}\" | __error__=\"\"  | json | __error__=\"\" | type = \"Warning\" [$__interval]))",
          "legendFormat": "Warning",
          "refId": "A"
        }
      ],
      "title": "Warning Enents",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "loki",
        "uid": "${logsource}"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "mappings": [],
          "noValue": "none",
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "yellow",
                "value": null
              },
              {
                "color": "yellow",
                "value": 0
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 6,
        "w": 4,
        "x": 0,
        "y": 8
      },
      "id": 6,
      "interval": "1m",
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "auto",
        "orientation": "auto",
        "reduceOptions": {
          "calcs": [
            "sum"
          ],
          "fields": "",
          "values": false
        },
        "text": {},
        "textMode": "auto"
      },
      "pluginVersion": "8.5.3",
      "targets": [
        {
          "datasource": {
            "type": "loki",
            "uid": "${logsource}"
          },
          "expr": "sum(count_over_time({pod=~\"^event-log.*\"}|= \"Error: ImagePullBackOff\"| json |  __error__=\"\" | line_format \"{{.message}}\" | __error__=\"\"  | json | __error__=\"\" reason = \"Failed\"| __error__=\"\"[$__interval]))",
          "refId": "A"
        }
      ],
      "title": "Image Pull Failed",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "loki",
        "uid": "${logsource}"
      },
      "fieldConfig": {
        "defaults": {
          "mappings": [],
          "noValue": "none",
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "yellow",
                "value": null
              },
              {
                "color": "yellow",
                "value": 0
              }
            ]
          },
          "unit": "short"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 6,
        "w": 4,
        "x": 4,
        "y": 8
      },
      "id": 12,
      "interval": "1m",
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "auto",
        "orientation": "auto",
        "reduceOptions": {
          "calcs": [
            "sum"
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
            "type": "loki",
            "uid": "${logsource}"
          },
          "expr": "sum(count_over_time({pod=~\"^event-log.*\"}| json |  __error__=\"\" | line_format \"{{.message}}\" | __error__=\"\"  | json | __error__=\"\" reason = \"BackOff\" [$__interval]))",
          "refId": "A"
        }
      ],
      "title": "Container Crashed",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "loki",
        "uid": "${logsource}"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "mappings": [],
          "noValue": "none",
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "yellow",
                "value": null
              },
              {
                "color": "yellow",
                "value": 0
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 6,
        "w": 4,
        "x": 8,
        "y": 8
      },
      "id": 10,
      "interval": "1m",
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "auto",
        "orientation": "auto",
        "reduceOptions": {
          "calcs": [
            "sum"
          ],
          "fields": "",
          "values": false
        },
        "text": {},
        "textMode": "auto"
      },
      "pluginVersion": "8.5.3",
      "targets": [
        {
          "datasource": {
            "type": "loki",
            "uid": "${logsource}"
          },
          "expr": "sum(count_over_time({pod=~\"^event-log.*\"}| json |  __error__=\"\" | line_format \"{{.message}}\" | __error__=\"\"  | json | __error__=\"\" reason = \"OOMKilling\" [$__interval]))",
          "refId": "A"
        }
      ],
      "title": "Container OOM Killed",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "loki",
        "uid": "${logsource}"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "mappings": [],
          "noValue": "none",
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "yellow",
                "value": null
              },
              {
                "color": "yellow",
                "value": 0
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 6,
        "w": 4,
        "x": 12,
        "y": 8
      },
      "id": 14,
      "interval": "1m",
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "auto",
        "orientation": "auto",
        "reduceOptions": {
          "calcs": [
            "sum"
          ],
          "fields": "",
          "values": false
        },
        "text": {},
        "textMode": "auto"
      },
      "pluginVersion": "8.5.3",
      "targets": [
        {
          "datasource": {
            "type": "loki",
            "uid": "${logsource}"
          },
          "expr": "sum(count_over_time({pod=~\"^event-log.*\"}| json |  __error__=\"\" | line_format \"{{.message}}\" | __error__=\"\"  | json | __error__=\"\" reason = \"Killing\" [$__interval]))",
          "refId": "A"
        }
      ],
      "title": "Liveness Check Failed",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "loki",
        "uid": "${logsource}"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "mappings": [],
          "noValue": "none",
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "yellow",
                "value": null
              },
              {
                "color": "yellow",
                "value": 0
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 6,
        "w": 4,
        "x": 16,
        "y": 8
      },
      "id": 16,
      "interval": "1m",
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "auto",
        "orientation": "auto",
        "reduceOptions": {
          "calcs": [
            "sum"
          ],
          "fields": "",
          "values": false
        },
        "text": {
          "valueSize": 0
        },
        "textMode": "auto"
      },
      "pluginVersion": "8.5.3",
      "targets": [
        {
          "datasource": {
            "type": "loki",
            "uid": "${logsource}"
          },
          "expr": "sum(count_over_time({pod=~\"^event-log.*\"}| json |  __error__=\"\" | line_format \"{{.message}}\" | __error__=\"\"  | json | __error__=\"\" reason = \"FailedScheduling\" [$__interval]))",
          "refId": "A"
        }
      ],
      "title": "Schedule Failed",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "loki",
        "uid": "${logsource}"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "mappings": [],
          "noValue": "none",
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "yellow",
                "value": null
              },
              {
                "color": "yellow",
                "value": 0
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 6,
        "w": 4,
        "x": 20,
        "y": 8
      },
      "id": 18,
      "interval": "1m",
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "auto",
        "orientation": "auto",
        "reduceOptions": {
          "calcs": [
            "sum"
          ],
          "fields": "",
          "values": false
        },
        "text": {},
        "textMode": "auto"
      },
      "pluginVersion": "8.5.3",
      "targets": [
        {
          "datasource": {
            "type": "loki",
            "uid": "${logsource}"
          },
          "expr": "sum(count_over_time({pod=~\"^event-log.*\"}| json |  __error__=\"\" | line_format \"{{.message}}\" | __error__=\"\"  | json | __error__=\"\" reason = \"TaintManagerEviction\" [$__interval]))",
          "refId": "A"
        }
      ],
      "title": "Pod Evicted",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "loki",
        "uid": "${logsource}"
      },
      "description": "",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "custom": {
            "align": "auto",
            "displayMode": "auto",
            "filterable": false,
            "inspect": false
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
                "value": 0
              }
            ]
          }
        },
        "overrides": [
          {
            "matcher": {
              "id": "byName",
              "options": "Field"
            },
            "properties": [
              {
                "id": "custom.align",
                "value": "center"
              },
              {
                "id": "custom.width",
                "value": 300
              },
              {
                "id": "color",
                "value": {
                  "mode": "thresholds"
                }
              },
              {
                "id": "displayName",
                "value": "Reason"
              },
              {
                "id": "custom.displayMode",
                "value": "color-background"
              },
              {
                "id": "color",
                "value": {
                  "fixedColor": "#eab839",
                  "mode": "fixed"
                }
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "Total"
            },
            "properties": [
              {
                "id": "custom.displayMode",
                "value": "gradient-gauge"
              },
              {
                "id": "color",
                "value": {
                  "mode": "continuous-BlYlRd"
                }
              },
              {
                "id": "custom.align",
                "value": "center"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 14,
        "w": 12,
        "x": 0,
        "y": 14
      },
      "id": 26,
      "interval": "1m",
      "options": {
        "footer": {
          "fields": "",
          "reducer": [
            "sum"
          ],
          "show": false
        },
        "frameIndex": 1,
        "showHeader": true,
        "sortBy": [
          {
            "desc": false,
            "displayName": "Total"
          }
        ]
      },
      "pluginVersion": "8.5.3",
      "targets": [
        {
          "datasource": {
            "type": "loki",
            "uid": "${logsource}"
          },
          "expr": "topk(10,sum by (reason) (count_over_time({pod=~\"^event-log.*\"}| json |  __error__=\"\" | line_format \"{{.message}}\" | __error__=\"\"  | json | __error__=\"\"[$__interval])))",
          "instant": false,
          "legendFormat": "{{reason}}",
          "range": true,
          "refId": "A"
        }
      ],
      "title": "TOP 10  Kubernetes Events",
      "transformations": [
        {
          "id": "reduce",
          "options": {
            "reducers": [
              "sum"
            ]
          }
        }
      ],
      "type": "table"
    },
    {
      "datasource": {
        "type": "loki",
        "uid": "${logsource}"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            }
          },
          "mappings": []
        },
        "overrides": []
      },
      "gridPos": {
        "h": 14,
        "w": 6,
        "x": 12,
        "y": 14
      },
      "id": 20,
      "interval": "1m",
      "options": {
        "legend": {
          "displayMode": "list",
          "placement": "bottom"
        },
        "pieType": "pie",
        "reduceOptions": {
          "calcs": [
            "sum"
          ],
          "fields": "",
          "values": false
        },
        "tooltip": {
          "mode": "single",
          "sort": "none"
        }
      },
      "targets": [
        {
          "datasource": {
            "type": "loki",
            "uid": "${logsource}"
          },
          "expr": "sum(count_over_time({pod=~\"^event-log.*\"}| json |  __error__=\"\" | line_format \"{{.message}}\" | __error__=\"\"  | json | __error__=\"\"[$__interval])) by (source_component)",
          "legendFormat": "{{source_component}}",
          "refId": "A"
        }
      ],
      "title": "Kubernetes Events Source",
      "type": "piechart"
    },
    {
      "datasource": {
        "type": "loki",
        "uid": "${logsource}"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            }
          },
          "mappings": []
        },
        "overrides": []
      },
      "gridPos": {
        "h": 14,
        "w": 6,
        "x": 18,
        "y": 14
      },
      "id": 22,
      "interval": "1m",
      "options": {
        "legend": {
          "displayMode": "list",
          "placement": "bottom"
        },
        "pieType": "pie",
        "reduceOptions": {
          "calcs": [
            "sum"
          ],
          "fields": "",
          "values": false
        },
        "tooltip": {
          "mode": "single",
          "sort": "none"
        }
      },
      "targets": [
        {
          "datasource": {
            "type": "loki",
            "uid": "${logsource}"
          },
          "expr": "sum(count_over_time({pod=~\"^event-log.*\"}| json |  __error__=\"\" | line_format \"{{.message}}\" | __error__=\"\"  | json | __error__=\"\"[$__interval])) by (involvedObject_kind)",
          "legendFormat": "{{involvedObject_kind}}",
          "refId": "A"
        }
      ],
      "title": "Kubernetes  Events Type",
      "type": "piechart"
    },
    {
      "datasource": {
        "type": "loki",
        "uid": "${logsource}"
      },
      "gridPos": {
        "h": 19,
        "w": 24,
        "x": 0,
        "y": 28
      },
      "id": 8,
      "options": {
        "dedupStrategy": "none",
        "enableLogDetails": true,
        "prettifyLogMessage": false,
        "showCommonLabels": false,
        "showLabels": false,
        "showTime": true,
        "sortOrder": "Descending",
        "wrapLogMessage": true
      },
      "targets": [
        {
          "datasource": "${logsource}",
          "expr": "{pod=~\"^event-log.*\"}",
          "refId": "A"
        }
      ],
      "title": "Kubernetes Live Events",
      "type": "logs"
    }
  ],
  "refresh": "1m",
  "schemaVersion": 36,
  "style": "dark",
  "tags": [
    "Loki",
    "logging"
  ],
  "templating": {
    "list": [
      {
        "current": {
          "selected": false,
          "text": "loki:local",
          "value": "loki:local"
        },
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
      }
    ]
  },
  "time": {
    "from": "now-6h",
    "to": "now"
  },
  "timepicker": {
    "refresh_intervals": [
      "10s",
      "30s",
      "1m",
      "5m",
      "15m",
      "30m",
      "1h",
      "2h",
      "1d"
    ]
  },
  "timezone": "",
  "title": "Kubernetes Events Dashboard",
  "uid": "kubernetes-events",
  "version": 1,
  "weekStart": ""
}
"""#
