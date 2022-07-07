"resource-analytics": {
	alias: "resanalyt"
	annotations: {}
	attributes: {
		appliesToWorkloads: [
			"deployments.apps",
		]
		podDisruptive: false
	}
	description: "Resource analytics gives you recommended values for resources in a cluster and use them to improve the resource utilization of the cluster."
	labels: {
		"ui-hidden": "true"
	}
	type: "trait"
}

template: {
	outputs: resanalyt: {
		apiVersion: "analysis.crane.io/v1alpha1"
		kind:       "Analytics"
		metadata: {
			name:      context.appName + "-" + context.name + "-resource"
			namespace: context.namespace
		}
		spec: {
			resourceSelectors: [{
				apiVersion: context.output.apiVersion
				kind:       context.output.kind
				name:       context.name
			}]
			type: "Resource"
			completionStrategy: {
				completionStrategyType: "Periodical"
				periodSeconds:          parameter.analyzePeriod
			}
		}
	}
	parameter: {
		// +usage=Analyze resources every analyzePeriod seconds
		analyzePeriod: *86400 | int
	}
}
