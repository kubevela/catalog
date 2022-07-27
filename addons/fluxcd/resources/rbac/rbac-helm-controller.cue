package main

rbac_helm_controller: {
	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata: {
		name:      "sa-helm-controller"
		namespace: parameter.namespace
	}
}
