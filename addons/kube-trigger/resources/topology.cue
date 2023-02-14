package main

import "encoding/json"

resourceTopology: {
	type: "k8s-objects"
	name: "kube-trigger-resource-topology"
	properties: objects: [{
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
				kind:  "TriggerService"
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
			]
		}])
	}]}
