import (
	"vela/ql"
)

parameter: {
	name:      string
	namespace: string
	cluster:   *"" | string
	type:      string
}

schema: {
	"deployment": {
		apiVersion: "apps/v1"
		kind:       "Deployment"
	}
	"statefulset": {
		apiVersion: "apps/v1"
		kind:       "StatefulSet"
	}
	"pod": {
		apiVersion: "v1"
		kind:       "Pod"
	}
}

pod: ql.#Read & {
	value: {
		apiVersion: schema[parameter.type].apiVersion
		kind:       schema[parameter.type].kind
		metadata: {
			name:      parameter.name
			namespace: parameter.namespace
		}
	}
	cluster: parameter.cluster
}

eventList: ql.#SearchEvents & {
	value: {
		apiVersion: schema[parameter.type].apiVersion
		kind:       schema[parameter.type].kind
		metadata: pod.value.metadata
	}
	cluster: parameter.cluster
}

status: {
	if eventList.err == _|_ {
			events: eventList.list
	}
	if eventList.err != _|_ {
		error: eventList.err
	}
}
