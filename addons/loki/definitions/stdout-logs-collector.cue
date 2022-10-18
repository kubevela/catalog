// We put Definitions in definitions directory.
// References:
// - https://kubevela.net/docs/platform-engineers/cue/definition-edit
// - https://kubevela.net/docs/platform-engineers/addon/intro#definitions-directoryoptional

"stdout-logs-collector": {
	alias: "lt"
	annotations: {}
	attributes: {
		appliesToWorkloads: [
			"deployments.apps",
			"replicasets.apps",
			"statefulsets.apps",
		]
		conflictsWith: []
		podDisruptive:   false
		workloadRefPath: ""
	}
	description: "ETL transformer for application log"
	labels: {}
	type: "trait"
}
template: {

	parameter: {
		grafana:      *"default" | string
		parser?:      "nginx" | "apache"
		lokiEndpoint: *"http://loki:3100/" | string
	}

	sourceName: context.appName + "_" + context.name + "_source"
	parserName: context.appName + "_" + context.name + "_parser"
	sinkName:   context.appName + "_" + context.name + "_sink"

	outputs: vector_config: {
		apiVersion: "vector.oam.dev/v1alpha1"
		kind:       "Config"
		metadata: {
			name: context.name
		}
		spec: {
			role: "daemon"
			targetConfigMap: {
				namespace: "o11y-system"
				name:      "vector"
			}
			vectorConfig: {
				sources: "\(sourceName)": {
					type:                 "kubernetes_logs"
					extra_label_selector: "app.oam.dev/name=" + context.appName + ",app.oam.dev/component=" + context.name
				}
				transforms: {
					"\(parserName)": {
						inputs: [sourceName]
						type: "remap"
						if parameter.parser != _|_ && parameter.parser == "apache" {
							source: """
              .message = parse_apache_log!(.message, format: "common")
              """
						}
						if parameter.parser != _|_ && parameter.parser == "nginx" {
							source: """
              .message = parse_nginx_log!(.message, "combined")
              """
						}
					}
				}
				sinks:
					"\(sinkName)": {
						type: "loki"
						inputs: [parserName]
						endpoint:    parameter.lokiEndpoint
						compression: "none"
						request:
							concurrency: 10
						labels: {
							agent:     "vector"
							stream:    "{{ stream }}"
							forward:   "daemon"
							filename:  "{{ file }}"
							namespace: "{{ kubernetes.pod_namespace }}"
							pod:       "{{ kubernetes.pod_name }}"
							if parameter.parser != _|_ && parameter.parser == "nginx" {
								parser: "nginx"
							}
							if parameter.parser != _|_ && parameter.parser == "apache" {
								parser: "apache"
							}
							app:          context.appName
							appNamespace: context.namespace
						}
						encoding: codec: "json"
					}
			}
		}
	}

	outputs: nginx_dashboard: {
		apiVersion: "o11y.prism.oam.dev/v1alpha1"
		kind:       "GrafanaDashboard"
		metadata: {
			annotations: {
				"app.oam.dev/last-applied-configuration": "-"
			}
			name: "\(context.name)@\(parameter.grafana)"
		}
		spec: nginx_dashboard_config
	}

	nginx_dashboard_config: {
		annotations: list: [{
			builtIn: 1
			datasource: {
				type: "datasource"
				uid:  "grafana"
			}
			enable:    true
			hide:      true
			iconColor: "rgba(0, 211, 255, 1)"
			name:      "Annotations & Alerts"
			target: {
				limit:    100
				matchAny: false
				tags: []
				type: "dashboard"
			}
			type: "dashboard"
		}]
		description:          "KubeVela nginx application log analysitc dashboard"
		editable:             true
		fiscalYearStartMonth: 0
		gnetId:               13865
		graphTooltip:         0
		id:                   18
		iteration:            1665717640752
		links: []
		liveNow: false
		panels: [{
			collapsed: false
			datasource: {
				type: "loki"
				uid:  "${logsource}"
			}
			gridPos: {
				h: 1
				w: 24
				x: 0
				y: 0
			}
			id: 24
			panels: []
			targets: [{
				datasource: {
					type: "loki"
					uid:  "loki:local"
				}
				refId: "A"
			}]
			title: "KPI's"
			type:  "row"
		}, {
			datasource: {
				type: "loki"
				uid:  "${logsource}"
			}
			description: ""
			fieldConfig: {
				defaults: {
					color: mode: "thresholds"
					decimals: 0
					mappings: []
					thresholds: {
						mode: "absolute"
						steps: [{
							color: "purple"
							value: null
						}]
					}
				}
				overrides: []
			}
			gridPos: {
				h: 4
				w: 6
				x: 0
				y: 1
			}
			id:       22
			interval: "1h"
			options: {
				colorMode:   "background"
				graphMode:   "none"
				justifyMode: "auto"
				orientation: "auto"
				reduceOptions: {
					calcs: [
						"mean",
					]
					fields: ""
					values: false
				}
				text: {}
				textMode: "value"
			}
			pluginVersion: "8.5.3"
			targets: [{
				datasource: {
					type: "loki"
					uid:  "loki:local"
				}
				editorMode:   "code"
				expr:         "count(sum by (message_client) (count_over_time({app=\"$appName\", appNamespace=\"$appNamespace\"} | json |  __error__=\"\" [$__interval])))"
				legendFormat: "{{message_client}}"
				queryType:    "range"
				refId:        "A"
			}]
			timeFrom: "1h"
			title:    "Unique user visits "
			transformations: []
			type: "stat"
		}, {
			datasource: {
				type: "loki"
				uid:  "${logsource}"
			}
			description: ""
			fieldConfig: {
				defaults: {
					color: mode: "thresholds"
					mappings: []
					thresholds: {
						mode: "absolute"
						steps: [{
							color: "light-blue"
							value: null
						}]
					}
					unit: "short"
				}
				overrides: []
			}
			gridPos: {
				h: 12
				w: 7
				x: 6
				y: 1
			}
			id:       5
			interval: "30s"
			options: {
				colorMode:   "background"
				graphMode:   "area"
				justifyMode: "auto"
				orientation: "auto"
				reduceOptions: {
					calcs: [
						"sum",
					]
					fields: ""
					values: false
				}
				text: {}
				textMode: "auto"
			}
			pluginVersion: "8.5.3"
			targets: [{
				datasource: {
					type: "loki"
					uid:  "loki:local"
				}
				editorMode:   "code"
				expr:         "sum by (message_status) (count_over_time({app=\"$appName\", appNamespace=\"$appNamespace\"}| json |  message_status != \"\"  __error__=\"\" [$__interval]))"
				legendFormat: "{{message_status}}"
				queryType:    "range"
				refId:        "A"
			}]
			title: "Requests per status code"
			transformations: []
			type: "stat"
		}, {
			datasource: {
				type: "loki"
				uid:  "${logsource}"
			}
			description: ""
			fieldConfig: {
				defaults: {
					mappings: []
					thresholds: {
						mode: "absolute"
						steps: [{
							color: "green"
							value: null
						}, {
							color: "red"
							value: 80
						}]
					}
					unit: "short"
				}
				overrides: []
			}
			gridPos: {
				h: 4
				w: 9
				x: 13
				y: 1
			}
			id:       4
			interval: "30s"
			options: {
				colorMode:   "background"
				graphMode:   "none"
				justifyMode: "auto"
				orientation: "auto"
				reduceOptions: {
					calcs: [
						"lastNotNull",
					]
					fields: ""
					values: false
				}
				textMode: "auto"
			}
			pluginVersion: "8.5.3"
			targets: [{
				datasource: {
					type: "loki"
					uid:  "loki:local"
				}
				editorMode:   "code"
				expr:         "sum by(message_path) (count_over_time({app=\"$appName\", appNamespace=\"$appNamespace\"}|json | message_path != \"\" [$__interval]))  "
				legendFormat: "{{message_path}}"
				queryType:    "range"
				refId:        "A"
			}]
			timeFrom: "24h"
			title:    "Total requests  "
			transformations: []
			type: "stat"
		}, {
			datasource: {
				type: "loki"
				uid:  "${logsource}"
			}
			description: ""
			fieldConfig: {
				defaults: {
					color: mode: "thresholds"
					decimals: 0
					mappings: []
					thresholds: {
						mode: "absolute"
						steps: [{
							color: "purple"
							value: null
						}]
					}
				}
				overrides: []
			}
			gridPos: {
				h: 4
				w: 6
				x: 0
				y: 5
			}
			id:       31
			interval: "24h"
			options: {
				colorMode:   "background"
				graphMode:   "none"
				justifyMode: "auto"
				orientation: "auto"
				reduceOptions: {
					calcs: [
						"mean",
					]
					fields: ""
					values: false
				}
				text: {}
				textMode: "value"
			}
			pluginVersion: "8.5.3"
			targets: [{
				datasource: {
					type: "loki"
					uid:  "loki:local"
				}
				editorMode:   "code"
				expr:         "count(sum by (message_client) (count_over_time({app=\"$appName\", appNamespace=\"$appNamespace\"}| json |  __error__=\"\" [$__interval])))"
				legendFormat: ""
				queryType:    "range"
				refId:        "A"
			}]
			timeFrom: "24h"
			title:    "Unique user visits "
			transformations: []
			type: "stat"
		}, {
			datasource: {
				type: "loki"
				uid:  "${logsource}"
			}
			description: ""
			fieldConfig: {
				defaults: {
					color: mode: "thresholds"
					mappings: []
					max: 100
					min: 0
					thresholds: {
						mode: "absolute"
						steps: [{
							color: "purple"
							value: null
						}, {
							color: "red"
							value: 80
						}]
					}
					unit: "percent"
				}
				overrides: []
			}
			gridPos: {
				h: 4
				w: 5
				x: 13
				y: 5
			}
			id: 19
			links: []
			maxDataPoints: 1
			options: {
				colorMode:   "background"
				graphMode:   "none"
				justifyMode: "center"
				orientation: "auto"
				reduceOptions: {
					calcs: [
						"mean",
					]
					fields: ""
					values: false
				}
				text: {}
				textMode: "value"
			}
			pluginVersion: "8.5.3"
			targets: [{
				datasource: {
					type: "loki"
					uid:  "loki:local"
				}
				editorMode:   "code"
				expr:         " sum(rate({app=\"$appName\", appNamespace=\"$appNamespace\"} | json | message_status >= 500 |__error__=\"\"[$__interval])) / (sum(rate({pod=\"$pod\"} | json | __error__=\"\" [$__interval])) / 100)"
				legendFormat: ""
				queryType:    "range"
				refId:        "A"
			}]
			title: "% of 5xx requests "
			type:  "stat"
		}, {
			datasource: {
				type: "loki"
				uid:  "${logsource}"
			}
			description: ""
			fieldConfig: {
				defaults: {
					color: mode: "thresholds"
					mappings: []
					max: 100
					min: 0
					thresholds: {
						mode: "absolute"
						steps: [{
							color: "purple"
							value: null
						}]
					}
					unit: "percent"
				}
				overrides: []
			}
			gridPos: {
				h: 4
				w: 4
				x: 18
				y: 5
			}
			id:       18
			interval: "10m"
			links: []
			maxDataPoints: 1
			options: {
				colorMode:   "background"
				graphMode:   "none"
				justifyMode: "auto"
				orientation: "auto"
				reduceOptions: {
					calcs: [
						"last",
					]
					fields: ""
					values: false
				}
				text: {}
				textMode: "value"
			}
			pluginVersion: "8.5.3"
			targets: [{
				datasource: {
					type: "loki"
					uid:  "loki:local"
				}
				editorMode:   "code"
				expr:         " sum(rate(({app=\"$appName\", appNamespace=\"$appNamespace\"} != \"Googlebot\")[$__interval])) / (sum(rate(({app=\"$appName\", appNamespace=\"$appNamespace\"} != \"Googlebot\")[$__interval])) / 100)"
				legendFormat: ""
				queryType:    "range"
				refId:        "A"
			}]
			title: "% of requests by not Googlebot"
			type:  "stat"
		}, {
			datasource: {
				type: "loki"
				uid:  "${logsource}"
			}
			description: ""
			fieldConfig: {
				defaults: {
					color: mode: "thresholds"
					decimals: 0
					mappings: []
					thresholds: {
						mode: "absolute"
						steps: [{
							color: "purple"
							value: null
						}]
					}
				}
				overrides: []
			}
			gridPos: {
				h: 4
				w: 6
				x: 0
				y: 9
			}
			id:       32
			interval: "48h"
			options: {
				colorMode:   "background"
				graphMode:   "none"
				justifyMode: "auto"
				orientation: "auto"
				reduceOptions: {
					calcs: [
						"mean",
					]
					fields: ""
					values: false
				}
				text: {}
				textMode: "value"
			}
			pluginVersion: "8.5.3"
			targets: [{
				datasource: {
					type: "loki"
					uid:  "loki:local"
				}
				editorMode:   "code"
				expr:         "count(sum by (message_client) (count_over_time({app=\"$appName\", appNamespace=\"$appNamespace\"} | json |  __error__=\"\" [$__interval])))"
				legendFormat: ""
				queryType:    "range"
				refId:        "A"
			}]
			timeFrom: "48h"
			title:    "Unique user visits "
			transformations: []
			type: "stat"
		}, {
			datasource: {
				type: "loki"
				uid:  "${logsource}"
			}
			description: ""
			fieldConfig: {
				defaults: {
					color: mode: "thresholds"
					mappings: []
					thresholds: {
						mode: "absolute"
						steps: [{
							color: "purple"
							value: null
						}]
					}
					unit: "decbytes"
				}
				overrides: []
			}
			gridPos: {
				h: 4
				w: 9
				x: 13
				y: 9
			}
			id:       8
			interval: "10m"
			options: {
				colorMode:   "background"
				graphMode:   "none"
				justifyMode: "center"
				orientation: "auto"
				reduceOptions: {
					calcs: [
						"sum",
					]
					fields: ""
					values: false
				}
				text: {}
				textMode: "value"
			}
			pluginVersion: "8.5.3"
			targets: [{
				datasource: {
					type: "loki"
					uid:  "loki:local"
				}
				editorMode:   "code"
				expr:         "sum_over_time({app=\"$appName\", appNamespace=\"$appNamespace\"} | json | message_status=200 | unwrap message_size |  __error__=\"\" [$__interval])"
				legendFormat: "Bytes sent"
				queryType:    "range"
				refId:        "A"
			}]
			title: "Total Bytes Sent"
			transformations: [{
				id: "reduce"
				options: reducers: [
					"sum",
				]
			}, {
				id: "organize"
				options: {
					excludeByName: {}
					indexByName: {}
					renameByName: Total: "Bytes Sent"
				}
			}]
			type: "stat"
		}, {
			collapsed: false
			datasource: {
				type: "loki"
				uid:  "${logsource}"
			}
			gridPos: {
				h: 1
				w: 24
				x: 0
				y: 13
			}
			id: 26
			panels: []
			targets: [{
				datasource: {
					type: "loki"
					uid:  "loki:local"
				}
				refId: "A"
			}]
			title: "Request statistics over time"
			type:  "row"
		}, {
			datasource: {
				type: "loki"
				uid:  "${logsource}"
			}
			description: ""
			gridPos: {
				h: 16
				w: 11
				x: 0
				y: 14
			}
			id: 11
			options: {
				dedupStrategy:      "none"
				enableLogDetails:   true
				prettifyLogMessage: false
				showCommonLabels:   false
				showLabels:         false
				showTime:           false
				sortOrder:          "Descending"
				wrapLogMessage:     false
			}
			targets: [{
				datasource: {
					type: "loki"
					uid:  "loki:local"
				}
				editorMode:   "code"
				expr:         "{app=\"$appName\", appNamespace=\"$appNamespace\"}| json | message_status != \"\" "
				legendFormat: ""
				queryType:    "range"
				refId:        "A"
			}]
			title: "Recent requests"
			type:  "logs"
		}, {
			datasource: {
				type: "loki"
				uid:  "${logsource}"
			}
			fieldConfig: {
				defaults: {
					color: mode: "palette-classic"
					custom: hideFrom: {
						legend:  false
						tooltip: false
						viz:     false
					}
					mappings: []
				}
				overrides: []
			}
			gridPos: {
				h: 16
				w: 11
				x: 11
				y: 14
			}
			id: 34
			options: {
				legend: {
					displayMode: "list"
					placement:   "bottom"
					showLegend:  true
				}
				pieType: "pie"
				reduceOptions: {
					calcs: [
						"lastNotNull",
					]
					fields: ""
					values: false
				}
				tooltip: {
					mode: "single"
					sort: "none"
				}
			}
			targets: [{
				datasource: {
					type: "loki"
					uid:  "loki:local"
				}
				editorMode:   "code"
				expr:         "sum by (message_path) (count_over_time({app=\"$appName\", appNamespace=\"$appNamespace\"} | json | message_path != \"\" [$__interval]))"
				legendFormat: "{{message_path}}"
				queryType:    "range"
				refId:        "A"
			}]
			title: "Panel Title"
			type:  "piechart"
		}, {
			datasource: {
				type: "loki"
				uid:  "${logsource}"
			}
			description: ""
			fieldConfig: {
				defaults: {
					color: mode: "palette-classic"
					custom: {
						axisLabel:     ""
						axisPlacement: "auto"
						barAlignment:  0
						drawStyle:     "line"
						fillOpacity:   100
						gradientMode:  "opacity"
						hideFrom: {
							legend:  false
							tooltip: false
							viz:     false
						}
						lineInterpolation: "linear"
						lineWidth:         1
						pointSize:         5
						scaleDistribution: type: "linear"
						showPoints: "never"
						spanNulls:  true
						stacking: {
							group: "A"
							mode:  "normal"
						}
						thresholdsStyle: mode: "off"
					}
					decimals: 0
					mappings: []
					thresholds: {
						mode: "absolute"
						steps: [
							{
								color: "green"
							}, {
								color: "red"
								value: 80
							}]
					}
					unit: "short"
				}
				overrides: [{
					matcher: {
						id:      "byName"
						options: "200"
					}
					properties: [{
						id: "color"
						value: {
							fixedColor: "green"
							mode:       "fixed"
						}
					}]
				}, {
					matcher: {
						id:      "byName"
						options: "404"
					}
					properties: [{
						id: "color"
						value: {
							fixedColor: "semi-dark-purple"
							mode:       "palette-classic"
						}
					}]
				}, {
					matcher: {
						id:      "byName"
						options: "500"
					}
					properties: [{
						id: "color"
						value: {
							fixedColor: "dark-red"
							mode:       "fixed"
						}
					}]
				}]
			}
			gridPos: {
				h: 9
				w: 11
				x: 0
				y: 30
			}
			id:       2
			interval: "30s"
			options: {
				legend: {
					calcs: []
					displayMode: "list"
					placement:   "bottom"
					showLegend:  true
				}
				tooltip: {
					mode: "multi"
					sort: "none"
				}
			}
			pluginVersion: "9.1.6"
			targets: [{
				datasource: {
					type: "loki"
					uid:  "loki:local"
				}
				editorMode:   "code"
				expr:         "sum by(message_status) (count_over_time({app=\"$appName\", appNamespace=\"$appNamespace\"} | json | message_status != \"\" [$__interval]))"
				legendFormat: "{{message_status}}"
				queryType:    "range"
				refId:        "A"
				resolution:   1
			}]
			title: "HTTP status statistic"
			transformations: []
			type: "timeseries"
		}, {
			datasource: {
				type: "loki"
				uid:  "${logsource}"
			}
			description: ""
			fieldConfig: {
				defaults: {
					color: mode: "palette-classic"
					custom: {
						axisLabel:     ""
						axisPlacement: "auto"
						barAlignment:  0
						drawStyle:     "line"
						fillOpacity:   100
						gradientMode:  "opacity"
						hideFrom: {
							legend:  false
							tooltip: false
							viz:     false
						}
						lineInterpolation: "linear"
						lineWidth:         1
						pointSize:         5
						scaleDistribution: type: "linear"
						showPoints: "never"
						spanNulls:  false
						stacking: {
							group: "A"
							mode:  "none"
						}
						thresholdsStyle: mode: "off"
					}
					mappings: []
					thresholds: {
						mode: "absolute"
						steps: [
							{
								color: "green"
							}, {
								color: "red"
								value: 80
							}]
					}
					unit: "decbytes"
				}
				overrides: [{
					matcher: {
						id:      "byName"
						options: "Bytes sent"
					}
					properties: [{
						id: "color"
						value: {
							fixedColor: "light-blue"
							mode:       "fixed"
						}
					}]
				}, {
					matcher: {
						id:      "byName"
						options: "appfelstrudel"
					}
					properties: [{
						id: "color"
						value: {
							fixedColor: "yellow"
							mode:       "fixed"
						}
					}]
				}]
			}
			gridPos: {
				h: 9
				w: 11
				x: 11
				y: 30
			}
			id:       9
			interval: "30s"
			options: {
				legend: {
					calcs: []
					displayMode: "list"
					placement:   "bottom"
					showLegend:  true
				}
				tooltip: {
					mode: "multi"
					sort: "none"
				}
			}
			pluginVersion: "9.1.6"
			targets: [{
				datasource: {
					type: "loki"
					uid:  "loki:local"
				}
				editorMode:   "code"
				expr:         "sum by (message_host) (sum_over_time({app=\"$appName\", appNamespace=\"$appNamespace\"} | json | message_status=200 | unwrap message_size |  __error__=\"\" [$__interval]))"
				legendFormat: "Bytes sent"
				queryType:    "range"
				refId:        "A"
			}]
			title: "Bytes Sent"
			transformations: []
			type: "timeseries"
		}, {
			collapsed: false
			datasource: {
				type: "loki"
				uid:  "${logsource}"
			}
			gridPos: {
				h: 1
				w: 24
				x: 0
				y: 39
			}
			id: 28
			panels: []
			targets: [{
				datasource: {
					type: "loki"
					uid:  "loki:local"
				}
				refId: "A"
			}]
			title: "Acquisition and Behaviour"
			type:  "row"
		}, {
			datasource: {
				type: "loki"
				uid:  "${logsource}"
			}
			description: ""
			fieldConfig: {
				defaults: {
					color: mode: "thresholds"
					custom: {
						align:       "auto"
						displayMode: "auto"
						filterable:  false
						inspect:     false
					}
					mappings: []
					thresholds: {
						mode: "absolute"
						steps: [
							{
								color: "green"
							}, {
								color: "red"
								value: 80
							}]
					}
				}
				overrides: [{
					matcher: {
						id:      "byName"
						options: "Requests"
					}
					properties: [{
						id:    "custom.width"
						value: 300
					}, {
						id:    "custom.displayMode"
						value: "gradient-gauge"
					}, {
						id: "color"
						value: mode: "continuous-BlPu"
					}]
				}]
			}
			gridPos: {
				h: 7
				w: 11
				x: 0
				y: 40
			}
			id:       7
			interval: ""
			options: {
				footer: {
					fields: ""
					reducer: [
						"sum",
					]
					show: false
				}
				showHeader: true
				sortBy: [{
					desc:        true
					displayName: "Requests"
				}]
			}
			pluginVersion: "8.5.3"
			targets: [{
				datasource: {
					type: "loki"
					uid:  "loki:local"
				}
				editorMode:   "code"
				expr:         "topk(10, sum by (message_agent) (count_over_time({app=\"$appName\", appNamespace=\"$appNamespace\"}| json | message_agent != \"\"  __error__=\"\" [$__interval])))"
				legendFormat: "{{message_agent}}"
				queryType:    "range"
				refId:        "A"
			}]
			title: "Top User Agents"
			transformations: [{
				id: "reduce"
				options: reducers: [
					"sum",
				]
			}, {
				id: "organize"
				options: {
					excludeByName: Field: false
					indexByName: {}
					renameByName: {
						Field: "Agent"
						Total: "Requests"
					}
				}
			}]
			type: "table"
		}, {
			datasource: {
				type: "loki"
				uid:  "${logsource}"
			}
			description: ""
			fieldConfig: {
				defaults: {
					color: mode: "thresholds"
					custom: {
						align:       "auto"
						displayMode: "auto"
						filterable:  false
						inspect:     false
					}
					mappings: []
					thresholds: {
						mode: "absolute"
						steps: [
							{
								color: "green"
							}, {
								color: "red"
								value: 80
							}]
					}
				}
				overrides: [{
					matcher: {
						id:      "byName"
						options: "Requests"
					}
					properties: [{
						id:    "custom.width"
						value: 300
					}, {
						id:    "custom.displayMode"
						value: "gradient-gauge"
					}, {
						id: "color"
						value: mode: "continuous-BlPu"
					}]
				}]
			}
			gridPos: {
				h: 7
				w: 11
				x: 11
				y: 40
			}
			id:       6
			interval: "1h"
			options: {
				footer: {
					fields: ""
					reducer: [
						"sum",
					]
					show: false
				}
				showHeader: true
				sortBy: [{
					desc:        true
					displayName: "Requests"
				}]
			}
			pluginVersion: "8.5.3"
			targets: [{
				datasource: {
					type: "loki"
					uid:  "loki:local"
				}
				editorMode:   "code"
				expr:         "topk(20, sum by (message_referer) (count_over_time({app=\"$appName\", appNamespace=\"$appNamespace\"} | json |  message_referer != \"\" and message_referer !~ \".*?$host.*?\" | __error__=\"\" [$__interval])))"
				legendFormat: "{{http_referer}}"
				queryType:    "range"
				refId:        "A"
			}]
			title: "Top HTTP Referers"
			transformations: [{
				id: "reduce"
				options: reducers: [
					"sum",
				]
			}, {
				id: "organize"
				options: {
					excludeByName: {}
					indexByName: {}
					renameByName: {
						Field: "Referer"
						Total: "Requests"
					}
				}
			}]
			type: "table"
		}, {
			datasource: {
				type: "loki"
				uid:  "${logsource}"
			}
			description: ""
			fieldConfig: {
				defaults: {
					color: mode: "thresholds"
					custom: {
						align:       "auto"
						displayMode: "auto"
						filterable:  false
						inspect:     false
					}
					mappings: []
					thresholds: {
						mode: "absolute"
						steps: [
							{
								color: "green"
							}, {
								color: "red"
								value: 80
							}]
					}
				}
				overrides: [{
					matcher: {
						id:      "byName"
						options: "Requests"
					}
					properties: [{
						id:    "custom.width"
						value: 300
					}, {
						id:    "custom.displayMode"
						value: "gradient-gauge"
					}, {
						id: "color"
						value: mode: "continuous-BlPu"
					}]
				}]
			}
			gridPos: {
				h: 7
				w: 11
				x: 0
				y: 47
			}
			id:       3
			interval: "30m"
			options: {
				footer: {
					fields: ""
					reducer: [
						"sum",
					]
					show: false
				}
				showHeader: true
				sortBy: [{
					desc:        true
					displayName: "Requests"
				}]
			}
			pluginVersion: "8.5.3"
			targets: [{
				datasource: {
					type: "loki"
					uid:  "loki:local"
				}
				editorMode:   "code"
				expr:         "topk(10, sum by (message_client) (count_over_time({app=\"$appName\", appNamespace=\"$appNamespace\"} | json | message_client != \"\"  __error__=\"\" [$__interval])))"
				legendFormat: "{{message_client}}"
				queryType:    "range"
				refId:        "A"
			}]
			title: "Top IPs"
			transformations: [{
				id: "reduce"
				options: reducers: [
					"sum",
				]
			}, {
				id: "organize"
				options: {
					excludeByName: Field: false
					indexByName: {}
					renameByName: {
						Field: "IP Address"
						Total: "Requests"
					}
				}
			}]
			type: "table"
		}, {
			datasource: {
				type: "loki"
				uid:  "${logsource}"
			}
			description: ""
			fieldConfig: {
				defaults: {
					color: mode: "thresholds"
					custom: {
						align:       "auto"
						displayMode: "auto"
						filterable:  false
						inspect:     false
					}
					mappings: []
					thresholds: {
						mode: "absolute"
						steps: [
							{
								color: "green"
							}, {
								color: "red"
								value: 80
							}]
					}
				}
				overrides: [{
					matcher: {
						id:      "byName"
						options: "Total"
					}
					properties: [{
						id:    "custom.width"
						value: 300
					}, {
						id:    "custom.displayMode"
						value: "gradient-gauge"
					}, {
						id: "color"
						value: mode: "continuous-BlPu"
					}]
				}]
			}
			gridPos: {
				h: 7
				w: 11
				x: 11
				y: 47
			}
			id:       12
			interval: "5m"
			options: {
				footer: {
					fields: ""
					reducer: [
						"sum",
					]
					show: false
				}
				showHeader: true
				sortBy: [{
					desc:        true
					displayName: "Total"
				}]
			}
			pluginVersion: "8.5.3"
			targets: [{
				datasource: {
					type: "loki"
					uid:  "loki:local"
				}
				editorMode:   "code"
				expr:         "topk(5,sum by (message_path) (count_over_time({app=\"$appName\", appNamespace=\"$appNamespace\"} | json | message_path != \"\"  __error__=\"\" [$__interval])))"
				legendFormat: "{{message_path}}"
				queryType:    "range"
				refId:        "A"
			}]
			title: "Top Requested Pages"
			transformations: [{
				id: "reduce"
				options: reducers: [
					"sum",
				]
			}, {
				id: "organize"
				options: {
					excludeByName: {}
					indexByName: {}
					renameByName: {
						Field: "Page"
						Total: ""
					}
				}
			}]
			type: "table"
		}]
		refresh:       false
		schemaVersion: 36
		style:         "dark"
		tags: []
		templating: list: [{
			current: {
				selected: false
				text:     context.namespace
				value:    context.namespace
			}
			hide: 2
			name: "appNamespace"
			options: [{
				selected: true
				text:     context.namespace
				value:    context.namespace
			}]
			query:       context.namespace
			skipUrlSync: false
			type:        "textbox"
		}, {
			current: {
				selected: false
				text:     context.appName
				value:    context.appName
			}
			hide: 2
			name: "appName"
			options: [{
				selected: true
				text:     context.appName
				value:    context.appName
			}]
			query:       context.appName
			skipUrlSync: false
			type:        "textbox"
		}, {
			current: {
				selected: false
				text:     "loki:local"
				value:    "loki:local"
			}
			hide:       2
			includeAll: false
			multi:      false
			name:       "logsource"
			options: []
			query:       "loki"
			refresh:     1
			regex:       ""
			skipUrlSync: false
			type:        "datasource"
		}]
		time: {
			from: "now-12h"
			to:   "now"
		}
		timepicker: refresh_intervals: ["10s", "30s", "1m", "5m", "15m", "30m", "1h", "2h", "1d"]
		timezone:  ""
		title:     "KubeVela application " + context.appName + " log analytics"
		uid:       context.appName + "log-dashboard"
		weekStart: ""
	}

}