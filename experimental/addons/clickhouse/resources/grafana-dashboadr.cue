package main

grafanaDashboardClickhouseOperator: {
	name: "grafana-dashboard-clickhouse-operator"
	type: "grafana-dashboard"
	properties: {
		uid:  "grafana-dashboard-clickhouse-operator"
		data: grafanaDashboardClickhouseData
	}
}

grafanaDashboardClickhouseData: #"""
	{
	    "__requires": [
	    {
	        "type": "grafana",
	        "id": "grafana",
	        "name": "Grafana",
	        "version": "7.5.15"
	    },
	    {
	        "type": "panel",
	        "id": "grafana-piechart-panel",
	        "name": "Pie Chart",
	        "version": "1.6.2"
	    },
	    {
	        "type": "panel",
	        "id": "graph",
	        "name": "Graph",
	        "version": ""
	    },
	    {
	        "type": "datasource",
	        "id": "prometheus",
	        "name": "Prometheus",
	        "version": "1.0.0"
	    },
	    {
	        "type": "panel",
	        "id": "singlestat",
	        "name": "Singlestat",
	        "version": ""
	    },
	    {
	        "type": "panel",
	        "id": "table-old",
	        "name": "Table (old)",
	        "version": ""
	    }
	    ],
	    "annotations": {
	    "list": [
	        {
	        "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	    },
	        "enable": true,
	        "expr": "ALERTS{app=~\"clickhouse-operator|zookeeper\"}",
	        "hide": false,
	        "iconColor": "rgba(255, 96, 96, 1)",
	        "limit": 100,
	        "name": "prometheus alerts",
	        "showIn": 0,
	        "step": "30s",
	        "tagKeys": "chi,pod_name,hostname,exported_namespace,namespace",
	        "tags": [],
	        "textFormat": "{{alertstate}}",
	        "titleFormat": "{{alertname}}",
	        "type": "tags"
	        },
	        {
	        "builtIn": 1,
	        "datasource": "-- Grafana --",
	        "enable": true,
	        "hide": true,
	        "iconColor": "rgba(0, 211, 255, 1)",
	        "name": "Annotations & Alerts",
	        "type": "dashboard"
	        }
	    ]
	    },
	    "description": "Alitinity Clickhouse Operator metrics exported by Monitoring Agent",
	    "editable": true,
	    "gnetId": 882,
	    "graphTooltip": 1,
	    "id": null,
	    "iteration": 1662652674457,
	    "links": [],
	    "panels": [
	    {
	        "columns": [
	        {
	            "text": "Current",
	            "value": "current"
	        }
	        ],
	        "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	    },
	        "fieldConfig": {
	        "defaults": {},
	        "overrides": []
	        },
	        "filterNull": false,
	        "fontSize": "100%",
	        "gridPos": {
	        "h": 4,
	        "w": 10,
	        "x": 0,
	        "y": 0
	        },
	        "id": 15,
	        "links": [],
	        "pageSize": null,
	        "scroll": true,
	        "showHeader": true,
	        "sort": {
	        "col": 2,
	        "desc": false
	        },
	        "styles": [
	        {
	            "align": "auto",
	            "dateFormat": "YYYY-MM-DD HH:mm:ss",
	            "pattern": "Time",
	            "type": "date"
	        },
	        {
	            "align": "auto",
	            "colorMode": "value",
	            "colors": [
	            "rgba(245, 54, 54, 0.9)",
	            "rgba(237, 129, 40, 0.89)",
	            "rgba(50, 172, 45, 0.97)"
	            ],
	            "decimals": 1,
	            "pattern": "/.*/",
	            "thresholds": [
	            "3600",
	            "86400"
	            ],
	            "type": "number",
	            "unit": "s"
	        }
	        ],
	        "targets": [
	        {
	            "expr": "chi_clickhouse_metric_Uptime{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}",
	            "intervalFactor": 2,
	            "legendFormat": "{{hostname}}",
	            "metric": "chi_clickhouse_metric_Uptime",
	            "refId": "A",
	            "step": 60
	        }
	        ],
	        "title": "Uptime",
	        "transform": "timeseries_aggregations",
	        "type": "table-old"
	    },
	    {
	        "cacheTimeout": null,
	        "colorBackground": false,
	        "colorValue": true,
	        "colors": [
	        "rgba(50, 172, 45, 0.97)",
	        "rgba(237, 129, 40, 0.89)",
	        "rgba(245, 54, 54, 0.9)"
	        ],
	        "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	    },
	        "description": "Clickhouse operator metrics-exporter fails when grab metrics from clickhouse-server\n\nPlease look pods status\n\nkubectl get pods --all-namespaces | grep clickhouse",
	        "editable": true,
	        "error": false,
	        "fieldConfig": {
	        "defaults": {},
	        "overrides": []
	        },
	        "format": "none",
	        "gauge": {
	        "maxValue": 100,
	        "minValue": 0,
	        "show": false,
	        "thresholdLabels": false,
	        "thresholdMarkers": true
	        },
	        "gridPos": {
	        "h": 2,
	        "w": 3,
	        "x": 10,
	        "y": 0
	        },
	        "id": 47,
	        "interval": "",
	        "isNew": true,
	        "links": [
	        {
	            "targetBlank": true,
	            "title": "metric_fetch_errors",
	            "url": "https://github.com/Altinity/clickhouse-operator/search?q=metric_fetch_errors"
	        }
	        ],
	        "mappingType": 1,
	        "mappingTypes": [
	        {
	            "name": "value to text",
	            "value": 1
	        },
	        {
	            "name": "range to text",
	            "value": 2
	        }
	        ],
	        "maxDataPoints": 100,
	        "nullPointMode": "connected",
	        "nullText": null,
	        "postfix": "",
	        "postfixFontSize": "50%",
	        "prefix": "",
	        "prefixFontSize": "50%",
	        "rangeMaps": [
	        {
	            "from": "null",
	            "text": "N/A",
	            "to": "null"
	        }
	        ],
	        "sparkline": {
	        "fillColor": "rgba(31, 118, 189, 0.18)",
	        "full": true,
	        "lineColor": "rgb(31, 120, 193)",
	        "show": true,
	        "ymin": 0
	        },
	        "tableColumn": "",
	        "targets": [
	        {
	            "expr": "sum(chi_clickhouse_metric_fetch_errors{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\",fetch_type=\"system.metrics\"})",
	            "intervalFactor": 2,
	            "legendFormat": "",
	            "refId": "A",
	            "step": 60
	        }
	        ],
	        "thresholds": "1,1",
	        "timeFrom": null,
	        "timeShift": null,
	        "title": "Failed Pods",
	        "type": "singlestat",
	        "valueFontSize": "80%",
	        "valueMaps": [
	        {
	            "op": "=",
	            "text": "N/A",
	            "value": "null"
	        }
	        ],
	        "valueName": "current"
	    },
	    {
	        "columns": [
	        {
	            "text": "Current",
	            "value": "current"
	        }
	        ],
	        "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	    },
	        "description": "For example, version 11.22.33 is translated to 11022033",
	        "fieldConfig": {
	        "defaults": {},
	        "overrides": []
	        },
	        "filterNull": false,
	        "fontSize": "100%",
	        "gridPos": {
	        "h": 4,
	        "w": 11,
	        "x": 13,
	        "y": 0
	        },
	        "hideTimeOverride": false,
	        "id": 17,
	        "links": [],
	        "pageSize": null,
	        "scroll": false,
	        "showHeader": true,
	        "sort": {
	        "col": 3,
	        "desc": true
	        },
	        "styles": [
	        {
	            "align": "auto",
	            "colorMode": null,
	            "colors": [
	            "rgba(245, 54, 54, 0.9)",
	            "rgba(237, 129, 40, 0.89)",
	            "rgba(50, 172, 45, 0.97)"
	            ],
	            "decimals": 0,
	            "pattern": "/.*/",
	            "thresholds": [],
	            "type": "number",
	            "unit": "none"
	        }
	        ],
	        "targets": [
	        {
	            "expr": "chi_clickhouse_metric_VersionInteger{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}",
	            "intervalFactor": 2,
	            "legendFormat": "{{hostname}}",
	            "metric": "chi_clickhouse_metric_VersionInteger",
	            "refId": "A",
	            "step": 60
	        }
	        ],
	        "timeFrom": null,
	        "timeShift": null,
	        "title": "Version",
	        "transform": "timeseries_aggregations",
	        "type": "table-old"
	    },
	    {
	        "cacheTimeout": null,
	        "colorBackground": false,
	        "colorValue": true,
	        "colors": [
	        "rgba(50, 172, 45, 0.97)",
	        "rgba(237, 129, 40, 0.89)",
	        "rgba(245, 54, 54, 0.9)"
	        ],
	        "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	    },
	        "description": "Check Zookeeper connection, Disk Free space and network interconnection between replicas ASAP",
	        "editable": true,
	        "error": false,
	        "fieldConfig": {
	        "defaults": {},
	        "overrides": []
	        },
	        "format": "none",
	        "gauge": {
	        "maxValue": 100,
	        "minValue": 0,
	        "show": false,
	        "thresholdLabels": false,
	        "thresholdMarkers": true
	        },
	        "gridPos": {
	        "h": 2,
	        "w": 3,
	        "x": 10,
	        "y": 2
	        },
	        "id": 6,
	        "interval": null,
	        "isNew": true,
	        "links": [
	        {
	            "targetBlank": true,
	            "title": "Restore After Failures",
	            "url": "https://clickhouse.tech/docs/en/engines/table-engines/mergetree-family/replication/#recovery-after-failures"
	        },
	        {
	            "targetBlank": true,
	            "title": "Restore After Data Loss",
	            "url": "https://clickhouse.tech/docs/en/engines/table-engines/mergetree-family/replication/#recovery-after-complete-data-loss"
	        }
	        ],
	        "mappingType": 1,
	        "mappingTypes": [
	        {
	            "name": "value to text",
	            "value": 1
	        },
	        {
	            "name": "range to text",
	            "value": 2
	        }
	        ],
	        "maxDataPoints": 100,
	        "nullPointMode": "connected",
	        "nullText": null,
	        "postfix": "",
	        "postfixFontSize": "50%",
	        "prefix": "",
	        "prefixFontSize": "50%",
	        "rangeMaps": [
	        {
	            "from": "null",
	            "text": "N/A",
	            "to": "null"
	        }
	        ],
	        "sparkline": {
	        "fillColor": "rgba(31, 118, 189, 0.18)",
	        "full": true,
	        "lineColor": "rgb(31, 120, 193)",
	        "show": true,
	        "ymin": 0
	        },
	        "tableColumn": "",
	        "targets": [
	        {
	            "expr": "sum(chi_clickhouse_metric_ReadonlyReplica{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"})",
	            "intervalFactor": 2,
	            "legendFormat": "",
	            "refId": "A",
	            "step": 60
	        }
	        ],
	        "thresholds": "1,1",
	        "title": "ReadOnly replicas",
	        "type": "singlestat",
	        "valueFontSize": "80%",
	        "valueMaps": [
	        {
	            "op": "=",
	            "text": "N/A",
	            "value": "null"
	        }
	        ],
	        "valueName": "current"
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
	        "description": "Show DNS errors and distributed server-server connections failures",
	        "fieldConfig": {
	        "defaults": {
	            "links": []
	        },
	        "overrides": []
	        },
	        "fill": 1,
	        "fillGradient": 0,
	        "gridPos": {
	        "h": 7,
	        "w": 8,
	        "x": 0,
	        "y": 4
	        },
	        "hiddenSeries": false,
	        "id": 21,
	        "legend": {
	        "alignAsTable": true,
	        "avg": true,
	        "current": true,
	        "hideZero": false,
	        "max": true,
	        "min": true,
	        "show": false,
	        "total": false,
	        "values": true
	        },
	        "lines": true,
	        "linewidth": 1,
	        "links": [
	        {
	            "targetBlank": true,
	            "title": "Manage Distributed tables",
	            "url": "https://clickhouse.tech/docs/en/sql-reference/statements/system/#query-language-system-distributed"
	        },
	        {
	            "targetBlank": true,
	            "title": "DNSError",
	            "url": "https://github.com/ClickHouse/ClickHouse/search?q=DNSError"
	        }
	        ],
	        "nullPointMode": "null",
	        "options": {
	        "alertThreshold": true
	        },
	        "percentage": false,
	        "pluginVersion": "7.5.15",
	        "pointradius": 5,
	        "points": false,
	        "renderer": "flot",
	        "seriesOverrides": [],
	        "spaceLength": 10,
	        "stack": false,
	        "steppedLine": true,
	        "targets": [
	        {
	            "expr": "increase(chi_clickhouse_event_NetworkErrors{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "intervalFactor": 2,
	            "legendFormat": "NetworkErrors {{hostname}}",
	            "metric": "chi_clickhouse_event_NetworkErrors",
	            "refId": "A",
	            "step": 120
	        },
	        {
	            "expr": "increase(chi_clickhouse_event_DistributedConnectionFailAtAll{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "intervalFactor": 2,
	            "legendFormat": "DistributedConnectionFailAtAll {{hostname}}",
	            "metric": "chi_clickhouse_event_DistributedConnectionFailAtAll",
	            "refId": "B",
	            "step": 120
	        },
	        {
	            "expr": "increase(chi_clickhouse_event_DistributedConnectionFailTry{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "intervalFactor": 2,
	            "legendFormat": "DistributedConnectionFailTry {{hostname}}",
	            "metric": "chi_clickhouse_event_DistributedConnectionFailTry",
	            "refId": "C",
	            "step": 120
	        },
	        {
	            "expr": "increase(chi_clickhouse_event_DNSError{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "intervalFactor": 2,
	            "legendFormat": "DNSErrors {{hostname}}",
	            "metric": "chi_clickhouse_event_NetworkErrors",
	            "refId": "D",
	            "step": 120
	        }
	        ],
	        "thresholds": [],
	        "timeFrom": null,
	        "timeRegions": [],
	        "timeShift": null,
	        "title": "DNS and Distributed Connection Errors",
	        "tooltip": {
	        "shared": true,
	        "sort": 0,
	        "value_type": "individual"
	        },
	        "type": "graph",
	        "xaxis": {
	        "buckets": null,
	        "mode": "time",
	        "name": null,
	        "show": true,
	        "values": []
	        },
	        "yaxes": [
	        {
	            "format": "short",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": "0",
	            "show": true
	        },
	        {
	            "format": "short",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": null,
	            "show": true
	        }
	        ],
	        "yaxis": {
	        "align": false,
	        "alignLevel": null
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
	        "description": "Show readonly and partial shutdown replicas, zookeeer exceptions, zookeeer sessions, zookeeper init requests",
	        "fieldConfig": {
	        "defaults": {
	            "links": []
	        },
	        "overrides": []
	        },
	        "fill": 1,
	        "fillGradient": 0,
	        "gridPos": {
	        "h": 7,
	        "w": 8,
	        "x": 8,
	        "y": 4
	        },
	        "hiddenSeries": false,
	        "id": 19,
	        "legend": {
	        "alignAsTable": true,
	        "avg": true,
	        "current": true,
	        "hideZero": false,
	        "max": true,
	        "min": true,
	        "show": false,
	        "total": false,
	        "values": true
	        },
	        "lines": true,
	        "linewidth": 1,
	        "links": [
	        {
	            "targetBlank": true,
	            "title": "Recommened Zookeeper Settings",
	            "url": "https://clickhouse.tech/docs/en/operations/tips/#zookeeper"
	        },
	        {
	            "targetBlank": true,
	            "title": "system.zookeeper",
	            "url": "https://clickhouse.tech/docs/en/operations/system-tables/#system-zookeeper"
	        },
	        {
	            "targetBlank": true,
	            "title": "Replication details",
	            "url": "https://www.slideshare.net/Altinity/introduction-to-the-mysteries-of-clickhouse-replication-by-robert-hodges-and-altinity-engineering-team"
	        }
	        ],
	        "nullPointMode": "null",
	        "options": {
	        "alertThreshold": true
	        },
	        "percentage": false,
	        "pluginVersion": "7.5.15",
	        "pointradius": 5,
	        "points": false,
	        "renderer": "flot",
	        "seriesOverrides": [],
	        "spaceLength": 10,
	        "stack": false,
	        "steppedLine": true,
	        "targets": [
	        {
	            "expr": "chi_clickhouse_metric_ReadonlyReplica{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}",
	            "hide": false,
	            "intervalFactor": 2,
	            "legendFormat": "ReadonlyReplica {{hostname}}",
	            "metric": "chi_clickhouse_metric_ReadonlyReplica",
	            "refId": "D",
	            "step": 120
	        },
	        {
	            "expr": "increase(chi_clickhouse_event_ReplicaPartialShutdown{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "intervalFactor": 2,
	            "legendFormat": "ReplicaPartialShutdown {{hostname}}",
	            "metric": "chi_clickhouse_event_ReplicaPartialShutdown",
	            "refId": "E",
	            "step": 120
	        },
	        {
	            "expr": "increase(chi_clickhouse_event_ZooKeeperUserExceptions{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "hide": true,
	            "intervalFactor": 2,
	            "legendFormat": "ZooKeeperUserExceptions  {{hostname}}",
	            "metric": "chi_clickhouse_event_ZooKeeperUserExceptions",
	            "refId": "B",
	            "step": 120
	        },
	        {
	            "expr": "increase(chi_clickhouse_event_ZooKeeperInit{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "intervalFactor": 2,
	            "legendFormat": "ZooKeeperInit {{hostname}}",
	            "metric": "chi_clickhouse_event_ZooKeeperInit",
	            "refId": "A",
	            "step": 120
	        },
	        {
	            "expr": "increase(chi_clickhouse_metric_ZooKeeperSession{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "intervalFactor": 2,
	            "legendFormat": "ZooKeeperSession  {{hostname}}",
	            "metric": "chi_clickhouse_metric_ZooKeeperSession",
	            "refId": "C",
	            "step": 120
	        },
	        {
	            "expr": "increase(chi_clickhouse_event_ZooKeeperHardwareExceptions{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "intervalFactor": 2,
	            "legendFormat": "ZooKeeperHardwareExceptions  {{hostname}}",
	            "metric": "chi_clickhouse_event_ZooKeeperUserExceptions",
	            "refId": "F",
	            "step": 120
	        }
	        ],
	        "thresholds": [],
	        "timeFrom": null,
	        "timeRegions": [],
	        "timeShift": null,
	        "title": "Replication and ZooKeeper Exceptions",
	        "tooltip": {
	        "shared": true,
	        "sort": 0,
	        "value_type": "individual"
	        },
	        "type": "graph",
	        "xaxis": {
	        "buckets": null,
	        "mode": "time",
	        "name": null,
	        "show": true,
	        "values": []
	        },
	        "yaxes": [
	        {
	            "format": "short",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": "0",
	            "show": true
	        },
	        {
	            "format": "short",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": "0",
	            "show": true
	        }
	        ],
	        "yaxis": {
	        "align": false,
	        "alignLevel": null
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
	        "description": "delayed query\nNumber of INSERT queries that are throttled due to high number of active data parts for partition in a *MergeTree table.\n\ndelayed blocks\nNumber of times the INSERT of a block to a *MergeTree table was throttled due to high number of active data parts for partition. \n\nrejected blocks\nNumber of times the INSERT of a block to a MergeTree table was rejected with 'Too many parts' exception due to high number of active data parts for partition.\n\n\nplease look\nparts_to_delay_insert\nparts_to_throw_insert\n\nin system.merge_tree_settings table",
	        "editable": true,
	        "error": false,
	        "fieldConfig": {
	        "defaults": {
	            "links": []
	        },
	        "overrides": []
	        },
	        "fill": 1,
	        "fillGradient": 0,
	        "grid": {},
	        "gridPos": {
	        "h": 7,
	        "w": 8,
	        "x": 16,
	        "y": 4
	        },
	        "hiddenSeries": false,
	        "id": 5,
	        "isNew": true,
	        "legend": {
	        "avg": false,
	        "current": false,
	        "hideEmpty": false,
	        "hideZero": false,
	        "max": false,
	        "min": false,
	        "show": false,
	        "total": false,
	        "values": false
	        },
	        "lines": true,
	        "linewidth": 2,
	        "links": [
	        {
	            "targetBlank": true,
	            "title": "system.parts_log",
	            "url": "https://clickhouse.tech/docs/en/operations/system-tables/#system_tables-part-log"
	        },
	        {
	            "targetBlank": true,
	            "title": "system.merge_tree_settings",
	            "url": "https://clickhouse.tech/docs/en/operations/system-tables/#system-merge_tree_settings"
	        }
	        ],
	        "nullPointMode": "null",
	        "options": {
	        "alertThreshold": true
	        },
	        "percentage": false,
	        "pluginVersion": "7.5.15",
	        "pointradius": 5,
	        "points": false,
	        "renderer": "flot",
	        "seriesOverrides": [],
	        "spaceLength": 10,
	        "stack": false,
	        "steppedLine": false,
	        "targets": [
	        {
	            "expr": "chi_clickhouse_metric_DelayedInserts{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}",
	            "intervalFactor": 2,
	            "legendFormat": "delayed  queries {{hostname}}",
	            "refId": "A",
	            "step": 10
	        },
	        {
	            "expr": "increase(chi_clickhouse_event_DelayedInserts{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "intervalFactor": 2,
	            "legendFormat": "delayed blocks {{hostname}}",
	            "refId": "B",
	            "step": 10
	        },
	        {
	            "expr": "increase(chi_clickhouse_event_RejectedInserts{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "intervalFactor": 2,
	            "legendFormat": "rejected blocks {{hostname}}",
	            "refId": "C",
	            "step": 10
	        },
	        {
	            "expr": "chi_clickhouse_metric_DistributedFilesToInsert{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}",
	            "legendFormat": "pending distributed files {{ hostname }}",
	            "refId": "D"
	        },
	        {
	            "expr": "chi_clickhouse_metric_BrokenDistributedFilesToInsert{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}",
	            "legendFormat": "broken distributed files {{ hostname }}",
	            "refId": "E"
	        }
	        ],
	        "thresholds": [],
	        "timeFrom": null,
	        "timeRegions": [],
	        "timeShift": null,
	        "title": "Delayed/Rejected/Pending Inserts",
	        "tooltip": {
	        "msResolution": false,
	        "shared": true,
	        "sort": 0,
	        "value_type": "cumulative"
	        },
	        "type": "graph",
	        "xaxis": {
	        "buckets": null,
	        "mode": "time",
	        "name": null,
	        "show": true,
	        "values": []
	        },
	        "yaxes": [
	        {
	            "format": "short",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": "0",
	            "show": true
	        },
	        {
	            "format": "short",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": null,
	            "show": true
	        }
	        ],
	        "yaxis": {
	        "align": false,
	        "alignLevel": null
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
	        "description": "Number of SELECT queries started to be interpreted and maybe executed. Does not include queries that are failed to parse, that are rejected due to AST size limits; rejected due to quota limits or limits on number of simultaneously running queries. May include internal queries initiated by ClickHouse itself. Does not count subqueries.",
	        "editable": true,
	        "error": false,
	        "fieldConfig": {
	        "defaults": {
	            "links": []
	        },
	        "overrides": []
	        },
	        "fill": 1,
	        "fillGradient": 0,
	        "grid": {},
	        "gridPos": {
	        "h": 7,
	        "w": 8,
	        "x": 0,
	        "y": 11
	        },
	        "hiddenSeries": false,
	        "id": 1,
	        "isNew": true,
	        "legend": {
	        "avg": true,
	        "current": true,
	        "hideEmpty": true,
	        "hideZero": true,
	        "max": false,
	        "min": false,
	        "show": false,
	        "total": false,
	        "values": true
	        },
	        "lines": true,
	        "linewidth": 2,
	        "links": [
	        {
	            "targetBlank": true,
	            "title": "max_concurent_queries",
	            "url": "https://clickhouse.tech/docs/en/operations/server-configuration-parameters/settings/#max-concurrent-queries"
	        },
	        {
	            "targetBlank": true,
	            "title": "max_execution_time",
	            "url": "https://clickhouse.tech/docs/en/operations/settings/query-complexity/#max-execution-time"
	        }
	        ],
	        "nullPointMode": "null",
	        "options": {
	        "alertThreshold": true
	        },
	        "percentage": false,
	        "pluginVersion": "7.5.15",
	        "pointradius": 5,
	        "points": false,
	        "renderer": "flot",
	        "seriesOverrides": [],
	        "spaceLength": 10,
	        "stack": false,
	        "steppedLine": true,
	        "targets": [
	        {
	            "expr": "irate(chi_clickhouse_event_SelectQuery{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "intervalFactor": 2,
	            "legendFormat": "select {{hostname}}",
	            "refId": "B",
	            "step": 10
	        },
	        {
	            "expr": "irate(chi_clickhouse_event_Query{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "hide": true,
	            "intervalFactor": 2,
	            "legendFormat": "total {{hostname}}",
	            "refId": "A",
	            "step": 10
	        }
	        ],
	        "thresholds": [],
	        "timeFrom": null,
	        "timeRegions": [],
	        "timeShift": null,
	        "title": "Select Queries",
	        "tooltip": {
	        "msResolution": false,
	        "shared": true,
	        "sort": 0,
	        "value_type": "cumulative"
	        },
	        "type": "graph",
	        "xaxis": {
	        "buckets": null,
	        "mode": "time",
	        "name": null,
	        "show": true,
	        "values": []
	        },
	        "yaxes": [
	        {
	            "format": "short",
	            "label": "",
	            "logBase": 1,
	            "max": null,
	            "min": "0",
	            "show": true
	        },
	        {
	            "format": "short",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": "0",
	            "show": true
	        }
	        ],
	        "yaxis": {
	        "align": false,
	        "alignLevel": null
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
	        "description": "Show how much bytes read and decompress via compressed buffer on each server in cluster",
	        "editable": true,
	        "error": false,
	        "fieldConfig": {
	        "defaults": {
	            "links": []
	        },
	        "overrides": []
	        },
	        "fill": 1,
	        "fillGradient": 1,
	        "grid": {},
	        "gridPos": {
	        "h": 7,
	        "w": 8,
	        "x": 8,
	        "y": 11
	        },
	        "hiddenSeries": false,
	        "id": 8,
	        "isNew": true,
	        "legend": {
	        "avg": false,
	        "current": false,
	        "hideEmpty": true,
	        "hideZero": false,
	        "max": false,
	        "min": false,
	        "show": false,
	        "total": false,
	        "values": false
	        },
	        "lines": true,
	        "linewidth": 2,
	        "links": [
	        {
	            "targetBlank": true,
	            "title": "I/O buffers architecture",
	            "url": "https://clickhouse.tech/docs/en/development/architecture/#io"
	        }
	        ],
	        "nullPointMode": "null",
	        "options": {
	        "alertThreshold": true
	        },
	        "percentage": false,
	        "pluginVersion": "7.5.15",
	        "pointradius": 5,
	        "points": false,
	        "renderer": "flot",
	        "seriesOverrides": [
	        {
	            "alias": "/^uncompressed.+/",
	            "color": "#73BF69"
	        },
	        {
	            "alias": "/^(file descriptor|os).+/",
	            "color": "#F2495C"
	        },
	        {
	            "alias": "/^compressed.+/",
	            "color": "#FADE2A"
	        }
	        ],
	        "spaceLength": 10,
	        "stack": false,
	        "steppedLine": false,
	        "targets": [
	        {
	            "expr": "irate(chi_clickhouse_event_CompressedReadBufferBytes{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "hide": false,
	            "intervalFactor": 2,
	            "legendFormat": "uncompressed {{hostname}}",
	            "refId": "A",
	            "step": 10
	        },
	        {
	            "expr": "irate(chi_clickhouse_event_ReadCompressedBytes{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "hide": false,
	            "interval": "",
	            "intervalFactor": 2,
	            "legendFormat": "compressed {{hostname}}",
	            "refId": "C",
	            "step": 10
	        },
	        {
	            "expr": "irate(chi_clickhouse_event_ReadBufferFromFileDescriptorReadBytes{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "hide": false,
	            "interval": "",
	            "intervalFactor": 2,
	            "legendFormat": "file descriptor {{hostname}}",
	            "refId": "B",
	            "step": 10
	        },
	        {
	            "expr": "irate(chi_clickhouse_event_OSReadBytes{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "hide": false,
	            "interval": "",
	            "intervalFactor": 2,
	            "legendFormat": "os {{hostname}}",
	            "refId": "D",
	            "step": 10
	        }
	        ],
	        "thresholds": [],
	        "timeFrom": null,
	        "timeRegions": [],
	        "timeShift": null,
	        "title": "Read Bytes",
	        "tooltip": {
	        "msResolution": false,
	        "shared": true,
	        "sort": 0,
	        "value_type": "cumulative"
	        },
	        "type": "graph",
	        "xaxis": {
	        "buckets": null,
	        "mode": "time",
	        "name": null,
	        "show": true,
	        "values": []
	        },
	        "yaxes": [
	        {
	            "format": "bytes",
	            "label": "",
	            "logBase": 10,
	            "max": null,
	            "min": "0",
	            "show": true
	        },
	        {
	            "decimals": null,
	            "format": "short",
	            "label": "",
	            "logBase": 1,
	            "max": null,
	            "min": null,
	            "show": false
	        }
	        ],
	        "yaxis": {
	        "align": false,
	        "alignLevel": null
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
	        "description": "Total amount of memory (bytes) allocated in currently executing queries. \n\nNote that some memory allocations may not be accounted.",
	        "editable": true,
	        "error": false,
	        "fieldConfig": {
	        "defaults": {
	            "links": []
	        },
	        "overrides": []
	        },
	        "fill": 1,
	        "fillGradient": 0,
	        "grid": {},
	        "gridPos": {
	        "h": 7,
	        "w": 8,
	        "x": 16,
	        "y": 11
	        },
	        "hiddenSeries": false,
	        "id": 13,
	        "isNew": true,
	        "legend": {
	        "avg": false,
	        "current": false,
	        "hideEmpty": false,
	        "hideZero": false,
	        "max": false,
	        "min": false,
	        "show": false,
	        "total": false,
	        "values": false
	        },
	        "lines": true,
	        "linewidth": 2,
	        "links": [
	        {
	            "targetBlank": true,
	            "title": "max_memory_usage",
	            "url": "https://clickhouse.tech/docs/en/operations/settings/query-complexity/#settings_max_memory_usage"
	        }
	        ],
	        "nullPointMode": "null",
	        "options": {
	        "alertThreshold": true
	        },
	        "percentage": false,
	        "pluginVersion": "7.5.15",
	        "pointradius": 5,
	        "points": false,
	        "renderer": "flot",
	        "seriesOverrides": [],
	        "spaceLength": 10,
	        "stack": false,
	        "steppedLine": false,
	        "targets": [
	        {
	            "expr": "chi_clickhouse_metric_MemoryTracking{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}",
	            "intervalFactor": 2,
	            "legendFormat": "{{hostname}}",
	            "refId": "A",
	            "step": 10
	        }
	        ],
	        "thresholds": [],
	        "timeFrom": null,
	        "timeRegions": [],
	        "timeShift": null,
	        "title": "Memory for Queries",
	        "tooltip": {
	        "msResolution": false,
	        "shared": true,
	        "sort": 0,
	        "value_type": "cumulative"
	        },
	        "type": "graph",
	        "xaxis": {
	        "buckets": null,
	        "mode": "time",
	        "name": null,
	        "show": true,
	        "values": []
	        },
	        "yaxes": [
	        {
	            "format": "bytes",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": "0",
	            "show": true
	        },
	        {
	            "format": "short",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": "0",
	            "show": true
	        }
	        ],
	        "yaxis": {
	        "align": false,
	        "alignLevel": null
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
	        "description": "Number of INSERT queries to be interpreted and potentially executed. Does not include queries that failed to parse or were rejected due to AST size limits, quota limits or limits on the number of simultaneously running queries. May include internal queries initiated by ClickHouse itself. Does not count subqueries.",
	        "editable": true,
	        "error": false,
	        "fieldConfig": {
	        "defaults": {
	            "links": []
	        },
	        "overrides": []
	        },
	        "fill": 1,
	        "fillGradient": 0,
	        "grid": {},
	        "gridPos": {
	        "h": 7,
	        "w": 8,
	        "x": 0,
	        "y": 18
	        },
	        "hiddenSeries": false,
	        "id": 30,
	        "isNew": true,
	        "legend": {
	        "avg": false,
	        "current": false,
	        "hideEmpty": false,
	        "hideZero": false,
	        "max": false,
	        "min": false,
	        "show": false,
	        "total": false,
	        "values": false
	        },
	        "lines": true,
	        "linewidth": 2,
	        "links": [
	        {
	            "targetBlank": true,
	            "title": "max_memory_usage",
	            "url": "https://clickhouse.tech/docs/en/operations/settings/query-complexity/#settings_max_memory_usage"
	        }
	        ],
	        "nullPointMode": "null",
	        "options": {
	        "alertThreshold": true
	        },
	        "percentage": false,
	        "pluginVersion": "7.5.15",
	        "pointradius": 5,
	        "points": false,
	        "renderer": "flot",
	        "seriesOverrides": [
	        {},
	        {}
	        ],
	        "spaceLength": 10,
	        "stack": false,
	        "steppedLine": false,
	        "targets": [
	        {
	            "expr": "irate(chi_clickhouse_event_InsertQuery{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "legendFormat": "Insert queries {{hostname}}",
	            "refId": "C"
	        }
	        ],
	        "thresholds": [],
	        "timeFrom": null,
	        "timeRegions": [],
	        "timeShift": null,
	        "title": "Insert Queries",
	        "tooltip": {
	        "msResolution": false,
	        "shared": true,
	        "sort": 0,
	        "value_type": "cumulative"
	        },
	        "type": "graph",
	        "xaxis": {
	        "buckets": null,
	        "mode": "time",
	        "name": null,
	        "show": true,
	        "values": []
	        },
	        "yaxes": [
	        {
	            "format": "short",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": "0",
	            "show": true
	        },
	        {
	            "format": "reqps",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": null,
	            "show": false
	        }
	        ],
	        "yaxis": {
	        "align": false,
	        "alignLevel": null
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
	        "description": "## Tracks amount of inserted data.",
	        "editable": true,
	        "error": false,
	        "fieldConfig": {
	        "defaults": {
	            "links": []
	        },
	        "overrides": []
	        },
	        "fill": 1,
	        "fillGradient": 0,
	        "grid": {},
	        "gridPos": {
	        "h": 7,
	        "w": 8,
	        "x": 8,
	        "y": 18
	        },
	        "hiddenSeries": false,
	        "id": 37,
	        "isNew": true,
	        "legend": {
	        "avg": false,
	        "current": false,
	        "hideEmpty": false,
	        "hideZero": false,
	        "max": false,
	        "min": false,
	        "show": false,
	        "total": false,
	        "values": false
	        },
	        "lines": true,
	        "linewidth": 2,
	        "links": [
	        {
	            "targetBlank": true,
	            "title": "max_memory_usage",
	            "url": "https://clickhouse.tech/docs/en/operations/settings/query-complexity/#settings_max_memory_usage"
	        }
	        ],
	        "nullPointMode": "null",
	        "options": {
	        "alertThreshold": true
	        },
	        "percentage": false,
	        "pluginVersion": "7.5.15",
	        "pointradius": 5,
	        "points": false,
	        "renderer": "flot",
	        "seriesOverrides": [
	        {},
	        {}
	        ],
	        "spaceLength": 10,
	        "stack": false,
	        "steppedLine": false,
	        "targets": [
	        {
	            "expr": "irate(chi_clickhouse_event_InsertedBytes{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "legendFormat": "Insert bytes {{hostname}}",
	            "refId": "A"
	        }
	        ],
	        "thresholds": [],
	        "timeFrom": null,
	        "timeRegions": [],
	        "timeShift": null,
	        "title": "Bytes Inserted",
	        "tooltip": {
	        "msResolution": false,
	        "shared": true,
	        "sort": 0,
	        "value_type": "cumulative"
	        },
	        "type": "graph",
	        "xaxis": {
	        "buckets": null,
	        "mode": "time",
	        "name": null,
	        "show": true,
	        "values": []
	        },
	        "yaxes": [
	        {
	            "format": "bytes",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": "0",
	            "show": true
	        },
	        {
	            "format": "reqps",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": null,
	            "show": false
	        }
	        ],
	        "yaxis": {
	        "align": false,
	        "alignLevel": null
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
	        "description": "## Tracks rows of inserted data.",
	        "editable": true,
	        "error": false,
	        "fieldConfig": {
	        "defaults": {
	            "links": []
	        },
	        "overrides": []
	        },
	        "fill": 1,
	        "fillGradient": 0,
	        "grid": {},
	        "gridPos": {
	        "h": 7,
	        "w": 8,
	        "x": 16,
	        "y": 18
	        },
	        "hiddenSeries": false,
	        "id": 32,
	        "isNew": true,
	        "legend": {
	        "avg": false,
	        "current": false,
	        "hideEmpty": false,
	        "hideZero": false,
	        "max": false,
	        "min": false,
	        "show": false,
	        "total": false,
	        "values": false
	        },
	        "lines": true,
	        "linewidth": 2,
	        "links": [
	        {
	            "targetBlank": true,
	            "title": "max_memory_usage",
	            "url": "https://clickhouse.tech/docs/en/operations/settings/query-complexity/#settings_max_memory_usage"
	        }
	        ],
	        "nullPointMode": "null",
	        "options": {
	        "alertThreshold": true
	        },
	        "percentage": false,
	        "pluginVersion": "7.5.15",
	        "pointradius": 5,
	        "points": false,
	        "renderer": "flot",
	        "seriesOverrides": [
	        {},
	        {}
	        ],
	        "spaceLength": 10,
	        "stack": false,
	        "steppedLine": false,
	        "targets": [
	        {
	            "expr": "irate(chi_clickhouse_event_InsertedRows{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "legendFormat": "Insert rows {{hostname}}",
	            "refId": "A"
	        }
	        ],
	        "thresholds": [],
	        "timeFrom": null,
	        "timeRegions": [],
	        "timeShift": null,
	        "title": "Rows Inserted",
	        "tooltip": {
	        "msResolution": false,
	        "shared": true,
	        "sort": 0,
	        "value_type": "cumulative"
	        },
	        "type": "graph",
	        "xaxis": {
	        "buckets": null,
	        "mode": "time",
	        "name": null,
	        "show": true,
	        "values": []
	        },
	        "yaxes": [
	        {
	            "format": "short",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": "0",
	            "show": true
	        },
	        {
	            "format": "reqps",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": null,
	            "show": false
	        }
	        ],
	        "yaxis": {
	        "align": false,
	        "alignLevel": null
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
	        "description": "Show how intensive data exchange between replicas in parts",
	        "editable": true,
	        "error": false,
	        "fieldConfig": {
	        "defaults": {
	            "links": []
	        },
	        "overrides": []
	        },
	        "fill": 1,
	        "fillGradient": 0,
	        "grid": {},
	        "gridPos": {
	        "h": 7,
	        "w": 8,
	        "x": 0,
	        "y": 25
	        },
	        "hiddenSeries": false,
	        "id": 3,
	        "isNew": true,
	        "legend": {
	        "alignAsTable": false,
	        "avg": true,
	        "current": true,
	        "hideEmpty": false,
	        "hideZero": false,
	        "max": false,
	        "min": false,
	        "show": false,
	        "total": false,
	        "values": true
	        },
	        "lines": true,
	        "linewidth": 2,
	        "links": [
	        {
	            "targetBlank": true,
	            "title": "How replication works",
	            "url": "https://clickhouse.tech/docs/en/engines/table-engines/mergetree-family/replication/"
	        }
	        ],
	        "nullPointMode": "null",
	        "options": {
	        "alertThreshold": true
	        },
	        "percentage": false,
	        "pluginVersion": "7.5.15",
	        "pointradius": 5,
	        "points": false,
	        "renderer": "flot",
	        "seriesOverrides": [
	        {
	            "$$hashKey": "object:227",
	            "alias": "/^max.+/",
	            "color": "#FFA6B0"
	        },
	        {
	            "$$hashKey": "object:228",
	            "alias": "/^check.+/",
	            "color": "#FF9830"
	        },
	        {
	            "$$hashKey": "object:229",
	            "alias": "/^fetch.+/",
	            "color": "#B877D9"
	        },
	        {
	            "$$hashKey": "object:338",
	            "alias": "/^(data loss|fetch fail|check fail).+/",
	            "color": "#C4162A"
	        },
	        {
	            "$$hashKey": "object:1252",
	            "alias": "/^replicated merge.+/",
	            "color": "#DEB6F2"
	        }
	        ],
	        "spaceLength": 10,
	        "stack": false,
	        "steppedLine": false,
	        "targets": [
	        {
	            "exemplar": true,
	            "expr": "irate(chi_clickhouse_event_ReplicatedDataLoss{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "interval": "",
	            "intervalFactor": 2,
	            "legendFormat": "data loss {{hostname}}",
	            "refId": "A",
	            "step": 20
	        },
	        {
	            "exemplar": true,
	            "expr": "irate(chi_clickhouse_event_ReplicatedPartChecks{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "hide": false,
	            "interval": "",
	            "intervalFactor": 2,
	            "legendFormat": "check {{hostname}}",
	            "refId": "B",
	            "step": 20
	        },
	        {
	            "exemplar": true,
	            "expr": "irate(chi_clickhouse_event_ReplicatedPartChecksFailed{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "hide": false,
	            "interval": "",
	            "intervalFactor": 2,
	            "legendFormat": "check fail {{hostname}}",
	            "refId": "C",
	            "step": 20
	        },
	        {
	            "exemplar": true,
	            "expr": "irate(chi_clickhouse_event_ReplicatedPartFetches{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "hide": false,
	            "interval": "",
	            "intervalFactor": 2,
	            "legendFormat": "fetch {{hostname}}",
	            "refId": "D",
	            "step": 20
	        },
	        {
	            "exemplar": true,
	            "expr": "irate(chi_clickhouse_event_ReplicatedPartFailedFetches{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "hide": false,
	            "interval": "",
	            "intervalFactor": 2,
	            "legendFormat": "fetch fail {{hostname}}",
	            "refId": "E",
	            "step": 20
	        },
	        {
	            "exemplar": true,
	            "expr": "irate(chi_clickhouse_event_ReplicatedPartFetchesOfMerged{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "hide": false,
	            "interval": "",
	            "intervalFactor": 2,
	            "legendFormat": "fetch merged {{hostname}}",
	            "refId": "F",
	            "step": 20
	        },
	        {
	            "exemplar": true,
	            "expr": "irate(chi_clickhouse_event_ReplicatedPartMerges{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "hide": false,
	            "interval": "",
	            "intervalFactor": 2,
	            "legendFormat": "replicated merge {{hostname}}",
	            "refId": "G",
	            "step": 20
	        },
	        {
	            "expr": "chi_clickhouse_metric_ReplicasSumInsertsInQueue{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}",
	            "legendFormat": "inserts in queue {{hostname}}",
	            "refId": "H"
	        },
	        {
	            "expr": "chi_clickhouse_metric_ReplicasSumMergesInQueue{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}",
	            "legendFormat": "merges in queue {{hostname}}",
	            "refId": "I"
	        }
	        ],
	        "thresholds": [],
	        "timeFrom": null,
	        "timeRegions": [],
	        "timeShift": null,
	        "title": "Replication Queue Jobs",
	        "tooltip": {
	        "msResolution": false,
	        "shared": true,
	        "sort": 0,
	        "value_type": "individual"
	        },
	        "type": "graph",
	        "xaxis": {
	        "buckets": null,
	        "mode": "time",
	        "name": null,
	        "show": true,
	        "values": []
	        },
	        "yaxes": [
	        {
	            "format": "short",
	            "label": "",
	            "logBase": 1,
	            "max": null,
	            "min": "0",
	            "show": true
	        },
	        {
	            "format": "short",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": null,
	            "show": false
	        }
	        ],
	        "yaxis": {
	        "align": false,
	        "alignLevel": null
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
	        "description": "Show seconds when replicated servers can be delayed relative to current time,  when you insert directly in *ReplicatedMegreTree table on one server clickhouse need time to replicate new parts of data to another servers in same shard in background",
	        "editable": true,
	        "error": false,
	        "fieldConfig": {
	        "defaults": {
	            "links": []
	        },
	        "overrides": []
	        },
	        "fill": 1,
	        "fillGradient": 0,
	        "grid": {},
	        "gridPos": {
	        "h": 7,
	        "w": 8,
	        "x": 8,
	        "y": 25
	        },
	        "hiddenSeries": false,
	        "id": 7,
	        "isNew": true,
	        "legend": {
	        "avg": true,
	        "current": true,
	        "hideEmpty": false,
	        "hideZero": false,
	        "max": false,
	        "min": false,
	        "show": false,
	        "total": false,
	        "values": true
	        },
	        "lines": true,
	        "linewidth": 2,
	        "links": [
	        {
	            "targetBlank": true,
	            "title": "Replication architecture",
	            "url": "https://clickhouse.tech/docs/en/development/architecture/#replication"
	        },
	        {
	            "targetBlank": true,
	            "title": "ReplicatedMergeTree engine",
	            "url": "https://clickhouse.tech/docs/en/engines/table-engines/mergetree-family/replication/"
	        },
	        {
	            "targetBlank": true,
	            "title": "max_replica_delay_for_distributed_queries",
	            "url": "https://clickhouse.tech/docs/en/operations/settings/settings/#settings-max_replica_delay_for_distributed_queries"
	        }
	        ],
	        "nullPointMode": "null",
	        "options": {
	        "alertThreshold": true
	        },
	        "percentage": false,
	        "pluginVersion": "7.5.15",
	        "pointradius": 5,
	        "points": false,
	        "renderer": "flot",
	        "seriesOverrides": [
	        {
	            "alias": "/^absolute.+/",
	            "color": "#F2495C"
	        },
	        {
	            "alias": "/^relative.+/",
	            "color": "#FADE2A"
	        }
	        ],
	        "spaceLength": 10,
	        "stack": false,
	        "steppedLine": false,
	        "targets": [
	        {
	            "expr": "chi_clickhouse_metric_ReplicasMaxAbsoluteDelay{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}",
	            "intervalFactor": 2,
	            "legendFormat": "absolute {{hostname}}",
	            "refId": "A",
	            "step": 10
	        },
	        {
	            "expr": "chi_clickhouse_metric_ReplicasMaxRelativeDelay{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}",
	            "intervalFactor": 2,
	            "legendFormat": "relative {{hostname}}",
	            "refId": "B",
	            "step": 10
	        }
	        ],
	        "thresholds": [],
	        "timeFrom": null,
	        "timeRegions": [],
	        "timeShift": null,
	        "title": "Max Replica Delay",
	        "tooltip": {
	        "msResolution": false,
	        "shared": true,
	        "sort": 0,
	        "value_type": "cumulative"
	        },
	        "type": "graph",
	        "xaxis": {
	        "buckets": null,
	        "mode": "time",
	        "name": null,
	        "show": true,
	        "values": []
	        },
	        "yaxes": [
	        {
	            "format": "short",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": "0",
	            "show": true
	        },
	        {
	            "format": "short",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": null,
	            "show": true
	        }
	        ],
	        "yaxis": {
	        "align": false,
	        "alignLevel": null
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
	        "description": "Number of requests to ZooKeeper transactions per seconds.",
	        "editable": true,
	        "error": false,
	        "fieldConfig": {
	        "defaults": {
	            "links": []
	        },
	        "overrides": []
	        },
	        "fill": 1,
	        "fillGradient": 0,
	        "grid": {},
	        "gridPos": {
	        "h": 7,
	        "w": 8,
	        "x": 16,
	        "y": 25
	        },
	        "hiddenSeries": false,
	        "id": 34,
	        "isNew": true,
	        "legend": {
	        "avg": true,
	        "current": true,
	        "hideEmpty": false,
	        "hideZero": false,
	        "max": false,
	        "min": false,
	        "show": false,
	        "total": false,
	        "values": true
	        },
	        "lines": true,
	        "linewidth": 2,
	        "links": [
	        {
	            "targetBlank": true,
	            "title": "Replication architecture",
	            "url": "https://clickhouse.tech/docs/en/development/architecture/#replication"
	        }
	        ],
	        "nullPointMode": "null",
	        "options": {
	        "alertThreshold": true
	        },
	        "percentage": false,
	        "pluginVersion": "7.5.15",
	        "pointradius": 5,
	        "points": false,
	        "renderer": "flot",
	        "seriesOverrides": [],
	        "spaceLength": 10,
	        "stack": false,
	        "steppedLine": false,
	        "targets": [
	        {
	            "expr": "irate(chi_clickhouse_event_ZooKeeperTransactions{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "legendFormat": "transactions {{ hostname }}",
	            "refId": "B"
	        },
	        {
	            "expr": "chi_clickhouse_metric_ZooKeeperRequest{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}",
	            "hide": true,
	            "legendFormat": "{{ hostname }}",
	            "refId": "A"
	        }
	        ],
	        "thresholds": [],
	        "timeFrom": null,
	        "timeRegions": [],
	        "timeShift": null,
	        "title": "Zookeeper Transactions",
	        "tooltip": {
	        "msResolution": false,
	        "shared": true,
	        "sort": 0,
	        "value_type": "cumulative"
	        },
	        "type": "graph",
	        "xaxis": {
	        "buckets": null,
	        "mode": "time",
	        "name": null,
	        "show": true,
	        "values": []
	        },
	        "yaxes": [
	        {
	            "format": "short",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": "0",
	            "show": true
	        },
	        {
	            "format": "short",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": null,
	            "show": false
	        }
	        ],
	        "yaxis": {
	        "align": false,
	        "alignLevel": null
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
	        "description": "Show how intensive background merge processes",
	        "editable": true,
	        "error": false,
	        "fieldConfig": {
	        "defaults": {
	            "links": []
	        },
	        "overrides": []
	        },
	        "fill": 1,
	        "fillGradient": 0,
	        "grid": {},
	        "gridPos": {
	        "h": 7,
	        "w": 8,
	        "x": 0,
	        "y": 32
	        },
	        "hiddenSeries": false,
	        "id": 2,
	        "isNew": true,
	        "legend": {
	        "avg": false,
	        "current": true,
	        "hideEmpty": false,
	        "hideZero": false,
	        "max": false,
	        "min": false,
	        "show": false,
	        "total": false,
	        "values": true
	        },
	        "lines": true,
	        "linewidth": 2,
	        "links": [
	        {
	            "targetBlank": true,
	            "title": "START/STOP Merges",
	            "url": "https://clickhouse.tech/docs/en/sql-reference/statements/system/#query_language-system-stop-merges"
	        },
	        {
	            "targetBlank": true,
	            "title": "MegreTree Engine description",
	            "url": "https://clickhouse.tech/docs/en/engines/table-engines/mergetree-family/mergetree/"
	        }
	        ],
	        "nullPointMode": "null",
	        "options": {
	        "alertThreshold": true
	        },
	        "percentage": false,
	        "pluginVersion": "7.5.15",
	        "pointradius": 5,
	        "points": false,
	        "renderer": "flot",
	        "seriesOverrides": [],
	        "spaceLength": 10,
	        "stack": false,
	        "steppedLine": true,
	        "targets": [
	        {
	            "expr": "irate(chi_clickhouse_event_Merge{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "intervalFactor": 2,
	            "legendFormat": "merges {{hostname}}",
	            "refId": "A",
	            "step": 4
	        }
	        ],
	        "thresholds": [],
	        "timeFrom": null,
	        "timeRegions": [],
	        "timeShift": null,
	        "title": "Merges",
	        "tooltip": {
	        "msResolution": false,
	        "shared": true,
	        "sort": 2,
	        "value_type": "cumulative"
	        },
	        "type": "graph",
	        "xaxis": {
	        "buckets": null,
	        "mode": "time",
	        "name": null,
	        "show": true,
	        "values": []
	        },
	        "yaxes": [
	        {
	            "decimals": null,
	            "format": "short",
	            "label": "",
	            "logBase": 1,
	            "max": null,
	            "min": "0",
	            "show": true
	        },
	        {
	            "format": "short",
	            "label": "",
	            "logBase": 1,
	            "max": null,
	            "min": "0",
	            "show": true
	        }
	        ],
	        "yaxis": {
	        "align": false,
	        "alignLevel": null
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
	        "description": "Show how intensive background merge processes",
	        "editable": true,
	        "error": false,
	        "fieldConfig": {
	        "defaults": {
	            "links": []
	        },
	        "overrides": []
	        },
	        "fill": 1,
	        "fillGradient": 0,
	        "grid": {},
	        "gridPos": {
	        "h": 7,
	        "w": 8,
	        "x": 8,
	        "y": 32
	        },
	        "hiddenSeries": false,
	        "id": 36,
	        "isNew": true,
	        "legend": {
	        "avg": false,
	        "current": true,
	        "hideEmpty": false,
	        "hideZero": false,
	        "max": false,
	        "min": false,
	        "show": false,
	        "total": false,
	        "values": true
	        },
	        "lines": true,
	        "linewidth": 2,
	        "links": [
	        {
	            "targetBlank": true,
	            "title": "START/STOP Merges",
	            "url": "https://clickhouse.tech/docs/en/sql-reference/statements/system/#query_language-system-stop-merges"
	        },
	        {
	            "targetBlank": true,
	            "title": "MegreTree Engine description",
	            "url": "https://clickhouse.tech/docs/en/engines/table-engines/mergetree-family/mergetree/"
	        }
	        ],
	        "nullPointMode": "null",
	        "options": {
	        "alertThreshold": true
	        },
	        "percentage": false,
	        "pluginVersion": "7.5.15",
	        "pointradius": 5,
	        "points": false,
	        "renderer": "flot",
	        "seriesOverrides": [],
	        "spaceLength": 10,
	        "stack": false,
	        "steppedLine": true,
	        "targets": [
	        {
	            "expr": "irate(chi_clickhouse_event_MergedRows{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "intervalFactor": 2,
	            "legendFormat": "rows {{hostname}}",
	            "refId": "B",
	            "step": 4
	        }
	        ],
	        "thresholds": [],
	        "timeFrom": null,
	        "timeRegions": [],
	        "timeShift": null,
	        "title": "Merged Rows",
	        "tooltip": {
	        "msResolution": false,
	        "shared": true,
	        "sort": 2,
	        "value_type": "cumulative"
	        },
	        "type": "graph",
	        "xaxis": {
	        "buckets": null,
	        "mode": "time",
	        "name": null,
	        "show": true,
	        "values": []
	        },
	        "yaxes": [
	        {
	            "decimals": null,
	            "format": "short",
	            "label": "",
	            "logBase": 1,
	            "max": null,
	            "min": "0",
	            "show": true
	        },
	        {
	            "format": "short",
	            "label": "",
	            "logBase": 1,
	            "max": null,
	            "min": null,
	            "show": true
	        }
	        ],
	        "yaxis": {
	        "align": false,
	        "alignLevel": null
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
	        "description": "Show how intensive background merge processes",
	        "editable": true,
	        "error": false,
	        "fieldConfig": {
	        "defaults": {
	            "links": []
	        },
	        "overrides": []
	        },
	        "fill": 1,
	        "fillGradient": 0,
	        "grid": {},
	        "gridPos": {
	        "h": 7,
	        "w": 8,
	        "x": 16,
	        "y": 32
	        },
	        "hiddenSeries": false,
	        "id": 49,
	        "isNew": true,
	        "legend": {
	        "avg": false,
	        "current": true,
	        "hideEmpty": false,
	        "hideZero": false,
	        "max": false,
	        "min": false,
	        "show": false,
	        "total": false,
	        "values": true
	        },
	        "lines": true,
	        "linewidth": 2,
	        "links": [
	        {
	            "targetBlank": true,
	            "title": "START/STOP Merges",
	            "url": "https://clickhouse.tech/docs/en/sql-reference/statements/system/#query_language-system-stop-merges"
	        },
	        {
	            "targetBlank": true,
	            "title": "MegreTree Engine description",
	            "url": "https://clickhouse.tech/docs/en/engines/table-engines/mergetree-family/mergetree/"
	        }
	        ],
	        "nullPointMode": "null",
	        "options": {
	        "alertThreshold": true
	        },
	        "percentage": false,
	        "pluginVersion": "7.5.15",
	        "pointradius": 5,
	        "points": false,
	        "renderer": "flot",
	        "seriesOverrides": [],
	        "spaceLength": 10,
	        "stack": false,
	        "steppedLine": true,
	        "targets": [
	        {
	            "expr": "irate(chi_clickhouse_event_MergedUncompressedBytes{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "intervalFactor": 2,
	            "legendFormat": "bytes {{hostname}}",
	            "refId": "B",
	            "step": 4
	        }
	        ],
	        "thresholds": [],
	        "timeFrom": null,
	        "timeRegions": [],
	        "timeShift": null,
	        "title": "Merged Uncompressed Bytes",
	        "tooltip": {
	        "msResolution": false,
	        "shared": true,
	        "sort": 2,
	        "value_type": "cumulative"
	        },
	        "type": "graph",
	        "xaxis": {
	        "buckets": null,
	        "mode": "time",
	        "name": null,
	        "show": true,
	        "values": []
	        },
	        "yaxes": [
	        {
	            "decimals": null,
	            "format": "decbytes",
	            "label": "",
	            "logBase": 1,
	            "max": null,
	            "min": "0",
	            "show": true
	        },
	        {
	            "format": "short",
	            "label": "",
	            "logBase": 1,
	            "max": null,
	            "min": null,
	            "show": true
	        }
	        ],
	        "yaxis": {
	        "align": false,
	        "alignLevel": null
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
	        "decimals": 0,
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
	        "h": 7,
	        "w": 8,
	        "x": 0,
	        "y": 39
	        },
	        "hiddenSeries": false,
	        "id": 23,
	        "legend": {
	        "alignAsTable": true,
	        "avg": true,
	        "current": true,
	        "hideEmpty": false,
	        "hideZero": false,
	        "max": true,
	        "min": true,
	        "show": false,
	        "total": false,
	        "values": true
	        },
	        "lines": true,
	        "linewidth": 1,
	        "links": [
	        {
	            "targetBlank": true,
	            "title": "system.parts",
	            "url": "https://clickhouse.tech/docs/en/operations/system-tables/#system_tables-parts"
	        },
	        {
	            "targetBlank": true,
	            "title": "parts_to_delay_insert",
	            "url": "https://github.com/ClickHouse/ClickHouse/search?q=parts_to_delay_insert"
	        }
	        ],
	        "nullPointMode": "null",
	        "options": {
	        "alertThreshold": true
	        },
	        "percentage": false,
	        "pluginVersion": "7.5.15",
	        "pointradius": 5,
	        "points": false,
	        "renderer": "flot",
	        "seriesOverrides": [],
	        "spaceLength": 10,
	        "stack": false,
	        "steppedLine": false,
	        "targets": [
	        {
	            "expr": "sum by(hostname) (chi_clickhouse_table_parts{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\",active=\"1\"})",
	            "legendFormat": "Parts {{hostname}}",
	            "refId": "C"
	        }
	        ],
	        "thresholds": [],
	        "timeFrom": null,
	        "timeRegions": [],
	        "timeShift": null,
	        "title": "Active Parts",
	        "tooltip": {
	        "shared": true,
	        "sort": 0,
	        "value_type": "individual"
	        },
	        "type": "graph",
	        "xaxis": {
	        "buckets": null,
	        "mode": "time",
	        "name": null,
	        "show": true,
	        "values": []
	        },
	        "yaxes": [
	        {
	            "format": "short",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": "0",
	            "show": true
	        },
	        {
	            "format": "short",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": "0",
	            "show": false
	        }
	        ],
	        "yaxis": {
	        "align": false,
	        "alignLevel": null
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
	        "decimals": 0,
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
	        "h": 7,
	        "w": 8,
	        "x": 8,
	        "y": 39
	        },
	        "hiddenSeries": false,
	        "id": 50,
	        "legend": {
	        "alignAsTable": true,
	        "avg": true,
	        "current": true,
	        "hideEmpty": false,
	        "hideZero": false,
	        "max": true,
	        "min": true,
	        "show": false,
	        "total": false,
	        "values": true
	        },
	        "lines": true,
	        "linewidth": 1,
	        "links": [
	        {
	            "targetBlank": true,
	            "title": "system.detached_parts",
	            "url": "https://clickhouse.tech/docs/en/operations/system-tables/detached_parts/"
	        }
	        ],
	        "nullPointMode": "null",
	        "options": {
	        "alertThreshold": true
	        },
	        "percentage": false,
	        "pluginVersion": "7.5.15",
	        "pointradius": 5,
	        "points": false,
	        "renderer": "flot",
	        "seriesOverrides": [
	        {
	            "$$hashKey": "object:254",
	            "alias": "/.*detached_by_user.*/",
	            "color": "#CA95E5"
	        },
	        {
	            "$$hashKey": "object:285",
	            "alias": "/.*broken.*/",
	            "color": "#E02F44"
	        },
	        {
	            "$$hashKey": "object:355",
	            "alias": "/.*(clone|ignored).*/",
	            "color": "#FFEE52"
	        },
	        {
	            "$$hashKey": "object:447",
	            "alias": "/^Inactive/",
	            "yaxis": 2
	        }
	        ],
	        "spaceLength": 10,
	        "stack": false,
	        "steppedLine": false,
	        "targets": [
	        {
	            "expr": "sum by(hostname,reason) (chi_clickhouse_metric_DetachedParts{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"})",
	            "interval": "",
	            "legendFormat": "{{reason}} {{hostname}} ",
	            "refId": "C"
	        },
	        {
	            "expr": "sum by(hostname) (chi_clickhouse_table_parts{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\",active=\"0\"})",
	            "hide": true,
	            "interval": "",
	            "legendFormat": "Inactive {{hostname}} ",
	            "refId": "A"
	        }
	        ],
	        "thresholds": [],
	        "timeFrom": null,
	        "timeRegions": [],
	        "timeShift": null,
	        "title": "Detached parts",
	        "tooltip": {
	        "shared": true,
	        "sort": 0,
	        "value_type": "individual"
	        },
	        "type": "graph",
	        "xaxis": {
	        "buckets": null,
	        "mode": "time",
	        "name": null,
	        "show": true,
	        "values": []
	        },
	        "yaxes": [
	        {
	            "format": "short",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": "0",
	            "show": true
	        },
	        {
	            "format": "short",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": "0",
	            "show": false
	        }
	        ],
	        "yaxis": {
	        "align": true,
	        "alignLevel": 0
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
	        "description": "Each logical partition defined over `PARTITION BY` contains few physical data \"parts\" ",
	        "editable": true,
	        "error": false,
	        "fieldConfig": {
	        "defaults": {
	            "links": []
	        },
	        "overrides": []
	        },
	        "fill": 1,
	        "fillGradient": 0,
	        "grid": {},
	        "gridPos": {
	        "h": 7,
	        "w": 8,
	        "x": 16,
	        "y": 39
	        },
	        "hiddenSeries": false,
	        "id": 4,
	        "isNew": true,
	        "legend": {
	        "avg": false,
	        "current": true,
	        "hideEmpty": false,
	        "hideZero": false,
	        "max": false,
	        "min": false,
	        "show": false,
	        "total": false,
	        "values": true
	        },
	        "lines": true,
	        "linewidth": 2,
	        "links": [
	        {
	            "targetBlank": true,
	            "title": "Custom Partitioning Key",
	            "url": "https://clickhouse.tech/docs/en/engines/table-engines/mergetree-family/custom-partitioning-key/"
	        },
	        {
	            "targetBlank": true,
	            "title": "system.parts",
	            "url": "https://clickhouse.tech/docs/en/operations/system-tables/#system_tables-parts"
	        },
	        {
	            "targetBlank": true,
	            "title": "system.part_log",
	            "url": "https://clickhouse.tech/docs/en/operations/system-tables/#system_tables-part-log"
	        }
	        ],
	        "nullPointMode": "null",
	        "options": {
	        "alertThreshold": true
	        },
	        "percentage": false,
	        "pluginVersion": "7.5.15",
	        "pointradius": 5,
	        "points": false,
	        "renderer": "flot",
	        "seriesOverrides": [],
	        "spaceLength": 10,
	        "stack": false,
	        "steppedLine": false,
	        "targets": [
	        {
	            "expr": "chi_clickhouse_metric_MaxPartCountForPartition{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}",
	            "intervalFactor": 2,
	            "legendFormat": "{{hostname}}",
	            "refId": "A",
	            "step": 10
	        }
	        ],
	        "thresholds": [],
	        "timeFrom": null,
	        "timeRegions": [],
	        "timeShift": null,
	        "title": "Max Part count for Partition",
	        "tooltip": {
	        "msResolution": false,
	        "shared": true,
	        "sort": 0,
	        "value_type": "cumulative"
	        },
	        "type": "graph",
	        "xaxis": {
	        "buckets": null,
	        "mode": "time",
	        "name": null,
	        "show": true,
	        "values": []
	        },
	        "yaxes": [
	        {
	            "format": "short",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": "0",
	            "show": true
	        },
	        {
	            "format": "short",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": null,
	            "show": true
	        }
	        ],
	        "yaxis": {
	        "align": false,
	        "alignLevel": null
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
	        "description": "Memory size allocated for clickhouse-server process\nAvailable for ClickHouse 20.4+\n\nVIRT \nThe total amount of virtual memory used by the task. It includes all code, data and shared libraries plus pages that have been swapped out.\n\nVIRT = SWAP + RES\n\n\nSWAP -- Swapped size (kb)\nThe swapped out portion of a task's total virtual memory image.\n\nRES -- Resident size (kb)\nThe non-swapped physical memory a task has used.\nRES = CODE + USED DATA.\n\nCODE -- Code size (kb)\nThe amount of physical memory devoted to executable code, also known as the 'text resident set' size or TRS\n\nDATA -- Data+Stack size (kb)\nThe amount of physical memory allocated to other than executable code, also known as the 'data resident set' size or DRS.\n\nSHR -- Shared Mem size (kb)\nThe amount of shared memory used by a task. It simply reflects memory that could be potentially shared with other processes.",
	        "fieldConfig": {
	        "defaults": {
	            "links": []
	        },
	        "overrides": []
	        },
	        "fill": 1,
	        "fillGradient": 2,
	        "gridPos": {
	        "h": 7,
	        "w": 8,
	        "x": 0,
	        "y": 46
	        },
	        "hiddenSeries": false,
	        "id": 46,
	        "legend": {
	        "avg": false,
	        "current": false,
	        "max": false,
	        "min": false,
	        "show": false,
	        "total": false,
	        "values": false
	        },
	        "lines": true,
	        "linewidth": 1,
	        "links": [
	        {
	            "targetBlank": true,
	            "title": "Describe Linux Process Memory types",
	            "url": "https://elinux.org/Runtime_Memory_Measurement"
	        }
	        ],
	        "nullPointMode": "null",
	        "options": {
	        "alertThreshold": true
	        },
	        "percentage": false,
	        "pluginVersion": "7.5.15",
	        "pointradius": 2,
	        "points": false,
	        "renderer": "flot",
	        "seriesOverrides": [
	        {
	            "alias": "/VIRT.+/",
	            "color": "#73BF69"
	        },
	        {
	            "alias": "/DATA.+/",
	            "color": "#C4162A"
	        },
	        {
	            "alias": "/CODE.+/",
	            "color": "#FF9830"
	        },
	        {
	            "alias": "/RES.+/",
	            "color": "#FADE2A"
	        },
	        {
	            "alias": "/SHR.+/",
	            "color": "#5794F2"
	        }
	        ],
	        "spaceLength": 10,
	        "stack": false,
	        "steppedLine": true,
	        "targets": [
	        {
	            "expr": "chi_clickhouse_metric_MemoryCode{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}",
	            "legendFormat": "CODE {{ hostname }}",
	            "refId": "A"
	        },
	        {
	            "expr": "chi_clickhouse_metric_MemoryResident{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}",
	            "legendFormat": "RES {{ hostname }}",
	            "refId": "B"
	        },
	        {
	            "expr": "chi_clickhouse_metric_MemoryShared{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}",
	            "legendFormat": "SHR {{ hostname }}",
	            "refId": "C"
	        },
	        {
	            "expr": "chi_clickhouse_metric_MemoryDataAndStack{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}",
	            "legendFormat": "DATA {{ hostname }}",
	            "refId": "D"
	        },
	        {
	            "expr": "chi_clickhouse_metric_MemoryVirtual{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}",
	            "legendFormat": "VIRT {{ hostname }}",
	            "refId": "E"
	        }
	        ],
	        "thresholds": [],
	        "timeFrom": null,
	        "timeRegions": [],
	        "timeShift": null,
	        "title": " clickhouse-server Process Memory",
	        "tooltip": {
	        "shared": true,
	        "sort": 0,
	        "value_type": "individual"
	        },
	        "type": "graph",
	        "xaxis": {
	        "buckets": null,
	        "mode": "time",
	        "name": null,
	        "show": true,
	        "values": []
	        },
	        "yaxes": [
	        {
	            "format": "decbytes",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": "0",
	            "show": true
	        },
	        {
	            "format": "short",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": null,
	            "show": true
	        }
	        ],
	        "yaxis": {
	        "align": false,
	        "alignLevel": null
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
	        "description": "Memory size allocated for primary keys",
	        "fieldConfig": {
	        "defaults": {
	            "links": []
	        },
	        "overrides": []
	        },
	        "fill": 1,
	        "fillGradient": 0,
	        "gridPos": {
	        "h": 7,
	        "w": 8,
	        "x": 8,
	        "y": 46
	        },
	        "hiddenSeries": false,
	        "id": 45,
	        "legend": {
	        "avg": false,
	        "current": false,
	        "max": false,
	        "min": false,
	        "show": false,
	        "total": false,
	        "values": false
	        },
	        "lines": true,
	        "linewidth": 1,
	        "links": [
	        {
	            "targetBlank": true,
	            "title": "How to choose right primary key",
	            "url": "https://clickhouse.tech/docs/en/engines/table-engines/mergetree-family/mergetree/#selecting-the-primary-key"
	        }
	        ],
	        "nullPointMode": "null",
	        "options": {
	        "alertThreshold": true
	        },
	        "percentage": false,
	        "pluginVersion": "7.5.15",
	        "pointradius": 2,
	        "points": false,
	        "renderer": "flot",
	        "seriesOverrides": [],
	        "spaceLength": 10,
	        "stack": false,
	        "steppedLine": false,
	        "targets": [
	        {
	            "expr": "chi_clickhouse_metric_MemoryPrimaryKeyBytesAllocated{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}",
	            "legendFormat": "{{ hostname }}",
	            "refId": "A"
	        }
	        ],
	        "thresholds": [],
	        "timeFrom": null,
	        "timeRegions": [],
	        "timeShift": null,
	        "title": "Primary Keys Memory",
	        "tooltip": {
	        "shared": true,
	        "sort": 0,
	        "value_type": "individual"
	        },
	        "type": "graph",
	        "xaxis": {
	        "buckets": null,
	        "mode": "time",
	        "name": null,
	        "show": true,
	        "values": []
	        },
	        "yaxes": [
	        {
	            "format": "bytes",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": "0",
	            "show": true
	        },
	        {
	            "format": "short",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": null,
	            "show": true
	        }
	        ],
	        "yaxis": {
	        "align": false,
	        "alignLevel": null
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
	        "description": "Memory size allocated for dictionaries",
	        "fieldConfig": {
	        "defaults": {
	            "links": []
	        },
	        "overrides": []
	        },
	        "fill": 1,
	        "fillGradient": 0,
	        "gridPos": {
	        "h": 7,
	        "w": 8,
	        "x": 16,
	        "y": 46
	        },
	        "hiddenSeries": false,
	        "id": 43,
	        "legend": {
	        "avg": false,
	        "current": false,
	        "max": false,
	        "min": false,
	        "show": false,
	        "total": false,
	        "values": false
	        },
	        "lines": true,
	        "linewidth": 1,
	        "links": [
	        {
	            "targetBlank": true,
	            "title": "system.dictionaries",
	            "url": "https://clickhouse.tech/docs/en/operations/system-tables/#system_tables-dictionaries"
	        },
	        {
	            "targetBlank": true,
	            "title": "CREATE DICTIONARY",
	            "url": "https://clickhouse.tech/docs/en/sql-reference/statements/create/#create-dictionary-query"
	        }
	        ],
	        "nullPointMode": "null",
	        "options": {
	        "alertThreshold": true
	        },
	        "percentage": false,
	        "pluginVersion": "7.5.15",
	        "pointradius": 2,
	        "points": false,
	        "renderer": "flot",
	        "seriesOverrides": [],
	        "spaceLength": 10,
	        "stack": false,
	        "steppedLine": false,
	        "targets": [
	        {
	            "expr": "chi_clickhouse_metric_MemoryDictionaryBytesAllocated{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}",
	            "legendFormat": "{{ hostname }}",
	            "refId": "A"
	        }
	        ],
	        "thresholds": [],
	        "timeFrom": null,
	        "timeRegions": [],
	        "timeShift": null,
	        "title": "Dictionary Memory",
	        "tooltip": {
	        "shared": true,
	        "sort": 0,
	        "value_type": "individual"
	        },
	        "type": "graph",
	        "xaxis": {
	        "buckets": null,
	        "mode": "time",
	        "name": null,
	        "show": true,
	        "values": []
	        },
	        "yaxes": [
	        {
	            "format": "decbytes",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": "0",
	            "show": true
	        },
	        {
	            "format": "short",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": null,
	            "show": true
	        }
	        ],
	        "yaxis": {
	        "align": false,
	        "alignLevel": null
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
	        "description": "shows how much space available in the kubernetes pod\n\nbe careful with multiple volumes configuration, kubernetes volume claims and S3 as storage backend",
	        "fieldConfig": {
	        "defaults": {
	            "links": []
	        },
	        "overrides": []
	        },
	        "fill": 1,
	        "fillGradient": 0,
	        "gridPos": {
	        "h": 7,
	        "w": 8,
	        "x": 0,
	        "y": 53
	        },
	        "hiddenSeries": false,
	        "id": 39,
	        "legend": {
	        "avg": false,
	        "current": false,
	        "max": false,
	        "min": false,
	        "show": false,
	        "total": false,
	        "values": false
	        },
	        "lines": true,
	        "linewidth": 1,
	        "links": [
	        {
	            "targetBlank": true,
	            "title": "system.disks",
	            "url": "https://clickhouse.tech/docs/en/operations/system-tables/disks/"
	        },
	        {
	            "targetBlank": true,
	            "title": "Multiple Disk Volumes",
	            "url": "https://clickhouse.tech/docs/en/engines/table-engines/mergetree-family/mergetree/#table_engine-mergetree-multiple-volumes"
	        }
	        ],
	        "nullPointMode": "null",
	        "options": {
	        "alertThreshold": true
	        },
	        "percentage": false,
	        "pluginVersion": "7.5.15",
	        "pointradius": 2,
	        "points": false,
	        "renderer": "flot",
	        "seriesOverrides": [],
	        "spaceLength": 10,
	        "stack": false,
	        "steppedLine": false,
	        "targets": [
	        {
	            "expr": "chi_clickhouse_metric_DiskFreeBytes{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"} / chi_clickhouse_metric_DiskTotalBytes{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}",
	            "legendFormat": "{{ disk }} {{hostname}}",
	            "refId": "A"
	        }
	        ],
	        "thresholds": [],
	        "timeFrom": null,
	        "timeRegions": [],
	        "timeShift": null,
	        "title": "Disk Space Free",
	        "tooltip": {
	        "shared": true,
	        "sort": 0,
	        "value_type": "individual"
	        },
	        "type": "graph",
	        "xaxis": {
	        "buckets": null,
	        "mode": "time",
	        "name": null,
	        "show": true,
	        "values": []
	        },
	        "yaxes": [
	        {
	            "decimals": null,
	            "format": "percentunit",
	            "label": null,
	            "logBase": 1,
	            "max": "1",
	            "min": "0",
	            "show": true
	        },
	        {
	            "format": "short",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": null,
	            "show": true
	        }
	        ],
	        "yaxis": {
	        "align": false,
	        "alignLevel": null
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
	        "description": "Total data size for all ClickHouse *MergeTree tables\n\n",
	        "fieldConfig": {
	        "defaults": {
	            "links": []
	        },
	        "overrides": []
	        },
	        "fill": 1,
	        "fillGradient": 0,
	        "gridPos": {
	        "h": 7,
	        "w": 8,
	        "x": 8,
	        "y": 53
	        },
	        "hiddenSeries": false,
	        "id": 41,
	        "legend": {
	        "avg": false,
	        "current": false,
	        "max": false,
	        "min": false,
	        "show": false,
	        "total": false,
	        "values": false
	        },
	        "lines": true,
	        "linewidth": 1,
	        "links": [
	        {
	            "targetBlank": true,
	            "title": "system.parts",
	            "url": "https://clickhouse.tech/docs/en/operations/system-tables/#system_tables-parts"
	        }
	        ],
	        "nullPointMode": "null",
	        "options": {
	        "alertThreshold": true
	        },
	        "percentage": false,
	        "pluginVersion": "7.5.15",
	        "pointradius": 2,
	        "points": false,
	        "renderer": "flot",
	        "seriesOverrides": [],
	        "spaceLength": 10,
	        "stack": false,
	        "steppedLine": false,
	        "targets": [
	        {
	            "expr": "chi_clickhouse_metric_DiskDataBytes{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}",
	            "legendFormat": "{{ hostname }}",
	            "refId": "A"
	        }
	        ],
	        "thresholds": [],
	        "timeFrom": null,
	        "timeRegions": [],
	        "timeShift": null,
	        "title": "Clickhouse Data size on Disk",
	        "tooltip": {
	        "shared": true,
	        "sort": 0,
	        "value_type": "individual"
	        },
	        "type": "graph",
	        "xaxis": {
	        "buckets": null,
	        "mode": "time",
	        "name": null,
	        "show": true,
	        "values": []
	        },
	        "yaxes": [
	        {
	            "format": "decbytes",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": "0",
	            "show": true
	        },
	        {
	            "format": "short",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": null,
	            "show": true
	        }
	        ],
	        "yaxis": {
	        "align": false,
	        "alignLevel": null
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
	        "description": "Show different types of connections for each server",
	        "editable": true,
	        "error": false,
	        "fieldConfig": {
	        "defaults": {
	            "links": []
	        },
	        "overrides": []
	        },
	        "fill": 1,
	        "fillGradient": 0,
	        "grid": {},
	        "gridPos": {
	        "h": 7,
	        "w": 8,
	        "x": 16,
	        "y": 53
	        },
	        "hiddenSeries": false,
	        "id": 48,
	        "isNew": true,
	        "legend": {
	        "avg": false,
	        "current": false,
	        "hideEmpty": false,
	        "hideZero": false,
	        "max": false,
	        "min": false,
	        "show": false,
	        "total": false,
	        "values": false
	        },
	        "lines": true,
	        "linewidth": 2,
	        "links": [
	        {
	            "targetBlank": true,
	            "title": "max_connections",
	            "url": "https://clickhouse.tech/docs/en/operations/server-configuration-parameters/settings/#max-connections"
	        },
	        {
	            "targetBlank": true,
	            "title": "max_distributed_connections",
	            "url": "https://clickhouse.tech/docs/en/operations/settings/settings/#max-distributed-connections"
	        },
	        {
	            "targetBlank": true,
	            "title": "MySQL Protocol",
	            "url": "https://clickhouse.tech/docs/en/interfaces/mysql/"
	        },
	        {
	            "targetBlank": true,
	            "title": "HTTP Protocol",
	            "url": "https://clickhouse.tech/docs/en/interfaces/http/"
	        },
	        {
	            "targetBlank": true,
	            "title": "Native Protocol",
	            "url": "https://clickhouse.tech/docs/en/interfaces/tcp/"
	        }
	        ],
	        "nullPointMode": "null",
	        "options": {
	        "alertThreshold": true
	        },
	        "percentage": false,
	        "pluginVersion": "7.5.15",
	        "pointradius": 5,
	        "points": false,
	        "renderer": "flot",
	        "seriesOverrides": [],
	        "spaceLength": 10,
	        "stack": false,
	        "steppedLine": true,
	        "targets": [
	        {
	            "expr": "chi_clickhouse_metric_TCPConnection{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}",
	            "intervalFactor": 2,
	            "legendFormat": "tcp {{hostname}}",
	            "refId": "A",
	            "step": 10
	        },
	        {
	            "expr": "chi_clickhouse_metric_HTTPConnection{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}",
	            "intervalFactor": 2,
	            "legendFormat": "http {{hostname}}",
	            "refId": "B",
	            "step": 10
	        },
	        {
	            "expr": "chi_clickhouse_metric_InterserverConnection{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}",
	            "intervalFactor": 2,
	            "legendFormat": "interserver {{hostname}}",
	            "refId": "C",
	            "step": 10
	        },
	        {
	            "expr": "chi_clickhouse_metric_MySQLConnection{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}",
	            "intervalFactor": 2,
	            "legendFormat": "mysql {{hostname}}",
	            "refId": "D",
	            "step": 10
	        }
	        ],
	        "thresholds": [],
	        "timeFrom": null,
	        "timeRegions": [],
	        "timeShift": null,
	        "title": "Connections",
	        "tooltip": {
	        "msResolution": false,
	        "shared": true,
	        "sort": 0,
	        "value_type": "cumulative"
	        },
	        "type": "graph",
	        "xaxis": {
	        "buckets": null,
	        "mode": "time",
	        "name": null,
	        "show": true,
	        "values": []
	        },
	        "yaxes": [
	        {
	            "format": "short",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": null,
	            "show": true
	        },
	        {
	            "format": "short",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": null,
	            "show": true
	        }
	        ],
	        "yaxis": {
	        "align": false,
	        "alignLevel": null
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
	        "description": "BackgroundPoolTask\t\n---\nNumber of active tasks in BackgroundProcessingPool (merges, mutations, fetches, or replication queue bookkeeping)\n\n\nBackgroundMovePoolTask\n---\nNumber of active tasks in BackgroundProcessingPool for moves\n\n\nBackgroundSchedulePoolTask\t\n---\nA number of active tasks in BackgroundSchedulePool. This pool is used for periodic ReplicatedMergeTree tasks, like cleaning old data parts, altering data parts, replica re-initialization, etc.",
	        "editable": true,
	        "error": false,
	        "fieldConfig": {
	        "defaults": {
	            "links": []
	        },
	        "overrides": []
	        },
	        "fill": 1,
	        "fillGradient": 0,
	        "grid": {},
	        "gridPos": {
	        "h": 7,
	        "w": 8,
	        "x": 0,
	        "y": 60
	        },
	        "hiddenSeries": false,
	        "id": 9,
	        "isNew": true,
	        "legend": {
	        "avg": false,
	        "current": true,
	        "hideEmpty": false,
	        "hideZero": false,
	        "max": false,
	        "min": false,
	        "show": false,
	        "total": false,
	        "values": true
	        },
	        "lines": true,
	        "linewidth": 2,
	        "links": [
	        {
	            "targetBlank": true,
	            "title": "FETCH PARTITION",
	            "url": "https://clickhouse.tech/docs/en/sql-reference/statements/alter/partition/#alter_fetch-partition"
	        },
	        {
	            "targetBlank": true,
	            "title": "Mutations of data",
	            "url": "https://clickhouse.tech/docs/en/sql-reference/statements/alter/#mutations"
	        },
	        {
	            "targetBlank": true,
	            "title": "Data TTL",
	            "url": "https://clickhouse.tech/docs/en/engines/table-engines/mergetree-family/mergetree/#table_engine-mergetree-ttl"
	        },
	        {
	            "targetBlank": true,
	            "title": "MOVE PARTITION",
	            "url": "https://clickhouse.tech/docs/en/sql-reference/statements/alter/partition/#alter_move-partition"
	        }
	        ],
	        "nullPointMode": "null",
	        "options": {
	        "alertThreshold": true
	        },
	        "percentage": false,
	        "pluginVersion": "7.5.15",
	        "pointradius": 5,
	        "points": false,
	        "renderer": "flot",
	        "seriesOverrides": [],
	        "spaceLength": 10,
	        "stack": false,
	        "steppedLine": true,
	        "targets": [
	        {
	            "expr": "chi_clickhouse_metric_BackgroundPoolTask{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}",
	            "intervalFactor": 2,
	            "legendFormat": "merge, mutate, fetch {{hostname}}",
	            "refId": "A",
	            "step": 10
	        },
	        {
	            "expr": "chi_clickhouse_metric_BackgroundSchedulePoolTask{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}",
	            "intervalFactor": 2,
	            "legendFormat": "clean, alter, replica re-init {{hostname}}",
	            "refId": "B",
	            "step": 10
	        },
	        {
	            "expr": "chi_clickhouse_metric_BackgroundMovePoolTask{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}",
	            "intervalFactor": 2,
	            "legendFormat": "moves {{hostname}}",
	            "refId": "C",
	            "step": 10
	        }
	        ],
	        "thresholds": [],
	        "timeFrom": null,
	        "timeRegions": [],
	        "timeShift": null,
	        "title": "Background Tasks",
	        "tooltip": {
	        "msResolution": false,
	        "shared": true,
	        "sort": 0,
	        "value_type": "cumulative"
	        },
	        "type": "graph",
	        "xaxis": {
	        "buckets": null,
	        "mode": "time",
	        "name": null,
	        "show": true,
	        "values": []
	        },
	        "yaxes": [
	        {
	            "format": "short",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": "0",
	            "show": true
	        },
	        {
	            "format": "short",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": "0",
	            "show": true
	        }
	        ],
	        "yaxis": {
	        "align": false,
	        "alignLevel": null
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
	        "description": "Number of active mutations (ALTER DELETE/ALTER UPDATE) and parts to mutate",
	        "fieldConfig": {
	        "defaults": {
	            "links": []
	        },
	        "overrides": []
	        },
	        "fill": 1,
	        "fillGradient": 0,
	        "gridPos": {
	        "h": 7,
	        "w": 8,
	        "x": 8,
	        "y": 60
	        },
	        "hiddenSeries": false,
	        "id": 26,
	        "legend": {
	        "avg": false,
	        "current": false,
	        "max": false,
	        "min": false,
	        "show": false,
	        "total": false,
	        "values": false
	        },
	        "lines": true,
	        "linewidth": 1,
	        "links": [
	        {
	            "targetBlank": true,
	            "title": "Mutations",
	            "url": "https://clickhouse.tech/docs/en/sql-reference/statements/alter/#mutations"
	        },
	        {
	            "targetBlank": true,
	            "title": "system.mutations",
	            "url": "https://clickhouse.tech/docs/en/operations/system-tables/mutations/"
	        },
	        {
	            "targetBlank": true,
	            "title": "KILL MUTATION",
	            "url": "https://clickhouse.tech/docs/en/sql-reference/statements/kill/#kill-mutation"
	        }
	        ],
	        "nullPointMode": "null as zero",
	        "options": {
	        "alertThreshold": true
	        },
	        "percentage": false,
	        "pluginVersion": "7.5.15",
	        "pointradius": 2,
	        "points": false,
	        "renderer": "flot",
	        "seriesOverrides": [],
	        "spaceLength": 10,
	        "stack": false,
	        "steppedLine": true,
	        "targets": [
	        {
	            "expr": "sum by (hostname) (chi_clickhouse_table_mutations{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"})",
	            "legendFormat": "mutations {{hostname}}",
	            "refId": "A"
	        },
	        {
	            "expr": "sum by (hostname) (chi_clickhouse_table_mutations_parts_to_do{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"})",
	            "legendFormat": "parts_to_do {{hostname}}",
	            "refId": "B"
	        }
	        ],
	        "thresholds": [],
	        "timeFrom": null,
	        "timeRegions": [],
	        "timeShift": null,
	        "title": "Mutations",
	        "tooltip": {
	        "shared": true,
	        "sort": 0,
	        "value_type": "individual"
	        },
	        "type": "graph",
	        "xaxis": {
	        "buckets": null,
	        "mode": "time",
	        "name": null,
	        "show": true,
	        "values": []
	        },
	        "yaxes": [
	        {
	            "format": "short",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": "0",
	            "show": true
	        },
	        {
	            "format": "short",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": null,
	            "show": false
	        }
	        ],
	        "yaxis": {
	        "align": false,
	        "alignLevel": null
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
	        "description": "Show which percent of mark files (.mrk) read from memory instead of disk",
	        "editable": true,
	        "error": false,
	        "fieldConfig": {
	        "defaults": {
	            "links": []
	        },
	        "overrides": []
	        },
	        "fill": 1,
	        "fillGradient": 0,
	        "grid": {},
	        "gridPos": {
	        "h": 7,
	        "w": 8,
	        "x": 16,
	        "y": 60
	        },
	        "hiddenSeries": false,
	        "id": 11,
	        "isNew": true,
	        "legend": {
	        "avg": false,
	        "current": false,
	        "hideEmpty": false,
	        "hideZero": false,
	        "max": false,
	        "min": false,
	        "show": false,
	        "total": false,
	        "values": false
	        },
	        "lines": true,
	        "linewidth": 2,
	        "links": [
	        {
	            "targetBlank": true,
	            "title": "mark_cache_size",
	            "url": "https://clickhouse.tech/docs/en/operations/server-configuration-parameters/settings/#server-mark-cache-size"
	        },
	        {
	            "targetBlank": true,
	            "title": "MergeTree architecture",
	            "url": "https://clickhouse.tech/docs/en/development/architecture/#merge-tree"
	        }
	        ],
	        "nullPointMode": "null",
	        "options": {
	        "alertThreshold": true
	        },
	        "percentage": false,
	        "pluginVersion": "7.5.15",
	        "pointradius": 5,
	        "points": false,
	        "renderer": "flot",
	        "seriesOverrides": [],
	        "spaceLength": 10,
	        "stack": false,
	        "steppedLine": false,
	        "targets": [
	        {
	            "expr": "irate(chi_clickhouse_event_MarkCacheHits{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m]) / (irate(chi_clickhouse_event_MarkCacheHits{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m]) + irate(chi_clickhouse_event_MarkCacheMisses{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m]))",
	            "hide": false,
	            "intervalFactor": 2,
	            "legendFormat": "{{hostname}}",
	            "refId": "A",
	            "step": 4
	        }
	        ],
	        "thresholds": [],
	        "timeFrom": null,
	        "timeRegions": [],
	        "timeShift": null,
	        "title": "Marks Cache Hit Rate",
	        "tooltip": {
	        "msResolution": false,
	        "shared": true,
	        "sort": 0,
	        "value_type": "individual"
	        },
	        "type": "graph",
	        "xaxis": {
	        "buckets": null,
	        "mode": "time",
	        "name": null,
	        "show": true,
	        "values": []
	        },
	        "yaxes": [
	        {
	            "format": "percentunit",
	            "label": "",
	            "logBase": 1,
	            "max": null,
	            "min": "0",
	            "show": true
	        },
	        {
	            "format": "short",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": null,
	            "show": false
	        }
	        ],
	        "yaxis": {
	        "align": false,
	        "alignLevel": null
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
	        "description": "The time which CPU spent on various types of activity ",
	        "fieldConfig": {
	        "defaults": {
	            "links": []
	        },
	        "overrides": []
	        },
	        "fill": 1,
	        "fillGradient": 1,
	        "gridPos": {
	        "h": 7,
	        "w": 8,
	        "x": 0,
	        "y": 67
	        },
	        "hiddenSeries": false,
	        "id": 51,
	        "interval": "",
	        "legend": {
	        "avg": false,
	        "current": false,
	        "max": false,
	        "min": false,
	        "show": false,
	        "total": false,
	        "values": false
	        },
	        "lines": true,
	        "linewidth": 1,
	        "links": [],
	        "nullPointMode": "null",
	        "options": {
	        "alertThreshold": true
	        },
	        "percentage": false,
	        "pluginVersion": "7.5.15",
	        "pointradius": 2,
	        "points": false,
	        "renderer": "flot",
	        "seriesOverrides": [
	        {
	            "alias": "/^Disk Read.+/",
	            "color": "#FF9830"
	        },
	        {
	            "alias": "/^Disk Write.+/",
	            "color": "#E0B400"
	        },
	        {
	            "alias": "/^Real Time.+/",
	            "color": "#73BF69"
	        },
	        {
	            "alias": "/^User Time.+/",
	            "color": "#FFF899"
	        },
	        {
	            "alias": "/^System Time.+/",
	            "color": "#F2495C"
	        },
	        {
	            "alias": "/^OS IO Wait.+/",
	            "color": "#C4162A"
	        },
	        {
	            "alias": "/^OS CPU Wait.+/",
	            "color": "rgb(95, 29, 29)"
	        },
	        {
	            "alias": "/^OS CPU Virtual.+/",
	            "color": "#B877D9"
	        },
	        {
	            "alias": "/^Network Receive.+/",
	            "color": "#C0D8FF"
	        },
	        {
	            "alias": "/^Network Send.+/",
	            "color": "#8AB8FF"
	        }
	        ],
	        "spaceLength": 10,
	        "stack": false,
	        "steppedLine": true,
	        "targets": [
	        {
	            "expr": "irate(chi_clickhouse_event_DiskReadElapsedMicroseconds{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "hide": true,
	            "legendFormat": "Disk Read syscall {{hostname}}",
	            "refId": "A"
	        },
	        {
	            "expr": "irate(chi_clickhouse_event_DiskWriteElapsedMicroseconds{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "hide": true,
	            "legendFormat": "Disk Write syscall {{hostname}}",
	            "refId": "B"
	        },
	        {
	            "expr": "irate(chi_clickhouse_event_NetworkReceiveElapsedMicroseconds{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "hide": true,
	            "legendFormat": "Network Receive {{hostname}}",
	            "refId": "C"
	        },
	        {
	            "expr": "irate(chi_clickhouse_event_NetworkSendElapsedMicroseconds{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "hide": true,
	            "legendFormat": "Network Send {{hostname}}",
	            "refId": "D"
	        },
	        {
	            "expr": "irate(chi_clickhouse_event_RealTimeMicroseconds{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "legendFormat": "Real Time {{hostname}}",
	            "refId": "E"
	        },
	        {
	            "expr": "irate(chi_clickhouse_event_UserTimeMicroseconds{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "legendFormat": "User Time {{hostname}}",
	            "refId": "F"
	        },
	        {
	            "expr": "irate(chi_clickhouse_event_SystemTimeMicroseconds{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "legendFormat": "System Time {{hostname}}",
	            "refId": "G"
	        },
	        {
	            "expr": "irate(chi_clickhouse_event_OSIOWaitMicroseconds{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "legendFormat": "OS IO Wait {{hostname}}",
	            "refId": "H"
	        },
	        {
	            "expr": "irate(chi_clickhouse_event_OSCPUWaitMicroseconds{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "legendFormat": "OS CPU Wait {{hostname}}",
	            "refId": "I"
	        },
	        {
	            "expr": "irate(chi_clickhouse_event_OSCPUVirtualTimeMicroseconds{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "legendFormat": "OS CPU Virtual {{hostname}}",
	            "refId": "J"
	        }
	        ],
	        "thresholds": [],
	        "timeFrom": null,
	        "timeRegions": [],
	        "timeShift": null,
	        "title": "CPU Time per second",
	        "tooltip": {
	        "shared": true,
	        "sort": 0,
	        "value_type": "individual"
	        },
	        "type": "graph",
	        "xaxis": {
	        "buckets": null,
	        "mode": "time",
	        "name": null,
	        "show": true,
	        "values": []
	        },
	        "yaxes": [
	        {
	            "format": "µs",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": "0",
	            "show": true
	        },
	        {
	            "format": "short",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": null,
	            "show": false
	        }
	        ],
	        "yaxis": {
	        "align": false,
	        "alignLevel": null
	        }
	    },
	    {
	        "aliasColors": {},
	        "breakPoint": "50%",
	        "cacheTimeout": null,
	        "combine": {
	        "label": "Others",
	        "threshold": "0.01"
	        },
	        "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	    },
	        "description": "The time which CPU spent on various types of activity total for the selected period",
	        "fieldConfig": {
	        "defaults": {},
	        "overrides": []
	        },
	        "fontSize": "80%",
	        "format": "µs",
	        "gridPos": {
	        "h": 7,
	        "w": 16,
	        "x": 8,
	        "y": 67
	        },
	        "id": 52,
	        "interval": "1m",
	        "legend": {
	        "header": "",
	        "percentage": true,
	        "show": true,
	        "sideWidth": null,
	        "sort": "total",
	        "sortDesc": true,
	        "values": true
	        },
	        "legendType": "Right side",
	        "links": [],
	        "nullPointMode": "connected",
	        "pieType": "pie",
	        "strokeWidth": "",
	        "targets": [
	        {
	            "expr": "increase(chi_clickhouse_event_DiskReadElapsedMicroseconds{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "legendFormat": "Disk Read syscall {{hostname}}",
	            "refId": "A"
	        },
	        {
	            "expr": "increase(chi_clickhouse_event_DiskWriteElapsedMicroseconds{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "legendFormat": "Disk Write syscall {{hostname}}",
	            "refId": "B"
	        },
	        {
	            "expr": "increase(chi_clickhouse_event_NetworkReceiveElapsedMicroseconds{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "legendFormat": "Network Receive {{hostname}}",
	            "refId": "C"
	        },
	        {
	            "expr": "increase(chi_clickhouse_event_NetworkSendElapsedMicroseconds{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "legendFormat": "Network Send {{hostname}}",
	            "refId": "D"
	        },
	        {
	            "expr": "increase(chi_clickhouse_event_RealTimeMicroseconds{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "legendFormat": "Real Time {{hostname}}",
	            "refId": "E"
	        },
	        {
	            "expr": "increase(chi_clickhouse_event_UserTimeMicroseconds{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "legendFormat": "User Time {{hostname}}",
	            "refId": "F"
	        },
	        {
	            "expr": "increase(chi_clickhouse_event_SystemTimeMicroseconds{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "legendFormat": "System Time {{hostname}}",
	            "refId": "G"
	        },
	        {
	            "expr": "increase(chi_clickhouse_event_OSIOWaitMicroseconds{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "legendFormat": "OS IO Wait {{hostname}}",
	            "refId": "H"
	        },
	        {
	            "expr": "increase(chi_clickhouse_event_OSCPUWaitMicroseconds{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "legendFormat": "OS CPU Wait {{hostname}}",
	            "refId": "I"
	        },
	        {
	            "expr": "increase(chi_clickhouse_event_OSCPUVirtualTimeMicroseconds{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "legendFormat": "OS CPU Virtual {{hostname}}",
	            "refId": "J"
	        },
	        {
	            "expr": "increase(chi_clickhouse_event_ThrottlerSleepMicroseconds{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "legendFormat": "Throttler Sleep {{hostname}}",
	            "refId": "K"
	        },
	        {
	            "expr": "increase(chi_clickhouse_event_DelayedInsertsMilliseconds{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m]) * 1000",
	            "legendFormat": "Delayed Insert {{hostname}}",
	            "refId": "L"
	        },
	        {
	            "expr": "increase(chi_clickhouse_event_ZooKeeperWaitMicroseconds{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "legendFormat": "Zookeeper Wait {{hostname}}",
	            "refId": "M"
	        },
	        {
	            "expr": "increase(chi_clickhouse_event_CompileExpressionsMicroseconds{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "legendFormat": "Compile Expressions {{hostname}}",
	            "refId": "N"
	        },
	        {
	            "expr": "increase(chi_clickhouse_event_MergesTimeMilliseconds{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m]) * 1000",
	            "legendFormat": "Merges {{hostname}}",
	            "refId": "O"
	        },
	        {
	            "expr": "increase(chi_clickhouse_event_RWLockReadersWaitMilliseconds{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m]) * 1000",
	            "legendFormat": "RWLock Reader Wait {{hostname}}",
	            "refId": "P"
	        },
	        {
	            "expr": "increase(chi_clickhouse_event_RWLockWritersWaitMilliseconds{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m]) * 1000",
	            "legendFormat": "RWLock Writer Wait {{hostname}}",
	            "refId": "Q"
	        },
	        {
	            "expr": "increase(chi_clickhouse_event_SelectQueryTimeMicroseconds{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "legendFormat": "Select Query {{hostname}}",
	            "refId": "R"
	        },
	        {
	            "expr": "increase(chi_clickhouse_event_InsertQueryTimeMicroseconds{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "legendFormat": "Insert Query {{hostname}}",
	            "refId": "S"
	        },
	        {
	            "expr": "increase(chi_clickhouse_event_S3ReadMicroseconds{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "legendFormat": "S3 Read {{hostname}}",
	            "refId": "T"
	        },
	        {
	            "expr": "increase(chi_clickhouse_event_S3WriteMicroseconds{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "legendFormat": "S3 Write {{hostname}}",
	            "refId": "U"
	        }
	        ],
	        "timeFrom": null,
	        "timeShift": null,
	        "title": "CPU Time total",
	        "type": "grafana-piechart-panel",
	        "valueName": "total"
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
	        "description": "The time which CPU spent on various types of activity ",
	        "fieldConfig": {
	        "defaults": {
	            "links": []
	        },
	        "overrides": []
	        },
	        "fill": 1,
	        "fillGradient": 1,
	        "gridPos": {
	        "h": 7,
	        "w": 8,
	        "x": 0,
	        "y": 74
	        },
	        "hiddenSeries": false,
	        "id": 54,
	        "interval": "",
	        "legend": {
	        "avg": false,
	        "current": false,
	        "max": false,
	        "min": false,
	        "show": false,
	        "total": false,
	        "values": false
	        },
	        "lines": true,
	        "linewidth": 1,
	        "links": [],
	        "nullPointMode": "null",
	        "options": {
	        "alertThreshold": true
	        },
	        "percentage": false,
	        "pluginVersion": "7.5.15",
	        "pointradius": 2,
	        "points": false,
	        "renderer": "flot",
	        "seriesOverrides": [
	        {
	            "alias": "/^Disk Read.+/",
	            "color": "#FF9830"
	        },
	        {
	            "alias": "/^Disk Write.+/",
	            "color": "#E0B400"
	        },
	        {
	            "alias": "/^Real Time.+/",
	            "color": "#73BF69"
	        },
	        {
	            "alias": "/^User Time.+/",
	            "color": "#FFF899"
	        },
	        {
	            "alias": "/^System Time.+/",
	            "color": "#F2495C"
	        },
	        {
	            "alias": "/^OS IO Wait.+/",
	            "color": "#C4162A"
	        },
	        {
	            "alias": "/^OS CPU Wait.+/",
	            "color": "rgb(95, 29, 29)"
	        },
	        {
	            "alias": "/^OS CPU Virtual.+/",
	            "color": "#B877D9"
	        },
	        {
	            "alias": "/^Network Receive.+/",
	            "color": "#C0D8FF"
	        },
	        {
	            "alias": "/^Network Send.+/",
	            "color": "#8AB8FF"
	        }
	        ],
	        "spaceLength": 10,
	        "stack": false,
	        "steppedLine": true,
	        "targets": [
	        {
	            "expr": "irate(chi_clickhouse_event_DiskReadElapsedMicroseconds{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "hide": false,
	            "legendFormat": "Disk Read syscall {{hostname}}",
	            "refId": "A"
	        },
	        {
	            "expr": "irate(chi_clickhouse_event_DiskWriteElapsedMicroseconds{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "hide": false,
	            "legendFormat": "Disk Write syscall {{hostname}}",
	            "refId": "B"
	        },
	        {
	            "expr": "irate(chi_clickhouse_event_NetworkReceiveElapsedMicroseconds{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "hide": false,
	            "legendFormat": "Network Receive {{hostname}}",
	            "refId": "C"
	        },
	        {
	            "expr": "irate(chi_clickhouse_event_NetworkSendElapsedMicroseconds{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}[1m])",
	            "hide": false,
	            "legendFormat": "Network Send {{hostname}}",
	            "refId": "D"
	        }
	        ],
	        "thresholds": [],
	        "timeFrom": null,
	        "timeRegions": [],
	        "timeShift": null,
	        "title": "Network / Disk CPU Time per second",
	        "tooltip": {
	        "shared": true,
	        "sort": 0,
	        "value_type": "individual"
	        },
	        "type": "graph",
	        "xaxis": {
	        "buckets": null,
	        "mode": "time",
	        "name": null,
	        "show": true,
	        "values": []
	        },
	        "yaxes": [
	        {
	            "$$hashKey": "object:193",
	            "format": "µs",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": "0",
	            "show": true
	        },
	        {
	            "$$hashKey": "object:194",
	            "format": "short",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": null,
	            "show": false
	        }
	        ],
	        "yaxis": {
	        "align": false,
	        "alignLevel": null
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
	        "editable": true,
	        "error": false,
	        "fieldConfig": {
	        "defaults": {
	            "links": []
	        },
	        "overrides": []
	        },
	        "fill": 1,
	        "fillGradient": 0,
	        "grid": {},
	        "gridPos": {
	        "h": 7,
	        "w": 8,
	        "x": 8,
	        "y": 74
	        },
	        "hiddenSeries": false,
	        "id": 24,
	        "isNew": true,
	        "legend": {
	        "avg": false,
	        "current": false,
	        "hideEmpty": false,
	        "hideZero": false,
	        "max": false,
	        "min": false,
	        "show": true,
	        "total": false,
	        "values": false
	        },
	        "lines": true,
	        "linewidth": 2,
	        "links": [
	        {
	            "targetBlank": true,
	            "title": "Howto show detail statistic on grafana for golang process",
	            "url": "https://grafana.com/grafana/dashboards/6671"
	        }
	        ],
	        "nullPointMode": "null",
	        "options": {
	        "alertThreshold": true
	        },
	        "percentage": false,
	        "pluginVersion": "7.5.15",
	        "pointradius": 5,
	        "points": false,
	        "renderer": "flot",
	        "seriesOverrides": [],
	        "spaceLength": 10,
	        "stack": false,
	        "steppedLine": false,
	        "targets": [
	        {
	            "expr": "irate(go_memstats_alloc_bytes_total{app=\"clickhouse-operator\",namespace=~\"$exported_namespace|kube-system\"}[1m])",
	            "hide": false,
	            "legendFormat": "{{ namespace }} GO malloc bytes / sec",
	            "refId": "A"
	        },
	        {
	            "expr": "process_resident_memory_bytes{app=\"clickhouse-operator\",namespace=~\"$exported_namespace|kube-system\"}",
	            "legendFormat": "{{ namespace }} RSS Memory",
	            "refId": "B"
	        }
	        ],
	        "thresholds": [],
	        "timeFrom": null,
	        "timeRegions": [],
	        "timeShift": null,
	        "title": "Monitoring Agent",
	        "tooltip": {
	        "msResolution": false,
	        "shared": true,
	        "sort": 0,
	        "value_type": "cumulative"
	        },
	        "type": "graph",
	        "xaxis": {
	        "buckets": null,
	        "mode": "time",
	        "name": null,
	        "show": true,
	        "values": []
	        },
	        "yaxes": [
	        {
	            "format": "bytes",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": "0",
	            "show": true
	        },
	        {
	            "format": "short",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": null,
	            "show": true
	        }
	        ],
	        "yaxis": {
	        "align": false,
	        "alignLevel": null
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
	        "fillGradient": 1,
	        "gridPos": {
	        "h": 7,
	        "w": 8,
	        "x": 16,
	        "y": 74
	        },
	        "hiddenSeries": false,
	        "id": 55,
	        "interval": "",
	        "legend": {
	        "avg": false,
	        "current": false,
	        "max": false,
	        "min": false,
	        "show": false,
	        "total": false,
	        "values": false
	        },
	        "lines": true,
	        "linewidth": 1,
	        "links": [],
	        "nullPointMode": "null",
	        "options": {
	        "alertThreshold": true
	        },
	        "percentage": false,
	        "pluginVersion": "7.5.15",
	        "pointradius": 2,
	        "points": false,
	        "renderer": "flot",
	        "seriesOverrides": [],
	        "spaceLength": 10,
	        "stack": false,
	        "steppedLine": true,
	        "targets": [
	        {
	            "exemplar": true,
	            "expr": "chi_clickhouse_metric_LoadAverage1{exported_namespace=~\"$exported_namespace\",chi=~\"$chi\",hostname=~\"$hostname\"}",
	            "hide": false,
	            "interval": "",
	            "legendFormat": "{{hostname}}",
	            "refId": "A"
	        }
	        ],
	        "thresholds": [],
	        "timeFrom": null,
	        "timeRegions": [],
	        "timeShift": null,
	        "title": "Load Average 1m",
	        "tooltip": {
	        "shared": true,
	        "sort": 0,
	        "value_type": "individual"
	        },
	        "type": "graph",
	        "xaxis": {
	        "buckets": null,
	        "mode": "time",
	        "name": null,
	        "show": true,
	        "values": []
	        },
	        "yaxes": [
	        {
	            "$$hashKey": "object:193",
	            "format": "none",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": "0",
	            "show": true
	        },
	        {
	            "$$hashKey": "object:194",
	            "format": "short",
	            "label": null,
	            "logBase": 1,
	            "max": null,
	            "min": null,
	            "show": false
	        }
	        ],
	        "yaxis": {
	        "align": false,
	        "alignLevel": null
	        }
	    }
	    ],
	    "refresh": "1m",
	    "schemaVersion": 27,
	    "style": "dark",
	    "tags": [
	    "Altinity",
	    "clickhouse",
	    "operator"
	    ],
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
	        "allValue": ".*",
	        "current": {},
	        "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	    },
	        "definition": "label_values({__name__ =~ \"chi_clickhouse_metric_Uptime|chi_clickhouse_metric_fetch_errors\"}, exported_namespace)",
	        "description": null,
	        "error": null,
	        "hide": 0,
	        "includeAll": true,
	        "label": "K8S Namespace",
	        "multi": true,
	        "name": "exported_namespace",
	        "options": [],
	        "query": {
	            "query": "label_values({__name__ =~ \"chi_clickhouse_metric_Uptime|chi_clickhouse_metric_fetch_errors\"}, exported_namespace)",
	            "refId": "clickhouse-operator-prometheus-exported_namespace-Variable-Query"
	        },
	        "refresh": 2,
	        "regex": "",
	        "skipUrlSync": false,
	        "sort": 1,
	        "tagValuesQuery": "",
	        "tags": [],
	        "tagsQuery": "",
	        "type": "query",
	        "useTags": false
	        },
	        {
	        "allValue": ".*",
	        "current": {},
	        "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	    },
	        "definition": "label_values({__name__ =~ \"chi_clickhouse_metric_Uptime|chi_clickhouse_metric_fetch_errors\", exported_namespace=~\"$exported_namespace\"}, chi)",
	        "description": null,
	        "error": null,
	        "hide": 0,
	        "includeAll": true,
	        "label": "K8S Clickhouse Installation",
	        "multi": true,
	        "name": "chi",
	        "options": [],
	        "query": {
	            "query": "label_values({__name__ =~ \"chi_clickhouse_metric_Uptime|chi_clickhouse_metric_fetch_errors\", exported_namespace=~\"$exported_namespace\"}, chi)",
	            "refId": "clickhouse-operator-prometheus-chi-Variable-Query"
	        },
	        "refresh": 2,
	        "regex": "",
	        "skipUrlSync": false,
	        "sort": 1,
	        "tagValuesQuery": "",
	        "tags": [],
	        "tagsQuery": "",
	        "type": "query",
	        "useTags": false
	        },
	        {
	        "allValue": ".*",
	        "current": {},
	        "datasource": {
	        "type": "prometheus",
	        "uid": "${datasource}"
	    },
	        "definition": "label_values({__name__ =~ \"chi_clickhouse_metric_Uptime|chi_clickhouse_metric_fetch_errors\",exported_namespace=~\"$exported_namespace\",chi=~\"$chi\"}, hostname)",
	        "description": null,
	        "error": null,
	        "hide": 0,
	        "includeAll": true,
	        "label": "Server",
	        "multi": true,
	        "name": "hostname",
	        "options": [],
	        "query": {
	            "query": "label_values({__name__ =~ \"chi_clickhouse_metric_Uptime|chi_clickhouse_metric_fetch_errors\",exported_namespace=~\"$exported_namespace\",chi=~\"$chi\"}, hostname)",
	            "refId": "clickhouse-operator-prometheus-hostname-Variable-Query"
	        },
	        "refresh": 2,
	        "regex": "",
	        "skipUrlSync": false,
	        "sort": 1,
	        "tagValuesQuery": "",
	        "tags": [],
	        "tagsQuery": "",
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
	    "title": "Altinity ClickHouse Operator Dashboard",
	    "uid": "clickhouse-operator",
	    "version": 20220908
	}
	"""#
