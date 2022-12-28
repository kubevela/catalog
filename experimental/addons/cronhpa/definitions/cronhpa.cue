cronhpa: {
	type:  "trait"
	alias: "cronhpa"
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
	description: "kubernetes cron horizontal pod autoscaler trait"
	labels: {}
}

template: {
	outputs: {
		cronhpa: {
			apiVersion: "autoscaling.alibabacloud.com/v1beta1"
			kind:       "CronHorizontalPodAutoscaler"
			metadata: {
				labels: "controller-tools.k8s.io": "1.0"
				name: context.name
			}
			spec: {
				scaleTargetRef: {
					apiVersion: parameter.targetAPIVersion
					kind:       parameter.targetKind
					name:       context.name
				}
				if parameter.excludeDates != _|_ {
					excludeDates: [
						for d in parameter.excludeDates {
							d
						},
					]
				}
				jobs: [
					for s in parameter.hpaJobs {
						name:       s.name
						schedule:   s.schedule
						targetSize: s.targetSize
						runOnce:    s.runOnce
					},
				]
			}
		}
	}
	parameter: {
		// +usage=Specify the apiVersion of scale target
		targetAPIVersion: *"apps/v1" | string
		// +usage=Specify the kind of scale target
		targetKind: *"Deployment" | string
		// +usage=Specify the job will skip the execution when the dates is matched. The minimum unit is day.
		excludeDates?: [...string]
		// +usage=Specify multiple cron hpa jobs
		hpaJobs: [...{
			// +usage=Specify the name of hpa job, should be unique in one cronhpa spec
			name: string
			// +usage=Specify the cron schedule strategy
			schedule: string
			// +usage=Specify the size you desired to scale when the scheduled time arrive
			targetSize: int
			// +usage=Specify if this job need executed repeatly, if runOnce is true then the job will only run and exit after the first execution.
			runOnce: *false | bool
		}]
	}
}
