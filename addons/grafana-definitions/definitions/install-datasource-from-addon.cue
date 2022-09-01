import (
	"vela/op"
	"vela/ql"
	"strconv"
)

"install-datasource-from-addon": {
	alias: ""
	annotations: {}
	attributes: podDisruptive: false
	description: "Discover datasource from addon for grafana."
	labels: "ui-hidden": "true"
	type: "workflow-step"
}

template: {
	resources: ql.#CollectServiceEndpoints & {
		app: {
			name:      parameter.addonName
			namespace: parameter.addonNamespace
			filter: {}
		}
	} @step(1)
	status: {
		endpoints: *[] | [...{...}]
		if resources.err == _|_ && resources.list != _|_ {
			endpoints: [ for ep in resources.list if ep.endpoint.port == parameter.port {
				name:    "\(parameter.type):\(ep.cluster)"
				portStr: strconv.FormatInt(ep.endpoint.port, 10)
				if ep.cluster == "local" && ep.ref.kind == "Service" {
					url: "http://\(ep.ref.name).\(ep.ref.namespace):\(portStr)"
				}
				if ep.cluster != "local" || ep.ref.kind != "Service" {
					url: "http://\(ep.endpoint.host):\(portStr)"
				}
			}]
		}
	}
	applyDatasources: op.#Steps & {
		for ep in status.endpoints {
			"apply-\(ep.name)": op.#Apply & {
				value: {
					apiVersion: "o11y.prism.oam.dev/v1alpha1"
					kind:       "GrafanaDatasource"
					metadata: name: "\(ep.name)@\(parameter.grafana)"
					spec: {
						type:   parameter.type
						name:   ep.name
						url:    ep.url
						access: "proxy"
					}
				}
			}
		}
	} @step(2)
	parameter: {
		type:           *"prometheus" | string
		addonName:      *"addon-prometheus-server" | string
		addonNamespace: *"vela-system" | string
		port:           *9090 | int
		grafana:        *"default" | string
	}
}
