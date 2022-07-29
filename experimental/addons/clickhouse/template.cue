import "encoding/json"

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	metadata: {
		name:      parameter.name
		namespace: "vela-system"
	}
	spec: {
	}
}

outputs: toplogy: {
	apiVersion: "v1"
	kind:       "ConfigMap"
	metadata: {
		name:      parameter.name + "-toplogy"
		namespace: "vela-system"
		labels: {
			"rules.oam.dev/resources":       "true"
			"rules.oam.dev/resource-format": "json"
		}
	}
	data: rules: json.Marshal([_rule1])
}

_clickhouse: {
	group: "clickhouse.altinity.com"
	kind:  "ClickHouseInstallation"
}
_statefulset: {
	apiVersion: "apps/v1"
	kind:       "StatefulSet"
}
_service: {
	apiVersion: "v1"
	kind:       "Service"
}

_seldon: {
	group: "machinelearning.seldon.io"
	kind:  "SeldonDeployment"
}

_rule1: {
	parentResourceType: _clickhouse
	childrenResourceType: [_statefulset, _service]
}
