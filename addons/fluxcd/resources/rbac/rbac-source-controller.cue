package main

rbac_source_controller: {
	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata: {
		name:      "sa-source-controller"
		namespace: parameter.namespace
	}
}
