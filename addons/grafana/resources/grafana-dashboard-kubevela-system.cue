package main

grafanaDashboardKubevelaSystem: {
	name: "grafana-dashboard-kubevela-system"
	type: "grafana-dashboard"
	properties: {
		uid:  "kubevela-system"
		data: grafanaDashboardKubevelaSystemData
	}
}

grafanaDashboardKubevelaSystemData: #"""
{
  "panels": [
    {
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 0
      },
      "id": 82,
      "title": "Computation Resources",
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
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          },
          "unit": "short"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 9,
        "w": 4,
        "x": 0,
        "y": 1
      },
      "id": 86,
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
          "expr": "sum(application_phase_number{app_kubernetes_io_name=\"vela-core\"})",
          "hide": false,
          "interval": "",
          "legendFormat": "All",
          "range": true,
          "refId": "B"
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
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "mappings": [],
          "max": 1,
          "min": 0,
          "thresholds": {
            "mode": "percentage",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "#EAB839",
                "value": 60
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
        "h": 9,
        "w": 5,
        "x": 4,
        "y": 1
      },
      "id": 57,
      "options": {
        "orientation": "auto",
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
          "exemplar": true,
          "expr": "sum (container_memory_working_set_bytes{container=\"kubevela\"}) by (container)/ sum(container_spec_memory_limit_bytes{container=\"kubevela\"}) by (container)",
          "interval": "",
          "legendFormat": "Memory",
          "refId": "A"
        },
        {
          "exemplar": true,
          "expr": "sum(rate(container_cpu_usage_seconds_total{container=\"kubevela\"}[2m])) by (container) / (sum(container_spec_cpu_quota{container=\"kubevela\"}/100000) by (container))",
          "hide": false,
          "interval": "",
          "legendFormat": "CPU",
          "refId": "B"
        }
      ],
      "title": "KubeVela Controller Resource Usage",
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
            "mode": "thresholds"
          },
          "mappings": [],
          "max": 1,
          "min": 0,
          "thresholds": {
            "mode": "percentage",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "#EAB839",
                "value": 60
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
        "h": 9,
        "w": 5,
        "x": 9,
        "y": 1
      },
      "id": 80,
      "options": {
        "orientation": "auto",
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
          "exemplar": true,
          "expr": "sum (container_memory_working_set_bytes{container=\"kubevela-vela-core-cluster-gateway\"}) by (container)/ sum(container_spec_memory_limit_bytes{container=\"kubevela-vela-core-cluster-gateway\"}) by (container)",
          "interval": "",
          "legendFormat": "Memory",
          "refId": "A"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "${datasource}"
          },
          "exemplar": true,
          "expr": "sum(rate(container_cpu_usage_seconds_total{container=\"kubevela-vela-core-cluster-gateway\"}[2m])) by (container) / (sum(container_spec_cpu_quota{container=\"kubevela-vela-core-cluster-gateway\"}/100000) by (container))",
          "hide": false,
          "interval": "",
          "legendFormat": "CPU",
          "refId": "B"
        }
      ],
      "title": "ClusterGateway Resource Usage",
      "type": "gauge"
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
        "h": 9,
        "w": 5,
        "x": 14,
        "y": 1
      },
      "hiddenSeries": false,
      "id": 5,
      "legend": {
        "alignAsTable": true,
        "avg": true,
        "current": true,
        "max": true,
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
          "exemplar": true,
          "expr": "sum(rate(container_cpu_usage_seconds_total{container=\"kubevela\"}[$rate_interval])) by (container)",
          "hide": false,
          "interval": "10s",
          "legendFormat": "KubeVela Controller",
          "range": true,
          "refId": "A"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "${datasource}"
          },
          "editorMode": "code",
          "expr": "sum(rate(container_cpu_usage_seconds_total{container=\"kubevela-vela-core-cluster-gateway\"}[$rate_interval])) by (container)",
          "hide": false,
          "legendFormat": "Cluster Gateway",
          "range": true,
          "refId": "B"
        }
      ],
      "thresholds": [],
      "timeRegions": [],
      "title": "CPU Usage",
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
          "$$hashKey": "object:6187",
          "format": "short",
          "label": "core",
          "logBase": 1,
          "show": true
        },
        {
          "$$hashKey": "object:6188",
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
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 9,
        "w": 5,
        "x": 19,
        "y": 1
      },
      "hiddenSeries": false,
      "id": 23,
      "legend": {
        "alignAsTable": true,
        "avg": true,
        "current": true,
        "max": true,
        "min": true,
        "rightSide": false,
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
          "exemplar": true,
          "expr": "sum(container_memory_working_set_bytes{container=\"kubevela\"})",
          "hide": false,
          "interval": "",
          "legendFormat": "KubeVela Controller WSS",
          "range": true,
          "refId": "A"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "${datasource}"
          },
          "editorMode": "code",
          "exemplar": true,
          "expr": "sum(container_memory_rss{container=\"kubevela\"})",
          "hide": true,
          "interval": "",
          "legendFormat": "KubeVela Controller RSS",
          "range": true,
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "${datasource}"
          },
          "editorMode": "code",
          "exemplar": true,
          "expr": "sum(container_memory_working_set_bytes{container=\"kubevela-vela-core-cluster-gateway\"})",
          "hide": false,
          "interval": "",
          "legendFormat": "Cluster Gateway WSS",
          "range": true,
          "refId": "C"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "${datasource}"
          },
          "editorMode": "code",
          "exemplar": true,
          "expr": "sum(container_memory_rss{container=\"kubevela-vela-core-cluster-gateway\"})",
          "hide": true,
          "interval": "",
          "legendFormat": "Cluster Gateway RSS",
          "range": true,
          "refId": "D"
        }
      ],
      "thresholds": [],
      "timeRegions": [],
      "title": "Memory Usage",
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
          "$$hashKey": "object:105",
          "format": "bytes",
          "logBase": 1,
          "show": true
        },
        {
          "$$hashKey": "object:106",
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
      "datasource": {
        "type": "prometheus",
        "uid": "${datasource}"
      },
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 10
      },
      "id": 56,
      "panels": [],
      "title": "Controller",
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
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 8,
        "w": 6,
        "x": 0,
        "y": 11
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
          "expr": "sum(workqueue_depth{app_kubernetes_io_name=\"vela-core\"}) by (name)",
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
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 8,
        "w": 6,
        "x": 6,
        "y": 11
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
          "expr": "sum(rate(workqueue_adds_total{app_kubernetes_io_name=\"vela-core\"}[$rate_interval])) by (name)",
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
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 8,
        "w": 6,
        "x": 12,
        "y": 11
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
          "expr": "sum(rate(controller_runtime_reconcile_total{app_kubernetes_io_name=\"vela-core\"}[$rate_interval])) by (result, controller)",
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
        "y": 11
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
          "expr": "sum(rate(controller_runtime_reconcile_time_seconds_sum{app_kubernetes_io_name=\"vela-core\"}[$rate_interval])) by (controller) / sum(rate(controller_runtime_reconcile_time_seconds_count{app_kubernetes_io_name=\"vela-core\"}[$rate_interval])) by (controller)",
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
        "y": 19
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
          "expr": "sum(rate(controller_runtime_reconcile_time_seconds_sum{controller=\"application\",app_kubernetes_io_name=\"vela-core\"}[$rate_interval])) / sum(rate(controller_runtime_reconcile_time_seconds_count{controller=\"application\",app_kubernetes_io_name=\"vela-core\"}[$rate_interval]))",
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
      "title": "ApplicationController  Reconcile Time",
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
        "y": 19
      },
      "hiddenSeries": false,
      "id": 76,
      "legend": {
        "alignAsTable": true,
        "avg": true,
        "current": true,
        "max": false,
        "min": false,
        "rightSide": true,
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
          "expr": "sum(rate(create_app_handler_time_seconds_sum{app_kubernetes_io_name=\"vela-core\"}[$rate_interval])) / sum(rate(create_app_handler_time_seconds_count{app_kubernetes_io_name=\"vela-core\"}[$rate_interval]))",
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
          "expr": "sum(rate(handle_finalizers_time_seconds_sum{app_kubernetes_io_name=\"vela-core\"}[$rate_interval])) / sum(rate(handle_finalizers_time_seconds_count{app_kubernetes_io_name=\"vela-core\"}[$rate_interval]))",
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
          "expr": "sum(rate(parse_appFile_time_seconds_sum{app_kubernetes_io_name=\"vela-core\"}[$rate_interval])) / sum(rate(parse_appFile_time_seconds_count{app_kubernetes_io_name=\"vela-core\"}[$rate_interval]))",
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
          "expr": "sum(rate(prepare_current_appRevision_time_seconds_sum{app_kubernetes_io_name=\"vela-core\"}[$rate_interval])) / sum(rate(prepare_current_appRevision_time_seconds_count{app_kubernetes_io_name=\"vela-core\"}[$rate_interval]))",
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
          "expr": "sum(rate(apply_appRevision_time_seconds_sum{app_kubernetes_io_name=\"vela-core\"}[$rate_interval])) / sum(rate(apply_appRevision_time_seconds_count{app_kubernetes_io_name=\"vela-core\"}[$rate_interval]))",
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
          "expr": "sum(rate(apply_policies_sum{app_kubernetes_io_name=\"vela-core\"}[$rate_interval])) / sum(rate(apply_policies_count{app_kubernetes_io_name=\"vela-core\"}[$rate_interval]))",
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
          "expr": "sum(rate(gc_resourceTrackers_time_seconds_sum{cluster=\"local\",app_kubernetes_io_name=\"vela-core\",stage=\"-\"}[$rate_interval])) / sum(rate(gc_resourceTrackers_time_seconds_count{cluster=\"local\",app_kubernetes_io_name=\"vela-core\",stage=\"-\"}[$rate_interval]))",
          "hide": false,
          "legendFormat": "GCResourceTrackers",
          "range": true,
          "refId": "G"
        }
      ],
      "thresholds": [],
      "timeRegions": [],
      "title": "ApplicationController Reconcile Stage Time",
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
        "y": 19
      },
      "hiddenSeries": false,
      "id": 75,
      "legend": {
        "alignAsTable": true,
        "avg": true,
        "current": true,
        "max": false,
        "min": false,
        "rightSide": true,
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
          "expr": "sum(rate(kubevela_controller_client_request_time_seconds_count{app_kubernetes_io_name=\"vela-core\"}[$rate_interval])) by (Kind, verb)",
          "hide": false,
          "legendFormat": "{{verb}}: {{Kind}}",
          "range": true,
          "refId": "A"
        }
      ],
      "thresholds": [],
      "timeRegions": [],
      "title": "ApplicationController Client Request Throughput",
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
        "y": 19
      },
      "hiddenSeries": false,
      "id": 74,
      "legend": {
        "alignAsTable": true,
        "avg": true,
        "current": true,
        "max": false,
        "min": false,
        "rightSide": true,
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
          "expr": "sum(rate(kubevela_controller_client_request_time_seconds_sum{app_kubernetes_io_name=\"vela-core\"}[$rate_interval])) by (Kind, verb) / sum(rate(kubevela_controller_client_request_time_seconds_count{app_kubernetes_io_name=\"vela-core\"}[$rate_interval])) by (Kind, verb)",
          "hide": false,
          "legendFormat": "{{verb}}: {{Kind}}",
          "range": true,
          "refId": "A"
        }
      ],
      "thresholds": [],
      "timeRegions": [],
      "title": "ApplicationController  Client Request Average Time",
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
          "format": "s",
          "logBase": 1,
          "show": true
        },
        {
          "$$hashKey": "object:1079",
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
        "y": 27
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
        "y": 28
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
          "expr": "sum(application_phase_number{app_kubernetes_io_name=\"vela-core\"})",
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
          "expr": "sum(application_phase_number{app_kubernetes_io_name=\"vela-core\"}) by (phase)",
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
        "y": 28
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
          "expr": "sum(workflow_step_phase_number{app_kubernetes_io_name=\"vela-core\"})",
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
          "expr": "sum(workflow_step_phase_number{app_kubernetes_io_name=\"vela-core\"}) by (step_type)",
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
        "y": 28
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
          "expr": "sum(workflow_step_phase_number{app_kubernetes_io_name=\"vela-core\"}) by (phase)",
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
          "expr": "sum(workflow_step_phase_number{app_kubernetes_io_name=\"vela-core\"}) by (step_type, phase)",
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
        "y": 28
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
          "expr": "sum(rate(workflow_initialized_num{app_kubernetes_io_name=\"vela-core\"}[$rate_interval]))",
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
        "y": 28
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
          "expr": "sum(rate(workflow_finished_time_seconds_sum{app_kubernetes_io_name=\"vela-core\"}[$rate_interval])) by (phase) / sum(rate(workflow_finished_time_seconds_count{app_kubernetes_io_name=\"vela-core\"}[$rate_interval])) by (phase)",
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
        "y": 36
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
            "y": 1
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
            "y": 9
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
            "y": 17
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
        "y": 37
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
                    "color": "text"
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
            "y": 38
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
                    "color": "text"
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
                  "options": "Namespace|Name|WorkflowMode|Status"
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
            "y": 38
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
  "tags": ["kubevela", "system"],
  "templating": {
    "list": [
      {
        "current": {
          "selected": false,
          "text": "prometheus:c2",
          "value": "prometheus:c2"
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
        "hide": 0,
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
      }
    ]
  },
  "time": {
    "from": "now-30m",
    "to": "now"
  },
  "timepicker": {},
  "timezone": "",
  "title": "KubeVela System",
  "uid": "kubevela-system",
  "version": 1,
  "weekStart": ""
}
"""#
