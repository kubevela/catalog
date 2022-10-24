package main

grafanaReaderRoleAndBinding: {
	name: "grafana-cluster-role"
	type: "k8s-objects"
	properties: objects: [{
		apiVersion: "rbac.authorization.k8s.io/v1"
		kind:       "ClusterRole"
		metadata: name: "o11y-system:grafana-reader"
		rules: _clusterPrivileges
	}, {
		apiVersion: "rbac.authorization.k8s.io/v1"
		kind:       "ClusterRoleBinding"
		metadata: name: "o11y-system:grafana-reader"
		roleRef: {
			apiGroup: "rbac.authorization.k8s.io"
			kind:     "ClusterRole"
			name:     "o11y-system:grafana-reader"
		}
		subjects: [{
			kind:      "ServiceAccount"
			name:      "grafana"
			namespace: parameter.namespace
		}]
	}]
}
