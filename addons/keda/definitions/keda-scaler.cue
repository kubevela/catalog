"keda-auto-scaler": {
	annotations: {}
	attributes: {
		appliesToWorkloads: [
			"deployments.apps",
			"statefulsets.apps",
		]
		conflictsWith: []
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
		scaleTargetRef: {
			//+usage=Specify apiVersion for target workload
			apiVersion: *"apps/v1" | string
			//+usage=Specify kind for target workload
			kind: *"Deployment" | string
			//+usage=Specify containerName, default to find this path ".spec.template.spec.containers[0]"
			envSourceContainerName: *"" | string
			//+usage=Specify the instance name for target workload
			name: *context.name | string
		}
		//+usage=specify the polling interval of metrics,  Default: 30 seconds
		pollingInterval: *30 | int
		//+usage=Specify the cool down period that prevents the scaler from scaling down after each trigger activation. Default: 60 seconds
		cooldownPeriod: *60 | int
		//+usage=Specify the idle period that the scaler to scale to zero. Default: ignored, must be less than minReplicaCount.
		idleReplicaCount: *0 | int
		//+usage=Specify the minimal replica count. Default: 0.
		minReplicaCount: *1 | int
		//+usage=Specify the maximal replica count. Default: 100.
		maxReplicaCount: *100 | int
		//+usage=Specify the fallback value when the metrics server is not available.       
		fallback: {
			//+usage=Specify the failure threshold of the scaler. Default: 3.
			failureThreshold: *3 | int
			//+usage=Specify the replica when failed to get metrics. Default to minReplicaCount.
			replicas: *minReplicaCount | int
		}
	}
	outputs: {
		scaler: {
			apiVersion: "keda.sh/v1alpha1"
			kind:       "ScaledObject"
			metadata: {
				name: context.name
			}
			spec: {
				scaleTargetRef:   parameter.scaleTargetRef
				pollingInterval:  parameter.pollingInterval
				cooldownPeriod:   parameter.cooldownPeriod
				idleReplicaCount: parameter.idleReplicaCount
				minReplicaCount:  parameter.minReplicaCount
				maxReplicaCount:  parameter.maxReplicaCount
				fallback:         parameter.fallback
				triggers:         parameter.triggers
			}
		}
	}
	#Trigger: {
		//+usage= specify the type of trigger, the rest spec here aligns with KEDA spec
		type: string
		//+usage= specify the metadata of trigger, the spec aligns with the spec of KEDA https://keda.sh/docs/2.8/scalers/
		metadata: {
			...
		}
		...
	}
}
