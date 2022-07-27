package main

crd_controller: {
	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRole"
	metadata: {
		name: "cr-crd-controller"
	}
	rules: [{
		apiGroups: [
			"source.toolkit.fluxcd.io",
		]
		resources: [
			"*",
		]
		verbs: [
			"*",
		]
	}, {
		apiGroups: [
			"kustomize.toolkit.fluxcd.io",
		]
		resources: [
			"*",
		]
		verbs: [
			"*",
		]
	}, {
		apiGroups: [
			"helm.toolkit.fluxcd.io",
		]
		resources: [
			"*",
		]
		verbs: [
			"*",
		]
	}, {
		apiGroups: [
			"image.toolkit.fluxcd.io",
		]
		resources: [
			"*",
		]
		verbs: [
			"*",
		]
	}, {
		apiGroups: [
			"",
		]
		resources: [
			"namespaces",
			"secrets",
			"configmaps",
			"serviceaccounts",
		]
		verbs: [
			"get",
			"list",
			"watch",
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
	}, {
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
	}]
}
