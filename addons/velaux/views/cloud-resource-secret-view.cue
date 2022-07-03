import (
	"vela/ql"
)

parameter: {
	appName?: string
	appNs?:   string
}

secretList: ql.#List & {
	resource: {
		apiVersion: "v1"
		kind:       "Secret"
	}
	filter: {
		matchingLabels: {
			"created-by": "terraform-controller"
			if parameter.appName != _|_ && parameter.appNs != _|_ {
				"app.oam.dev/name":      parameter.appName
				"app.oam.dev/namespace": parameter.appNs
			}
		}
	}
}

status: {
	if secretList.err == _|_ {
		secrets: secretList.list.items
	}
	if secretList.err != _|_ {
		error: secretList.err
	}
}
