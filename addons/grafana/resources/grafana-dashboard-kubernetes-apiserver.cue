package main

grafanaDashboardKubernetesAPIServer: {
	name: "grafana-dashboard-kubernetes-apiserver"
	type: "grafana-dashboard"
	properties: {
		uid:     "kubernetes-apiserver"
		grafana: parameter.grafanaName
		data:    grafanaDashboardKubernetesAPIServerData
	}
}

grafanaDashboardKubernetesAPIServerData: #"""
	{
	  "description": "Latency and QPS for Kubernetes apiserver. ",
	  "editable": false,
	  "links": [{
	    "asDropdown": false,
	    "icon": "external link",
	    "includeVars": false,
	    "keepTime": true,
	    "tags": [
	      "kubevela",
	      "system"
	    ],
	    "targetBlank": true,
	    "title": "KubeVela System",
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
	      "id": 16,
	      "panels": [],
	      "title": "Requests",
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
	          "links": []
	        },
	        "overrides": []
	      },
	      "fill": 1,
	      "fillGradient": 0,
	      "gridPos": {
	        "h": 8,
	        "w": 6,
	        "x": 0,
	        "y": 1
	      },
	      "hiddenSeries": false,
	      "id": 21,
	      "legend": {
	        "alignAsTable": false,
	        "avg": false,
	        "current": false,
	        "max": false,
	        "min": false,
	        "rightSide": false,
	        "show": true,
	        "sort": "avg",
	        "sortDesc": true,
	        "total": false,
	        "values": false
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
	      "stack": true,
	      "steppedLine": false,
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(rate(apiserver_request_total{cluster=~\"$cluster\"}[$rate_interval])) by (verb)",
	          "legendFormat": "{{verb}}",
	          "range": true,
	          "refId": "A"
	        }
	      ],
	      "thresholds": [],
	      "timeRegions": [],
	      "title": " Request QPS (by verb)",
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
	          "$$hashKey": "object:194",
	          "format": "short",
	          "label": "req/s",
	          "logBase": 1,
	          "min": "0",
	          "show": true
	        },
	        {
	          "$$hashKey": "object:195",
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
	          "links": []
	        },
	        "overrides": []
	      },
	      "fill": 1,
	      "fillGradient": 0,
	      "gridPos": {
	        "h": 8,
	        "w": 6,
	        "x": 6,
	        "y": 1
	      },
	      "hiddenSeries": false,
	      "id": 22,
	      "legend": {
	        "alignAsTable": false,
	        "avg": false,
	        "current": false,
	        "max": false,
	        "min": false,
	        "rightSide": false,
	        "show": true,
	        "sort": "avg",
	        "sortDesc": true,
	        "total": false,
	        "values": false
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
	      "stack": true,
	      "steppedLine": false,
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(rate(apiserver_request_total{cluster=~\"$cluster\",resource!=\"\"}[$rate_interval])) by (resource)",
	          "legendFormat": "{{resource}}",
	          "range": true,
	          "refId": "A"
	        }
	      ],
	      "thresholds": [],
	      "timeRegions": [],
	      "title": " Request QPS (by resource)",
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
	          "$$hashKey": "object:194",
	          "format": "short",
	          "label": "req/s",
	          "logBase": 1,
	          "min": "0",
	          "show": true
	        },
	        {
	          "$$hashKey": "object:195",
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
	          "links": []
	        },
	        "overrides": []
	      },
	      "fill": 1,
	      "fillGradient": 0,
	      "gridPos": {
	        "h": 8,
	        "w": 12,
	        "x": 12,
	        "y": 1
	      },
	      "hiddenSeries": false,
	      "id": 13,
	      "legend": {
	        "alignAsTable": true,
	        "avg": true,
	        "current": true,
	        "max": false,
	        "min": false,
	        "rightSide": true,
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
	      "stack": true,
	      "steppedLine": false,
	      "targets": [
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(rate(apiserver_request_total{cluster=~\"$cluster\"}[$rate_interval])) by (verb,resource)",
	          "legendFormat": "{{verb}} - {{resource}}",
	          "range": true,
	          "refId": "A"
	        }
	      ],
	      "thresholds": [],
	      "timeRegions": [],
	      "title": "Detail Request QPS",
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
	          "$$hashKey": "object:194",
	          "format": "short",
	          "label": "req/s",
	          "logBase": 1,
	          "min": "0",
	          "show": true
	        },
	        {
	          "$$hashKey": "object:195",
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
	      "description": "",
	      "fieldConfig": {
	        "defaults": {
	          "links": []
	        },
	        "overrides": []
	      },
	      "fill": 1,
	      "fillGradient": 0,
	      "gridPos": {
	        "h": 8,
	        "w": 6,
	        "x": 0,
	        "y": 9
	      },
	      "hiddenSeries": false,
	      "id": 24,
	      "legend": {
	        "alignAsTable": false,
	        "avg": false,
	        "current": false,
	        "max": false,
	        "min": false,
	        "rightSide": false,
	        "show": true,
	        "sort": "avg",
	        "sortDesc": true,
	        "total": false,
	        "values": false
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
	          "expr": "histogram_quantile(0.95, sum(rate(apiserver_request_duration_seconds_bucket{verb!~\"CONNECT|WATCH\",cluster=~\"$cluster\"}[$rate_interval])) by (le))",
	          "legendFormat": "p95",
	          "range": true,
	          "refId": "A"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "histogram_quantile(0.75, sum(rate(apiserver_request_duration_seconds_bucket{verb!~\"CONNECT|WATCH\",cluster=\"$cluster\"}[$rate_interval])) by (le))",
	          "hide": false,
	          "legendFormat": "p75",
	          "range": true,
	          "refId": "B"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "histogram_quantile(0.50, sum(rate(apiserver_request_duration_seconds_bucket{verb!~\"CONNECT|WATCH\",cluster=\"$cluster\"}[$rate_interval])) by (le))",
	          "hide": false,
	          "legendFormat": "p50",
	          "range": true,
	          "refId": "C"
	        }
	      ],
	      "thresholds": [],
	      "timeRegions": [],
	      "title": "Latency",
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
	          "$$hashKey": "object:376",
	          "format": "s",
	          "label": "latency",
	          "logBase": 1,
	          "show": true
	        },
	        {
	          "$$hashKey": "object:377",
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
	      "description": "",
	      "fieldConfig": {
	        "defaults": {
	          "links": []
	        },
	        "overrides": []
	      },
	      "fill": 1,
	      "fillGradient": 0,
	      "gridPos": {
	        "h": 8,
	        "w": 6,
	        "x": 6,
	        "y": 9
	      },
	      "hiddenSeries": false,
	      "id": 23,
	      "legend": {
	        "alignAsTable": false,
	        "avg": false,
	        "current": false,
	        "max": false,
	        "min": false,
	        "rightSide": false,
	        "show": true,
	        "sort": "avg",
	        "sortDesc": true,
	        "total": false,
	        "values": false
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
	          "expr": "sum(rate(apiserver_request_duration_seconds_sum{verb!~\"CONNECT|WATCH\",cluster=~\"$cluster\"}[$rate_interval])) by (verb) / sum(rate(apiserver_request_duration_seconds_count{verb!~\"CONNECT|WATCH\",cluster=~\"$cluster\"}[$rate_interval])) by (verb)",
	          "legendFormat": "{{verb}}",
	          "range": true,
	          "refId": "A"
	        }
	      ],
	      "thresholds": [],
	      "timeRegions": [],
	      "title": "Average Latency (by verb)",
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
	          "$$hashKey": "object:376",
	          "format": "s",
	          "label": "latency",
	          "logBase": 1,
	          "show": true
	        },
	        {
	          "$$hashKey": "object:377",
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
	      "description": "",
	      "fieldConfig": {
	        "defaults": {
	          "links": []
	        },
	        "overrides": []
	      },
	      "fill": 1,
	      "fillGradient": 0,
	      "gridPos": {
	        "h": 8,
	        "w": 12,
	        "x": 12,
	        "y": 9
	      },
	      "hiddenSeries": false,
	      "id": 14,
	      "legend": {
	        "alignAsTable": true,
	        "avg": true,
	        "current": true,
	        "max": false,
	        "min": false,
	        "rightSide": true,
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
	          "expr": "sum(rate(apiserver_request_duration_seconds_sum{verb!~\"CONNECT|WATCH\",cluster=~\"$cluster\"}[$rate_interval])) by (verb,resource) / sum(rate(apiserver_request_duration_seconds_count{verb!~\"CONNECT|WATCH\",cluster=~\"$cluster\"}[$rate_interval])) by (verb,resource)",
	          "legendFormat": "{{verb}} {{resource}}",
	          "range": true,
	          "refId": "A"
	        }
	      ],
	      "thresholds": [],
	      "timeRegions": [],
	      "title": "Average Latency",
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
	          "$$hashKey": "object:376",
	          "format": "s",
	          "label": "latency",
	          "logBase": 1,
	          "show": true
	        },
	        {
	          "$$hashKey": "object:377",
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
	        "y": 17
	      },
	      "id": 39,
	      "panels": [],
	      "title": "WorkQueue",
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
	          "links": []
	        },
	        "overrides": []
	      },
	      "fill": 1,
	      "fillGradient": 0,
	      "gridPos": {
	        "h": 8,
	        "w": 6,
	        "x": 0,
	        "y": 18
	      },
	      "hiddenSeries": false,
	      "id": 10,
	      "legend": {
	        "avg": false,
	        "current": false,
	        "max": false,
	        "min": false,
	        "show": true,
	        "total": false,
	        "values": false
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
	          "expr": "histogram_quantile(0.99, sum(rate(workqueue_queue_duration_seconds_bucket{job=\"kubernetes-apiservers\",cluster=~\"$cluster\"}[$rate_interval])) by (le))",
	          "legendFormat": "p99",
	          "range": true,
	          "refId": "A"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "histogram_quantile(0.75, sum(rate(workqueue_queue_duration_seconds_bucket{job=\"kubernetes-apiservers\",cluster=~\"$cluster\"}[$rate_interval])) by (le))",
	          "legendFormat": "p75",
	          "range": true,
	          "refId": "B"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(rate(workqueue_queue_duration_seconds_sum{job=\"kubernetes-apiservers\",cluster=~\"$cluster\"}[$rate_interval])) / sum(rate(workqueue_queue_duration_seconds_count{job=\"kubernetes-apiservers\",cluster=~\"$cluster\"}[$rate_interval]))",
	          "legendFormat": "avg",
	          "range": true,
	          "refId": "C"
	        }
	      ],
	      "thresholds": [],
	      "timeRegions": [],
	      "title": "Service Time",
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
	          "$$hashKey": "object:2132",
	          "format": "s",
	          "label": "service time",
	          "logBase": 1,
	          "show": true
	        },
	        {
	          "$$hashKey": "object:2133",
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
	          "links": []
	        },
	        "overrides": []
	      },
	      "fill": 1,
	      "fillGradient": 0,
	      "gridPos": {
	        "h": 8,
	        "w": 6,
	        "x": 6,
	        "y": 18
	      },
	      "hiddenSeries": false,
	      "id": 12,
	      "legend": {
	        "avg": false,
	        "current": false,
	        "max": false,
	        "min": false,
	        "show": true,
	        "total": false,
	        "values": false
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
	          "expr": "histogram_quantile(0.99, sum(rate(workqueue_work_duration_seconds_bucket{job=\"kubernetes-apiservers\",cluster=~\"$cluster\"}[$rate_interval])) by (le))",
	          "legendFormat": "p99",
	          "range": true,
	          "refId": "A"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "histogram_quantile(0.75, sum(rate(workqueue_work_duration_seconds_bucket{job=\"kubernetes-apiservers\",cluster=~\"$cluster\"}[$rate_interval])) by (le))",
	          "legendFormat": "p75",
	          "range": true,
	          "refId": "B"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(rate(workqueue_work_duration_seconds_sum{job=\"kubernetes-apiservers\",cluster=~\"$cluster\"}[$rate_interval])) / sum(rate(workqueue_work_duration_seconds_count{job=\"kubernetes-apiservers\",cluster=~\"$cluster\"}[$rate_interval]))",
	          "legendFormat": "avg",
	          "range": true,
	          "refId": "C"
	        }
	      ],
	      "thresholds": [],
	      "timeRegions": [],
	      "title": "Process Time",
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
	          "$$hashKey": "object:4348",
	          "format": "s",
	          "label": "processing time",
	          "logBase": 1,
	          "show": true
	        },
	        {
	          "$$hashKey": "object:4349",
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
	          "links": []
	        },
	        "overrides": []
	      },
	      "fill": 1,
	      "fillGradient": 0,
	      "gridPos": {
	        "h": 8,
	        "w": 6,
	        "x": 12,
	        "y": 18
	      },
	      "hiddenSeries": false,
	      "id": 36,
	      "legend": {
	        "alignAsTable": false,
	        "avg": false,
	        "current": false,
	        "max": false,
	        "min": false,
	        "show": true,
	        "total": false,
	        "values": false
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
	          "expr": "sum(workqueue_depth{cluster=~\"$cluster\",job=\"kubernetes-apiservers\"})",
	          "legendFormat": "QueueSize",
	          "range": true,
	          "refId": "A"
	        }
	      ],
	      "thresholds": [],
	      "timeRegions": [],
	      "title": "Queue Size",
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
	          "$$hashKey": "object:4348",
	          "format": "short",
	          "label": "processing time",
	          "logBase": 1,
	          "min": "0",
	          "show": true
	        },
	        {
	          "$$hashKey": "object:4349",
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
	          "links": []
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
	      "id": 37,
	      "legend": {
	        "alignAsTable": false,
	        "avg": false,
	        "current": false,
	        "max": false,
	        "min": false,
	        "show": true,
	        "total": false,
	        "values": false
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
	          "expr": "sum(rate(workqueue_retries_total{cluster=~\"$cluster\",job=\"kubernetes-apiservers\"}[$rate_interval]))",
	          "legendFormat": "Retries",
	          "range": true,
	          "refId": "A"
	        }
	      ],
	      "thresholds": [],
	      "timeRegions": [],
	      "title": "Retry Rate",
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
	          "$$hashKey": "object:4348",
	          "format": "short",
	          "label": "retries/s",
	          "logBase": 1,
	          "min": "0",
	          "show": true
	        },
	        {
	          "$$hashKey": "object:4349",
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
	        "y": 26
	      },
	      "id": 30,
	      "panels": [],
	      "title": "Watches",
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
	      "description": "",
	      "fieldConfig": {
	        "defaults": {
	          "links": []
	        },
	        "overrides": []
	      },
	      "fill": 1,
	      "fillGradient": 0,
	      "gridPos": {
	        "h": 8,
	        "w": 8,
	        "x": 0,
	        "y": 27
	      },
	      "hiddenSeries": false,
	      "id": 26,
	      "legend": {
	        "alignAsTable": true,
	        "avg": true,
	        "current": true,
	        "max": false,
	        "min": false,
	        "rightSide": true,
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
	          "expr": "sum(apiserver_registered_watchers{cluster=~\"$cluster\"}) by (kind)",
	          "legendFormat": "{{kind}}",
	          "range": true,
	          "refId": "A"
	        }
	      ],
	      "thresholds": [],
	      "timeRegions": [],
	      "title": "Number of Watches",
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
	          "$$hashKey": "object:376",
	          "format": "short",
	          "label": "count",
	          "logBase": 1,
	          "show": true
	        },
	        {
	          "$$hashKey": "object:377",
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
	      "description": "",
	      "fieldConfig": {
	        "defaults": {
	          "links": []
	        },
	        "overrides": []
	      },
	      "fill": 1,
	      "fillGradient": 0,
	      "gridPos": {
	        "h": 8,
	        "w": 6,
	        "x": 8,
	        "y": 27
	      },
	      "hiddenSeries": false,
	      "id": 31,
	      "legend": {
	        "alignAsTable": false,
	        "avg": false,
	        "current": false,
	        "max": false,
	        "min": false,
	        "rightSide": false,
	        "show": true,
	        "sort": "avg",
	        "sortDesc": true,
	        "total": false,
	        "values": false
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
	          "expr": "histogram_quantile(0.99, sum(rate(apiserver_watch_events_sizes_bucket{cluster=~\"$cluster\"}[$rate_interval])) by (le))",
	          "legendFormat": "p99",
	          "range": true,
	          "refId": "A"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "histogram_quantile(0.75, sum(rate(apiserver_watch_events_sizes_bucket{cluster=~\"$cluster\"}[$rate_interval])) by (le))",
	          "hide": false,
	          "legendFormat": "p75",
	          "range": true,
	          "refId": "B"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(rate(apiserver_watch_events_sizes_sum{cluster=~\"$cluster\"}[$rate_interval])) / sum(rate(apiserver_watch_events_sizes_count{cluster=~\"$cluster\"}[$rate_interval]))",
	          "hide": false,
	          "legendFormat": "avg",
	          "range": true,
	          "refId": "C"
	        }
	      ],
	      "thresholds": [],
	      "timeRegions": [],
	      "title": "Watch Event Rate",
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
	          "$$hashKey": "object:376",
	          "format": "short",
	          "label": "req/s",
	          "logBase": 1,
	          "show": true
	        },
	        {
	          "$$hashKey": "object:377",
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
	      "description": "",
	      "fieldConfig": {
	        "defaults": {
	          "links": []
	        },
	        "overrides": []
	      },
	      "fill": 1,
	      "fillGradient": 0,
	      "gridPos": {
	        "h": 8,
	        "w": 10,
	        "x": 14,
	        "y": 27
	      },
	      "hiddenSeries": false,
	      "id": 28,
	      "legend": {
	        "alignAsTable": true,
	        "avg": true,
	        "current": true,
	        "max": false,
	        "min": false,
	        "rightSide": true,
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
	          "expr": "sum(rate(apiserver_watch_events_total{cluster=~\"$cluster\"}[$rate_interval])) by (kind)",
	          "legendFormat": "{{kind}}",
	          "range": true,
	          "refId": "A"
	        }
	      ],
	      "thresholds": [],
	      "timeRegions": [],
	      "title": "Watch Event Rate (by resource)",
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
	          "$$hashKey": "object:376",
	          "format": "short",
	          "label": "req/s",
	          "logBase": 1,
	          "show": true
	        },
	        {
	          "$$hashKey": "object:377",
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
	        "y": 35
	      },
	      "id": 33,
	      "panels": [],
	      "title": "Storage",
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
	      "description": "",
	      "fieldConfig": {
	        "defaults": {
	          "links": []
	        },
	        "overrides": []
	      },
	      "fill": 1,
	      "fillGradient": 0,
	      "gridPos": {
	        "h": 8,
	        "w": 8,
	        "x": 0,
	        "y": 36
	      },
	      "hiddenSeries": false,
	      "id": 34,
	      "legend": {
	        "alignAsTable": true,
	        "avg": false,
	        "current": true,
	        "max": false,
	        "min": false,
	        "rightSide": true,
	        "show": true,
	        "sort": "current",
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
	          "expr": "sum(etcd_object_counts{cluster=~\"$cluster\"}) by (resource)",
	          "legendFormat": "__auto",
	          "range": true,
	          "refId": "A"
	        }
	      ],
	      "thresholds": [],
	      "timeRegions": [],
	      "title": "Number of Objects",
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
	          "$$hashKey": "object:606",
	          "format": "short",
	          "label": "count",
	          "logBase": 1,
	          "show": true
	        },
	        {
	          "$$hashKey": "object:607",
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
	      "description": "",
	      "fieldConfig": {
	        "defaults": {
	          "links": []
	        },
	        "overrides": []
	      },
	      "fill": 1,
	      "fillGradient": 0,
	      "gridPos": {
	        "h": 8,
	        "w": 6,
	        "x": 8,
	        "y": 36
	      },
	      "hiddenSeries": false,
	      "id": 4,
	      "legend": {
	        "avg": false,
	        "current": false,
	        "max": false,
	        "min": false,
	        "show": true,
	        "total": false,
	        "values": false
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
	          "expr": "histogram_quantile(0.99, sum(rate(etcd_request_duration_seconds_bucket{cluster=~\"$cluster\"}[$rate_interval])) by (le))",
	          "legendFormat": "p99",
	          "range": true,
	          "refId": "A"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "histogram_quantile(0.75, sum(rate(etcd_request_duration_seconds_bucket{cluster=~\"$cluster\"}[$rate_interval])) by (le))",
	          "legendFormat": "p75",
	          "range": true,
	          "refId": "B"
	        },
	        {
	          "datasource": {
	            "type": "prometheus",
	            "uid": "${datasource}"
	          },
	          "editorMode": "code",
	          "expr": "sum(rate(etcd_request_duration_seconds_sum{cluster=~\"$cluster\"}[$rate_interval])) / sum(rate(etcd_request_duration_seconds_count{cluster=~\"$cluster\"}[$rate_interval]))",
	          "legendFormat": "avg",
	          "range": true,
	          "refId": "C"
	        }
	      ],
	      "thresholds": [],
	      "timeRegions": [],
	      "title": "etcd request latency",
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
	          "$$hashKey": "object:606",
	          "format": "s",
	          "label": "latency",
	          "logBase": 1,
	          "show": true
	        },
	        {
	          "$$hashKey": "object:607",
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
	      "description": "",
	      "fieldConfig": {
	        "defaults": {
	          "links": []
	        },
	        "overrides": []
	      },
	      "fill": 1,
	      "fillGradient": 0,
	      "gridPos": {
	        "h": 8,
	        "w": 10,
	        "x": 14,
	        "y": 36
	      },
	      "hiddenSeries": false,
	      "id": 35,
	      "legend": {
	        "alignAsTable": true,
	        "avg": false,
	        "current": true,
	        "max": false,
	        "min": false,
	        "rightSide": true,
	        "show": true,
	        "sort": "current",
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
	          "expr": "sum(rate(etcd_request_duration_seconds_sum{cluster=~\"$cluster\"}[$rate_interval])) by (type) / sum(rate(etcd_request_duration_seconds_count{cluster=~\"$cluster\"}[$rate_interval])) by (type)",
	          "legendFormat": "__auto",
	          "range": true,
	          "refId": "A"
	        }
	      ],
	      "thresholds": [],
	      "timeRegions": [],
	      "title": "Request Average Latency",
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
	          "$$hashKey": "object:606",
	          "format": "s",
	          "label": "",
	          "logBase": 1,
	          "show": true
	        },
	        {
	          "$$hashKey": "object:607",
	          "format": "short",
	          "logBase": 1,
	          "show": true
	        }
	      ],
	      "yaxis": {
	        "align": false
	      }
	    }
	  ],
	  "style": "dark",
	  "tags": ["kubernetes", "system"],
	  "templating": {
	    "list": [
	      {
	        "current": {
	          "selected": false,
	          "text": "${datasource}",
	          "value": "${datasource}"
	        },
	        "hide": 2,
	        "includeAll": false,
	        "label": "Data source",
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
	          }
	        ],
	        "query": "3m,5m,10m,30m",
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
	    ]
	  },
	  "title": "Kubernetes APIServer",
	  "uid": "kubernetes-apiserver"
	}
	"""#
