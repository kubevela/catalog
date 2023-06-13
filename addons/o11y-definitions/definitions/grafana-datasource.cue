import (
	"encoding/json"
)

"grafana-datasource": {
	alias: ""
	annotations: {}
	description: "The datasource for grafana."
	attributes: workload: type: "autodetects.core.oam.dev"
	type: "component"
}

template: {
	parameter: {
		// +usage=The name of the grafana instance.
		grafana: *"default" | string
		// +usage=The uid of the grafana datasource.
		uid: string
		// +usage=The json model of the grafana datasource
		data: string
	}
	output: {
		apiVersion: "o11y.prism.oam.dev/v1alpha1"
		kind:       "GrafanaDatasource"
		metadata: name: "\(parameter.uid)@\(parameter.grafana)"
		spec: json.Unmarshal(parameter.data)
	}
}
