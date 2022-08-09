package main

redisOperator: {
	name: "redis-operator"
	type: "webservice"
	properties: {
		image:           parameter.image
		imagePullPolicy: "IfNotPresent"
	}
	traits: [
		{
			type: "service-account"
			properties: {
				name:       "redisoperator"
				create:     true
				privileges: rules
			}
		},
	]
}

rules: [
	{
		apiGroups: [
			"databases.spotahome.com",
		]
		resources: [
			"redisfailovers",
			"redisfailovers/finalizers",
		]
		verbs: [
			"*",
		]
		scope: "cluster"
	},
	{
		apiGroups: [
			"apiextensions.k8s.io",
		]
		resources: [
			"customresourcedefinitions",
		]
		verbs: [
			"*",
		]
		scope: "cluster"
	},
	{
		apiGroups: [
			"",
		]
		resources: [
			"pods",
			"services",
			"endpoints",
			"events",
			"configmaps",
			"persistentvolumeclaims",
			"persistentvolumeclaims/finalizers",
		]
		verbs: [
			"*",
		]
		scope: "cluster"
	},
	{
		apiGroups: [
			"",
		]
		resources: [
			"secrets",
		]
		verbs: [
			"get",
		]
		scope: "cluster"
	},
	{
		apiGroups: [
			"apps",
		]
		resources: [
			"deployments",
			"statefulsets",
		]
		verbs: [
			"*",
		]
		scope: "cluster"
	},
	{
		apiGroups: [
			"policy",
		]
		resources: [
			"poddisruptionbudgets",
		]
		verbs: ["*"]
		scope: "cluster"
	},
]
