package main

rbac_kustomize_controller: {
	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata: {
		name:      "sa-kustomize-controller"
		namespace: parameter.namespace
	}
}
