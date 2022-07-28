package main

bindingClusterAdmin: {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRoleBinding"
	metadata: {
		name: "cluster-reconciler"
	}
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "ClusterRole"
		name:     "cluster-admin"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "sa-kustomize-controller"
		namespace: parameter.namespace
	}, {
		kind:      "ServiceAccount"
		name:      "sa-helm-controller"
		namespace: parameter.namespace
	}]
}
