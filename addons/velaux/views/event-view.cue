import (
	"vela/ql"
)

parameter: {
	name:      string
	namespace: string
	cluster:   *"" | string
}

pod: ql.#Read & {
	value: {
		apiVersion: "apps/v1"
		kind:       "Deployment"
		metadata: {
			name:      parameter.name
			namespace: parameter.namespace
		}
	}
	cluster: parameter.cluster
}

eventList: ql.#SearchEvents & {
	value: {
		apiVersion: "apps/v1"
		kind:       "Deployment"
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
