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
			}]
		},
	]
}
