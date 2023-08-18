package main

additionalPrivileges: {
	type: "k8s-objects"
	name: "vela-workflow-additional-privileges"
	properties: objects: [
		{
			apiVersion: "v1"
			kind:       "ServiceAccount"
			metadata: {
				name: "vela-workflow"
				labels: {
					"app.kubernetes.io/name":     const.name
					"app.kubernetes.io/instance": const.name
					"app.kubernetes.io/version":  parameter.version
				}
			}
		}, {
			apiVersion: "rbac.authorization.k8s.io/v1"
			kind:       "ClusterRoleBinding"
			metadata: name: "vela-workflow:manager-rolebinding"
			roleRef: {
				apiGroup: "rbac.authorization.k8s.io"
				kind:     "ClusterRole"
				name:     "cluster-admin"
			}
			subjects: [{
				kind:      "ServiceAccount"
				name:      const.name
				namespace: const.namespace
			}]
		}, {
			apiVersion: "rbac.authorization.k8s.io/v1"
			kind:       "Role"
			metadata: {
				name:      "vela-workflow:leader-election-role"
				namespace: const.namespace
			}
			rules: [
				{
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
				},
				{
					apiGroups: [
						"",
					]
					resources: [
						"configmaps/status",
					]
					verbs: [
						"get",
						"update",
						"patch",
					]
				},
				{
					apiGroups: [
						"",
					]
					resources: [
						"events",
					]
					verbs: [
						"create",
					]
				},
			]
		}, {
			apiVersion: "rbac.authorization.k8s.io/v1"
			kind:       "RoleBinding"
			metadata: {
				name:      "vela-workflow:leader-election-rolebinding"
				namespace: const.namespace
			}
			roleRef: {
				apiGroup: "rbac.authorization.k8s.io"
				kind:     "Role"
				name:     "vela-workflow:leader-election-role"
			}
			subjects: [
				{
					kind: "ServiceAccount"
					name: const.name
				},
			]
		},
	]
}
