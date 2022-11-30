"keda-scaler": {
	annotations: {}
	attributes: {
		appliesToWorkloads: [
			"deployments.apps",
			"statefulsets.apps",
		]
		conflictsWith: ["scaler"]
		podDisruptive:   false
		workloadRefPath: ""
	}
	description: "Configure auto scale rule for your workload."
	labels: {}
	type: "trait"
}
template: {
	parameter: {
		triggers: [...#Trigger]
	}
	outputs: {
		scaler: {
			apiVersion: "keda.sh/v1alpha1"
			kind:       "ScaledObject"
			metadata: {
				name: context.name
			}
			spec: {
				scaleTargetRef: {
					name: context.name
				}
				triggers: parameter.triggers
			}
		}}
	#Trigger: {
		type: string
		metadata: {
			...
		}
		...
	}
}
