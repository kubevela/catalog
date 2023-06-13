import (
	"vela/op"
	"strconv"
	"strings"
)

"install-datasource-from-config": {
	alias: ""
	annotations: {}
	description: "Discover datasource from the config system for grafana."
	type:        "workflow-step"
}

template: {
	resources: op.#ListConfig & {
		template:  parameter.type
		namespace: "vela-system"
	} @step(1)

	applyDatasources: op.#Steps & {
		for config in resources.configs {
			if config.config != _|_ && config.config.url != _|_ {
				"apply-\(config.name)": op.#Apply & {
					value: {
						apiVersion: "o11y.prism.oam.dev/v1alpha1"
						kind:       "GrafanaDatasource"
						_name:      strings.Replace(config.name, "-", "_", -1)
						metadata: name: "\(_name)@\(parameter.grafana)"
						spec: {
							if parameter.type == "prometheus-server" {
								if config.config.auth != _|_ {
									user:     config.config.auth.username
									password: config.config.auth.password
								}
								type: "prometheus"
							}
							if parameter.type == "loki" {
								type: "loki"
							}
							access: "proxy"
							url:    config.config.url
							name:   config.name
						}
					}
				}
			}
		}
	} @step(2)
	parameter: {
		type:    *"prometheus-server" | "loki" | string
		grafana: *"default" | string
	}
}
