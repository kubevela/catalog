package main

rbacClusterRole: {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRole"
	metadata: {
		creationTimestamp: null
		name:              "kube-trigger-manager-role"
	}
	rules: [{
		apiGroups: [
			"",
		]
		resources: [
			"configmaps",
		]
		verbs: [
			"create",
			"delete",
			"get",
			"list",
			"update",
		]
	}, {
		apiGroups: [
			"",
		]
		resources: [
			"serviceaccounts",
		]
		verbs: [
			"create",
			"delete",
			"get",
			"list",
			"update",
		]
	}, {
		apiGroups: [
			"*",
		]
		resources: [
			"*",
		]
		verbs: [
			"*",
		]
	}, {
		apiGroups: [
			"apps",
		]
		resources: [
			"deployments",
		]
		verbs: [
			"create",
			"delete",
			"get",
			"list",
			"update",
		]
	}, {
		apiGroups: [
			"standard.oam.dev",
		]
		resources: [
			"kubetriggerconfigs",
		]
		verbs: [
			"create",
			"delete",
			"get",
			"list",
			"patch",
			"update",
			"watch",
		]
	}, {
		apiGroups: [
			"standard.oam.dev",
		]
		resources: [
			"kubetriggerconfigs/finalizers",
		]
		verbs: [
			"update",
		]
	}, {
		apiGroups: [
			"standard.oam.dev",
		]
		resources: [
			"kubetriggerconfigs/status",
		]
		verbs: [
			"get",
			"patch",
			"update",
		]
	}, {
		apiGroups: [
			"standard.oam.dev",
		]
		resources: [
			"kubetriggers",
		]
		verbs: [
			"create",
			"delete",
			"get",
			"list",
			"patch",
			"update",
			"watch",
		]
	}, {
		apiGroups: [
			"standard.oam.dev",
		]
		resources: [
			"kubetriggers/finalizers",
		]
		verbs: [
			"update",
		]
	}, {
		apiGroups: [
			"standard.oam.dev",
		]
		resources: [
			"kubetriggers/status",
		]
		verbs: [
			"get",
			"patch",
			"update",
		]
	}]
}
