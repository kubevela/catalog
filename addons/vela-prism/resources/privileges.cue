package main

additionalPrivileges: {
	type: "k8s-objects"
	name: "vela-prism-additional-privileges"
	properties: objects: [{
		apiVersion: "rbac.authorization.k8s.io/v1"
		kind:       "ClusterRole"
		metadata: name: "vela-prism:prism-cluster-access-role"
		rules: [{
			apiGroups: [ "prism.oam.dev"]
			resources: [ "clusters"]
			verbs: [ "get", "list", "watch"]
		}]
	}, {
		apiVersion: "rbac.authorization.k8s.io/v1"
		kind:       "ClusterRoleBinding"
		metadata: name: "vela-prism:prism-cluster-access-rolebinding"
		roleRef: {
			apiGroup: "rbac.authorization.k8s.io"
			kind:     "ClusterRole"
			name:     "vela-prism:prism-cluster-access-role"
		}
		subjects: [{
			kind:     "Group"
			name:     "kubevela:client"
			apiGroup: "rbac.authorization.k8s.io"
		}]
	}, {
		apiVersion: "rbac.authorization.k8s.io/v1"
		kind:       "RoleBinding"
		metadata: {
			name:      "vela-prism"
			namespace: "kube-system"
		}
		subjects: [{
			kind:      "ServiceAccount"
			name:      "vela-prism"
			namespace: parameter.namespace
		}]
		roleRef: {
			apiGroup: "rbac.authorization.k8s.io"
			kind:     "Role"
			name:     "extension-apiserver-authentication-reader"
		}
	}]
}
