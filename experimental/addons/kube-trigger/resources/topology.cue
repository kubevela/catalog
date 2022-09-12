package main

import "encoding/json"

resourceTopology: {
	apiVersion: "v1"
	kind:       "ConfigMap"
	metadata: {
		name:      "kube-trigger-topology"
		namespace: "vela-system"
		labels: {
			"rules.oam.dev/resources":       "true"
			"rules.oam.dev/resource-format": "json"
		}
	}
	data: rules: json.Marshal([{
		parentResourceType: {
			group: "standard.oam.dev"
			kind:  "TriggerInstance"
		}
		childrenResourceType: [
			{
				apiVersion: "v1"
				kind:       "ConfigMap"
			},
			{
				apiVersion: "apps/v1"
				kind:       "Deployment"
			},
			{
				apiVersion: "rbac.authorization.k8s.io/v1"
				kind:       "ClusterRoleBinding"
			},
			{
				apiVersion: "v1"
				kind:       "ServiceAccount"
			},
		]
	}])
}
