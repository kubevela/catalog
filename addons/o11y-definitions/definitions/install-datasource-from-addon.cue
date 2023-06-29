import (
	"vela/op"
	"vela/ql"
	"strconv"
)

"install-datasource-from-addon": {
	alias: ""
	annotations: {}
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
			_endpoints: [for ep in resources.list if ep.endpoint.portName != _|_ {ep}]
			endpoints: [ for ep in _endpoints if ep.endpoint.portName == parameter.portName {
				name:    "\(parameter.type):\(ep.cluster)"
				portStr: strconv.FormatInt(ep.endpoint.port, 10)
				url: "http://\(ep.endpoint.host):\(portStr)"
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
		portName:       *"http" | string
		grafana:        *"default" | string
	}
}
