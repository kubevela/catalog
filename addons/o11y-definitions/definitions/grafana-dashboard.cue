import (
	"encoding/json"
)

"grafana-dashboard": {
	alias: ""
	annotations: {}
	attributes: podDisruptive: false
	description: "The dashboard for grafana."
	attributes: workload: type: "autodetects.core.oam.dev"
	type: "component"
}

template: {
	parameter: {
		// +usage=The name of the grafana instance.
		grafana: *"default" | string
		// +usage=The uid of the grafana dashboard.
		uid: string
		// +usage=The json model of the grafana dashboard
		data: string
	}
	output: {
		apiVersion: "o11y.prism.oam.dev/v1alpha1"
		kind:       "GrafanaDashboard"
		metadata: name: "\(parameter.uid)@\(parameter.grafana)"
		spec: json.Unmarshal(parameter.data)
	}
}
