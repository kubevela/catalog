// We put Definitions in definitions directory.
// References:
// - https://kubevela.net/docs/platform-engineers/cue/definition-edit
// - https://kubevela.net/docs/platform-engineers/addon/intro#definitions-directoryoptional

"stdout-logs": {
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
		parser?:      "nginx" | "apache" | "customize"
		VRL?: string
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
				name:      "vector-controller"
			}
			vectorConfig: {
				sources: "\(sourceName)": {
					type:                 "kubernetes_logs"
					extra_label_selector: "app.oam.dev/name=" + context.appName + ",app.oam.dev/component=" + context.name
				}
				transforms: {
					"\(parserName)": {
						inputs: [sourceName]
						type:   "remap"
						source: *"true" | string
						if parameter.parser != _|_ {
							if parameter.parser == "apache" {
								source: ".message = parse_apache_log!(.message, format: \"common\")"
							}
							if parameter.parser == "nginx" {
								source: ".message = parse_nginx_log!(.message, \"combined\")"
							}
							if parameter.parser == "customize" && parameter.VRL != _|_ {
								source: parameter.VRL
							}
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
							container: "{{ kubernetes.container_name }}"
							if parameter.parser != _|_ {
								parser: parameter.parser
							}
							app:          context.appName
							appNamespace: context.namespace
							cluster:      context.cluster
						}
						encoding: codec: "json"
					}
			}
		}
	}

	outputs: {
		if parameter.parser != _|_ {
			if parameter.parser == "nginx" {
				nginx_dashboard: {
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
			}
		}
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
					mappings: []
					thresholds: {
						mode: "absolute"
						steps: [{
							color: "purple"
							value: null
						}]
					}
					unit: "short"
				}
				overrides: []
			}
			gridPos: {
				h: 4
				w: 5
				x: 0
				y: 1
			}
			hideTimeOverride: false
			id:               4
			maxDataPoints:    300
			options: {
				colorMode:   "background"
				graphMode:   "area"
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
				expr:         "sum by(host) (count_over_time({app=\"$appName\", appNamespace=\"$appNamespace\"} [$__interval]))  "
				legendFormat: ""
				refId:        "A"
			}]
			timeFrom: "12h"
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
					mappings: []
					thresholds: {
						mode: "percentage"
						steps: [{
							color: "rgba(110, 157, 228, 0.76)"
							value: null
						}, {
							color: "rgba(73, 124, 202, 1)"
							value: 20
						}]
					}
					unit: "short"
				}
				overrides: []
			}
			gridPos: {
				h: 8
				w: 7
				x: 5
				y: 1
			}
			id:            5
			maxDataPoints: 20
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
					uid:  "loki-vela"
				}
				expr:         "sum by (message_status) (count_over_time({app=\"$appName\", appNamespace=\"$appNamespace\"} | json |  __error__=\"\" | message_status != \"\" [$__interval]))"
				instant:      false
				legendFormat: " {{message_status}}"
				range:        true
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
					color: mode: "thresholds"
					decimals: 0
					mappings: []
					thresholds: {
						mode: "absolute"
						steps: [{
							color: "semi-dark-orange"
							value: null
						}]
					}
					unit: "decbytes"
				}
				overrides: []
			}
			gridPos: {
				h: 4
				w: 5
				x: 12
				y: 1
			}
			id:            30
			maxDataPoints: 1
			options: {
				colorMode:   "background"
				graphMode:   "none"
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
				expr:         "bytes_over_time({app=\"$appName\", appNamespace=\"$appNamespace\"}[$__interval])"
				instant:      true
				legendFormat: "$label_value"
				range:        false
				refId:        "A"
			}]
			title: "NGINX logs in bytes"
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
				w: 5
				x: 17
				y: 1
			}
			id:            8
			maxDataPoints: 1
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
					uid:  "loki-vela"
				}
				expr:         "sum_over_time({app=\"$appName\", appNamespace=\"$appNamespace\"} | json | unwrap message_size |  __error__=\"\" [$__interval])"
				instant:      true
				legendFormat: "Bytes sent"
				range:        false
				refId:        "A"
			}]
			title: "Total Bytes Sent"
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
				}
				overrides: []
			}
			gridPos: {
				h: 4
				w: 5
				x: 0
				y: 5
			}
			id:       22
			interval: "5m"
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
				expr:         "count(sum by (message_client) (count_over_time({app=\"$appName\", appNamespace=\"$appNamespace\"} | json |  __error__=\"\" [$__interval])))"
				instant:      true
				legendFormat: ""
				range:        false
				refId:        "A"
			}]
			timeFrom: "5m"
			title:    "Realtime visitors "
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
							color: "semi-dark-orange"
							value: null
						}]
					}
					unit: "short"
				}
				overrides: []
			}
			gridPos: {
				h: 4
				w: 5
				x: 12
				y: 5
			}
			id:            31
			maxDataPoints: 1
			options: {
				colorMode:   "background"
				graphMode:   "none"
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
				expr:    "count_over_time({app=\"$appName\", appNamespace=\"$appNamespace\"}[$__interval])"
				instant: true
				range:   false
				refId:   "A"
			}]
			title: "# NGINX log lines"
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
					decimals: 1
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
				x: 17
				y: 5
			}
			hideTimeOverride: true
			id:               19
			links: []
			maxDataPoints: 1
			options: {
				colorMode:   "background"
				graphMode:   "none"
				justifyMode: "center"
				orientation: "auto"
				reduceOptions: {
					calcs: [
						"max",
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
					uid:  "loki-vela"
				}
				expr:         "sum(count_over_time({app=\"$appName\", appNamespace=\"$appNamespace\"} | json | message_status >= 500 |__error__=\"\"[$__interval])) / (sum(count_over_time({app=\"$appName\", appNamespace=\"$appNamespace\"} | json | __error__=\"\"[$__interval]))/ 100)"
				instant:      false
				legendFormat: ""
				range:        true
				refId:        "A"
			}]
			timeFrom: "1h"
			title:    "% of 5xx requests "
			type:     "stat"
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
				h: 16
				w: 11
				x: 0
				y: 9
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
				y: 9
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
			collapsed: false
			datasource: {
				type: "loki"
				uid:  "${logsource}"
			}
			gridPos: {
				h: 1
				w: 24
				x: 0
				y: 25
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
						steps: [{
							color: "green"
							value: null
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
				x: 0
				y: 26
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
		}, {
			datasource: {
				type: "loki"
				uid:  "loki-vela"
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
						steps: [{
							color: "green"
							value: null
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
				y: 26
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
					uid:  "loki-vela"
				}
				editorMode:   "code"
				expr:         "topk(20, sum by (message_referer) (count_over_time({app=\"$appName\", appNamespace=\"$appNamespace\"} | json |  message_referer != \"\" and message_referer !~ \".*?$host.*?\" | __error__=\"\" [$__interval])))"
				legendFormat: "{{message_referer}}"
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
						steps: [{
							color: "green"
							value: null
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
				y: 33
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
						steps: [{
							color: "green"
							value: null
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
				y: 33
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
