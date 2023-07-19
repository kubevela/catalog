package main

import "encoding/json"

resourceTopology: {
	apiVersion: "v1"
	kind:       "ConfigMap"
	metadata: {
		name:      "mysql-operator-topology"
		namespace: "vela-system"
		labels: {
			"rules.oam.dev/resources":       "true"
			"rules.oam.dev/resource-format": "json"
		}
	}
	data: rules: json.Marshal([{
		parentResourceType: {
			apiVersion: "mysql.presslabs.org/v1alpha1"
			kind:       "MysqlCluster"
		}
		childrenResourceType: [
			{
				apiVersion: "apps/v1"
				kind:       "StatefulSet"
			},
			{
				apiVersion: "v1"
				kind:       "Service"
			},
		]
	}, {
		parentResourceType: {
			apiVersion: "mysql.presslabs.org/v1alpha1"
			kind:       "MysqlBackup"
		}
		childrenResourceType: [
			{
				apiVersion: "batch/v1"
				kind:       "Job"
			},
		]
	}])
}
