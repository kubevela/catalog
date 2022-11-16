import ("strings")

"vector-log2metric": {
	type: "component"
	attributes: workload: type: "autodetects.core.oam.dev"
}

template: {
	#parameter: {
		source: "file" | "pod"
		if source == "file" {
			files: [...string]
			readFrom: *"end" | "beginning"
		}
		if source == "pod" {
			podLabelSelector?: string
			podFieldSelector?: string
		}

		targetConfigMapName:      *"vector" | string
		targetConfigMapNamespace: *"vector" | string

		parseMode: "json" | "logfmt" | "regex" | "grok" | "nginx" | "apache" | "separator" | "custom"
		parseInto: *"parsed" | string
		if parseMode == "regex" || parseMode == "grok" || parseMode == "separator" {
			parsePattern: string
		}
		if parseMode == "custom" {
			parseVrl: string
		}
		parseDebug: bool

		streams: [...{
			metrics: [...{
				name: string
				type: *"gauge" | "counter"
				agg:  "count" | "sum" | "max" | "min" | "first" | "last"
				if agg != "count" {
					field: string
				}
				if agg == "count" {
					field: *"" | string
				}
			}]
			filter?:    string
			groupBy:    *[] | [...string]
			windowSecs: int
			job:        string
			tags:       *{} | {...}
			namespace:  string
			debug:      *false | bool
		}]

		internalMetrics:                   *false | true
		internalMetricsScrapeIntervalSecs: *60 | int
		internalMetricsNamespace:          *"vector" | string

		metricExporter?: int
		metricRemoteWrite?: {
			endpoint: string
			auth?: {
				strategy: *"basic" | "bearer"
				if strategy == "basic" {
					user:     string
					password: string
				}
				if strategy == "bearer" {
					token: string
				}
			}
			healthcheck: *false | true
		}
	}

	_prefix: "\(context.namespace)/\(context.name)"
	_params: #parameter & parameter
	_stages: {
		collect_logs: {
			id: "\(_prefix)/collect_logs"
			if _params.source == "file" {
				def: {
					type:      "file"
					include:   _params.files
					read_from: _params.readFrom
				}
			}
			if _params.source == "pod" {
				def: {
					type: "kubernetes_logs"
					if _params.podLabelSelector != _|_ {
						extra_label_selector: _params.podLabelSelector
					}
					if _params.podLabelSelector != _|_ {
						extra_field_selector: _params.podFieldSelector
					}
				}
			}
		}
		parse_logs: {
			id: "\(_prefix)/parse_logs"
			def: {
				type: "remap"
				inputs: [_stages.collect_logs.id]
				if _params.parseMode == "json" {
					source: ".\(_params.parseInto) = parse_json!(.message)"
				}
				if _params.parseMode == "logfmt" {
					source: ".\(_params.parseInto) = parse_logfmt!(.message)"
				}
				if _params.parseMode == "regex" {
					source: ".\(_params.parseInto) = parse_regex!(.message, r'\(_params.parsePattern)')"
				}
				if _params.parseMode == "grok" {
					source: ".\(_params.parseInto) = parse_grok!(.message, \"\(_params.parsePattern)\")"
				}
				if _params.parseMode == "nginx" {
					source: ".\(_params.parseInto) = parse_nginx_log!(.message, \"combined\")"
				}
				if _params.parseMode == "apache" {
					source: ".\(_params.parseInto) = parse_apache_log!(.message, \"combined\")"
				}
				if _params.parseMode == "separator" {
					source: ".\(_params.parseInto) = split!(.message, \"\(_params.parsePattern)\")"
				}
				if _params.parseMode == "custom" {
					source: _params.parseVrl
				}
			}
		}
		parse_debug: {
			id: "\(_prefix)/parse_debug"
			if _params.parseDebug {
				def: {
					type: "console"
					inputs: [_stages.parse_logs.id]
					encoding: codec: "json"
				}
			}
		}
		route_logs: {
			id: "\(_prefix)/route_logs"
			def: {
				type: "route"
				inputs: [_stages.parse_logs.id]
				route: {
					for index, stream in _params.streams {
						if stream.filter == _|_ {
							"stream-\(index)": "true"
						}
						if stream.filter != _|_ {
							"stream-\(index)": stream.filter
						}
					}
				}
			}
		}
		streams_prepare_reduce_logs: [
			for index, stream in _params.streams {
				id: "\(_prefix)/streams/\(index)/prepare_reduce_logs"
				def: {
					type: "remap"
					inputs: ["\(_stages.route_logs.id).stream-\(index)"]
					source: strings.Join([
						"new_event = {}",
						"new_event.__group_by__ = []",
						for item in stream.groupBy {
							"new_event.__group_by__ = push(new_event.__group_by__, to_string!(.\(item)))"
						},
						"new_event.__origin_event__ = .",
						for metric in stream.metrics {
							if metric.agg == "count" {
								"""
if is_null(.\(metric.field)) {
  new_event.\(metric.name) = 0
} else {
  new_event.\(metric.name) = 1
}"""
							}
							if metric.agg != "count" {
								"new_event.\(metric.name) = to_float!(.\(metric.field))"
							}
						},
						". = new_event",
					], "\n")
				}
			},
		]
		streams_reduce_logs: [
			for index, stream in _params.streams {
				id: "\(_prefix)/streams/\(index)/reduce_logs"
				def: {
					type: "reduce"
					inputs: ["\(_stages.streams_prepare_reduce_logs[index].id)"]
					expire_after_ms: stream.windowSecs * 1000
					group_by: [
						for index, _ in stream.groupBy {
							"__group_by__[\(index)]"
						},
					]
					merge_strategies: {
						for metric in stream.metrics {
							if metric.agg == "count" {
								"\(metric.name)": "sum"
							}
							if metric.agg == "sum" {
								"\(metric.name)": "sum"
							}
							if metric.agg == "max" {
								"\(metric.name)": "max"
							}
							if metric.agg == "min" {
								"\(metric.name)": "min"
							}
							if metric.agg == "first" {
								"\(metric.name)": "discard"
							}
							if metric.agg == "last" {
								"\(metric.name)": "retain"
							}
						}
					}
				}
			},
		]
		streams_prepare_generate_metrics: [
			for index, stream in _params.streams {
				id: "\(_prefix)/streams/\(index)/prepare_generate_metrics"
				def: {
					type: "remap"
					inputs: ["\(_stages.streams_reduce_logs[index].id)"]
					source: strings.Join([
						"new_event = .__origin_event__",
						"new_event.__metrics__ = {}",
						for metric in stream.metrics {
							"new_event.__metrics__.\(metric.name) = .\(metric.name)"
						},
						". = new_event",
					], "\n")
				}
			},
		]
		streams_generate_metrics: [
			for index, stream in _params.streams {
				id: "\(_prefix)/streams/\(index)/generate_metrics"
				def: {
					type: "log_to_metric"
					inputs: ["\(_stages.streams_prepare_generate_metrics[index].id)"]
					metrics: [
						for metric in stream.metrics {
							field: "__metrics__.\(metric.name)"
							name:  metric.name
							type:  metric.type
							tags: {
								job: stream.job
								for k, v in stream.tags {
									"\(k)": v
								}
							}
							namespace: stream.namespace
						},
					]
				}
			},
		]
		streams_debug: [
			for index, stream in _params.streams {
				id: "\(_prefix)/streams/\(index)/debug"
				if stream.debug {
					def: {
						type: "console"
						inputs: ["\(_stages.streams_generate_metrics[index].id)"]
						encoding: codec: "json"
					}
				}
			},
		]
		internal_metrics: {
			id: "\(_prefix)/internal_metrics"
			if _params.internalMetrics {
				def: {
					type:                 "internal_metrics"
					scrape_interval_secs: _params.internalMetricsScrapeIntervalSecs
					namespace:            _params.internalMetricsNamespace
					tags: {
						host_key: "host"
						pid_key:  "pid"
					}
				}
			}
		}
		export_metrics: {
			id: "\(_prefix)/export_metrics"
			if _params.metricExporter != _|_ {
				def: {
					type: "prometheus_exporter"
					inputs: [
						"\(_prefix)/streams/*/generate_metrics",
						if _params.internalMetrics {
							internal_metrics.id
						},
					]
					address: "0.0.0.0:\(_params.metricExporter)"
				}
			}
		}
		remote_write_metrics: {
			id: "\(_prefix)/remote_write_metrics"
			if _params.metricRemoteWrite != _|_ {
				def: {
					type: "prometheus_remote_write"
					inputs: [
						"\(_prefix)/streams/*/generate_metrics",
						if _params.internalMetrics {
							internal_metrics.id
						},
					]
					endpoint: _params.metricRemoteWrite.endpoint
					if _params.metricRemoteWrite.auth != _|_ {
						auth: strategy: _params.metricRemoteWrite.auth.strategy
						if _params.metricRemoteWrite.auth.strategy == "basic" {
							auth: user:     _params.metricRemoteWrite.auth.user
							auth: password: _params.metricRemoteWrite.auth.password
						}
						if _params.metricRemoteWrite.auth.strategy == "bearer" {
							auth: token: _params.metricRemoteWrite.auth.token
						}
					}
					healthcheck: enabled: _params.metricRemoteWrite.healthcheck
				}
			}
		}
	}
	_pipelines: {
		sources: [
			_stages.collect_logs, _stages.internal_metrics,
		]
		transforms: [
				_stages.parse_logs,
				_stages.route_logs,
		] + _stages.streams_prepare_reduce_logs + _stages.streams_reduce_logs + _stages.streams_prepare_generate_metrics + _stages.streams_generate_metrics
		sinks: [
			_stages.parse_debug,
			_stages.export_metrics,
			_stages.remote_write_metrics,
		] + _stages.streams_debug
	}
	output: {
		apiVersion: "vector.oam.dev/v1alpha1"
		kind:       "Config"
		spec: {
			if _params.source == "pod" {
				role: "daemon"
				targetConfigMap: {
					name:      _params.targetConfigMapName
					namespace: _params.targetConfigMapNamespace
				}
			}
			if _params.source == "file" {
				role: "sidecar"
			}
			vectorConfig: {
				sources: {
					for stage in _pipelines.sources if stage.def != _|_ {
						"\(stage.id)": stage.def
					}
				}
				transforms: {
					for stage in _pipelines.transforms if stage.def != _|_ {
						"\(stage.id)": stage.def
					}
				}
				sinks: {
					for stage in _pipelines.sinks if stage.def != _|_ {
						"\(stage.id)": stage.def
					}
				}
			}
		}
	}
}
