"kruise-rollout": {
	type: "trait"
	annotations: {}
	labels: {}
	description: "Rollout workload by kruise controller."
	attributes: {
		podDisruptive: true
		appliesToWorkloads: ["autodetects.core.oam.dev"]
		status: {
			customStatus: #"""
				message: context.outputs.rollout.status.message
				"""#
			healthPolicy: #"""
				isHealth: context.outputs.rollout.status.phase == "Healthy"
				"""#
		}
	}
}
template: {
	#CanaryStep: {
		// +usage=Define the percentage of traffic routing to the new version in each step, e.g., 20%, 40%...
		weight?: int
		// +usage=Define the replicas of release to the new version in each step, e.g., 5, 10...
		replicas?: int | string
		// +usage=Define the behavior after release each step, if not filled, the default requires manual determination. If filled, it indicates the time to wait in seconds, e.g., 60
		duration?: int
	}
	#TrafficRouting: {
		// use context.name as service if not filled
		service?:          string
		gracePeriodSeconds: *5 | int
		// +usage=Traffic routing for ingress providers, currently only nginx is supported, later we will gradually add more types, such as Isito, Alb
		type:               "nginx"
//		// +usage=ingress name
		ingressName?: string
	}
	#WorkloadType: {
		apiVersion: string
		kind:       string
	}
	parameter: {
		// +usage=If true, a streaming release will be performed, i.e., after the current step is released, subsequent steps will be released without interval
		auto: *false | bool
		canary: {
			// +usage=Defines the entire rollout process in steps
			steps: [...#CanaryStep]
			// +usage=Define traffic routing related service, ingress information
			trafficRoutings?: [...#TrafficRouting]
		}
		workloadType?: #WorkloadType
	}

	srcName: context.output.metadata.name

	outputs: rollout: {
		apiVersion: "rollouts.kruise.io/v1alpha1"
		kind:       "Rollout"
		metadata: {
			name:      context.name
			namespace: context.namespace
		}
		spec: {
			objectRef: {
				workloadRef: {
					if parameter["workloadType"] != _|_ {
						apiVersion: parameter["workloadType"].apiVersion
					}
					if parameter["workloadType"] == _|_ {
						if context.output.kind == "HelmRepository" {
							apiVersion: "apps/v1"
						}
						if context.output.kind != "HelmRepository" {
							apiVersion: context.output.apiVersion
						}

					}
					if parameter["workloadType"] != _|_ {
						kind: parameter["workloadType"].kind
					}
					if parameter["workloadType"] == _|_ {
						if context.output.kind == "HelmRepository" {
							kind: "Deployment"
						}
						if context.output.kind != "HelmRepository" {
							kind: context.output.kind
						}
					}
					if srcName != _|_ {
						name: srcName
					}
					if srcName == _|_ {
						name: context.name
					}
				}
			}
			strategy: {
				canary: {
					steps: [
						for k, v in parameter.canary.steps {
							if v.weight != _|_ {
								weight: v.weight
							}

							if v.replicas != _|_ {
								replicas: v.replicas
							}

							pause: {
								if parameter.auto {
									duration: 0
								}
								if !parameter.auto && v.duration != _|_ {
									duration: v.duration
								}
							}
						},
					]
					if parameter.canary.trafficRoutings != _|_ {
						trafficRoutings: [
							for routing in parameter.canary.trafficRoutings {
								if routing.service != _|_ {
									service: routing.service
								}
								if routing.service == _|_ {
									service: context.name
								}
								gracePeriodSeconds: routing.gracePeriodSeconds
								type:               routing.type
								ingress: {
									if routing.ingressName != _|_ {
										name: routing.ingress.name
									}
									if routing.ingressName == _|_ {
										name: context.name
									}
								}
							},
						]
					}
				}
			}
		}
	}
}
