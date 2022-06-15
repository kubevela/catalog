import (
	"vela/ql"
)

parameter: {
	appName:    string
	appNs:      string
	cluster?:   string
	clusterNs?: string
}

resources: ql.#ListResourcesInApp & {
	app: {
		name:      parameter.appName
		namespace: parameter.appNs
		filter: {
			if parameter.cluster != _|_ {
				cluster: parameter.cluster
			}
			if parameter.clusterNs != _|_ {
				clusterNamespace: parameter.clusterNs
			}
			apiVersion: "v1"
			kind:       "Service"
		}
		withStatus: true
	}
}
status: {
	if resources.err == _|_ {
		services: [ for i, resource in resources.list {
			resource.object
		}]
	}
	if resources.err != _|_ {
		error: resources.err
	}
}
