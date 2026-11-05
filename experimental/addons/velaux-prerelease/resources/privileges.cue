package main

additionalPrivileges: {
	type: "k8s-objects"
	name: "velaux-additional-privileges"
	properties: objects: [
		{
			apiVersion: "rbac.authorization.k8s.io/v1"
			kind:       "ClusterRoleBinding"
			metadata: name: "clustergateway:kubevela:ux"
			roleRef: {
				apiGroup: "rbac.authorization.k8s.io"
				kind:     "ClusterRole"
				name:     "cluster-admin"
			}
			subjects: [{
				kind:     "Group"
				name:     "kubevela:ux"
				apiGroup: "rbac.authorization.k8s.io"
			}, {
				kind:      "ServiceAccount"
				name:      parameter["serviceAccountName"]
				namespace: "vela-system"
			}]
		},
		{
			apiVersion: "v1"
			kind:       "ServiceAccount"
			metadata: {
				name:      parameter["serviceAccountName"]
				namespace: "vela-system"
			}
			secrets: [
				{
					name: parameter["serviceAccountName"] + "-token"
				},
			]
		},
		{
			apiVersion: "v1"
			kind:       "Secret"
			metadata: {
				name:      parameter["serviceAccountName"] + "-token"
				namespace: "vela-system"
				annotations: "kubernetes.io/service-account.name": parameter["serviceAccountName"]
			}
			type: "kubernetes.io/service-account-token"
		},
	]
}
