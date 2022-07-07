"effective-hpa": {
	alias: "ehpa"
	annotations: {}
	attributes: {
		appliesToWorkloads: [
			"deployments.apps",
			"replicasets.apps",
			"statefulsets.apps",
		]
		podDisruptive: false
	}
	description: "EffectiveHorizontalPodAutoscaler supports prediction-driven autoscaling and helps you manage application scaling in an easy way."
	labels: {
		"ui-hidden": "true"
	}
	type: "trait"
}

template: {
	outputs: ehpa: {
		apiVersion: "autoscaling.crane.io/v1alpha1"
		kind:       "EffectiveHorizontalPodAutoscaler"
		metadata: {
			name:      context.appName + "-" + context.name
			namespace: context.namespace
		}
		spec: {
			scaleTargetRef: {
				apiVersion: parameter.targetAPIVersion
				kind:       parameter.targetKind
				name:       context.name
			}
			scaleStrategy: "Auto"
			minReplicas:   parameter.min
			maxReplicas:   parameter.max
			metrics: [{
				type: "Resource"
				resource: {
					name: "cpu"
					target: {
						averageUtilization: parameter.cpuUtil
						type:               "Utilization"
					}
				}
			}]
			if parameter.enablePrediction {
				prediction: {
					predictionAlgorithm: {
						algorithmType: "dsp"
						dsp: {
							historyLength:  parameter.historyLength
							sampleInterval: parameter.sampleInterval
						}
					}
					predictionWindowSeconds: parameter.predictionWindowSeconds
				}
			}
		}
	}
	parameter: {
		// +usage=Specify the minimal number of replicas to which the autoscaler can scale down
		min: *1 | int
		// +usage=Specify the maximum number of of replicas to which the autoscaler can scale up
		max: *10 | int
		// +usage=Specify the average CPU utilization, for example, 50 means the CPU usage is 50%
		cpuUtil: *50 | int
		// +usgae=Enable prediction-driven autoscaling. DSP algorithm will be used, a time series prediction algorithm that applicable for application metrics prediction.
		enablePrediction: *true | bool
		// +usage=The time window to predict metrics in the future.
		predictionWindowSeconds: *3600 | int
		// +usage=DSP sample interval
		sampleInterval: *"60s" | string
		// +usage=DSP history length
		historyLength: *"3d" | string
		// +usage=Specify the apiVersion of scale target
		targetAPIVersion: *"apps/v1" | string
		// +usage=Specify the kind of scale target
		targetKind: *"Deployment" | string
	}
}
