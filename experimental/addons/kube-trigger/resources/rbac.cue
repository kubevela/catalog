package main

_targetNamespace: string

rbacClusterRuleBinding: {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRoleBinding"
	metadata: name: "kube-trigger-manager-rolebinding"
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "ClusterRole"
		// TODO: use a stricter permission
		name: "cluster-admin"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "kube-trigger-manager"
		namespace: _targetNamespace
	}]
}

rbacSA: {
	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata: {
		name:      "kube-trigger-manager"
		namespace: _targetNamespace
	}
}

rbacLeaderElection: {
	// Leader Election RBAC
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "Role"
	metadata: {
		name:      "leader-election-role"
		namespace: _targetNamespace
	}
	rules: [{
		apiGroups: [
			"",
		]
		resources: [
			"configmaps",
		]
		verbs: [
			"get",
			"list",
			"watch",
			"create",
			"update",
			"patch",
			"delete",
		]
	}, {
		apiGroups: [
			"coordination.k8s.io",
		]
		resources: [
			"leases",
		]
		verbs: [
			"get",
			"list",
			"watch",
			"create",
			"update",
			"patch",
			"delete",
		]
	}, {
		apiGroups: [
			"",
		]
		resources: [
			"events",
		]
		verbs: [
			"create",
			"patch",
		]
	}]
}

rbacLeaderElectionRoleBinding: {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "RoleBinding"
	metadata: {
		name:      "leader-election-rolebinding"
		namespace: "kube-trigger-system"
	}
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "Role"
		name:     "leader-election-role"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "kube-trigger-manager"
		namespace: "kube-trigger-system"
	}]
}
