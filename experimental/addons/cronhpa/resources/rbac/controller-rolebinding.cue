package main

controllerRoleBinding: {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRoleBinding"
	metadata: {
		name: "kubernetes-cronhpa-controller-rolebinding"
	}
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "ClusterRole"
		name:     "kubernetes-cronhpa-controller-role"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "kubernetes-cronhpa-controller"
		namespace: "kube-system"
	}]
}
