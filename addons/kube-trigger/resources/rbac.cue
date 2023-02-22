package main

additionalPrivileges: {
	type: "k8s-objects"
	name: "kube-trigger-additional-privileges"
	properties: objects: [
		{
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
				name:      const.name
				namespace: const.namespace
			}]
		}, {
			apiVersion: "v1"
			kind:       "ServiceAccount"
			metadata: {
				name:      const.name
				namespace: const.namespace
			}
		}, {
			// Leader Election RBAC
			apiVersion: "rbac.authorization.k8s.io/v1"
			kind:       "Role"
			metadata: {
				name:      "leader-election-role"
				namespace: const.namespace
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
		}, {
			apiVersion: "rbac.authorization.k8s.io/v1"
			kind:       "RoleBinding"
			metadata: {
				name:      "leader-election-rolebinding"
				namespace: const.namespace
			}
			roleRef: {
				apiGroup: "rbac.authorization.k8s.io"
				kind:     "Role"
				name:     "leader-election-role"
			}
			subjects: [{
				kind:      "ServiceAccount"
				name:      const.name
				namespace: const.namespace
			}]
		}, {
			apiVersion: "rbac.authorization.k8s.io/v1"
			kind:       "ClusterRole"
			metadata: {
				name: "\(const.name)-role"
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
		}, {
			apiVersion: "v1"
			kind:       "ServiceAccount"
			metadata: {
				name:      "kube-trigger"
				namespace: const.namespace
			}
		}, {
			apiVersion: "rbac.authorization.k8s.io/v1"
			kind:       "ClusterRoleBinding"
			metadata: {
				name: "kube-trigger"
			}
			roleRef: {
				apiGroup: "rbac.authorization.k8s.io"
				kind:     "ClusterRole"
				name:     "cluster-admin"
			}
			subjects: [
				{
					kind:      "ServiceAccount"
					name:      "kube-trigger"
					namespace: const.namespace
				},
			]
		},
	]
}
