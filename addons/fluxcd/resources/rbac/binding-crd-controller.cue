package main

binding_crd_controller: {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRoleBinding"
	metadata: {
		name: "crd-controller"
	}
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "ClusterRole"
		name:     "cr-crd-controller"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "sa-kustomize-controller"
		namespace: parameter.namespace
	}, {
		kind:      "ServiceAccount"
		name:      "sa-helm-controller"
		namespace: parameter.namespace
	}, {
		kind:      "ServiceAccount"
		name:      "sa-source-controller"
		namespace: parameter.namespace
	}, {
		kind:      "ServiceAccount"
		name:      "sa-image-reflector-controller"
		namespace: parameter.namespace
	}, {
		kind:      "ServiceAccount"
		name:      "sa-image-automation-controller"
		namespace: parameter.namespace
	}]
}
