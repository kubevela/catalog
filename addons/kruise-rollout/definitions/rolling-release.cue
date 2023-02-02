"rolling-release": {
	type: "trait"
	annotations: {}
	labels: {}
	description: "Rolling workload with specified weight via kruise rollout."
	attributes: {
		podDisruptive: true
		appliesToWorkloads: ["*"]
		status: {
			customStatus: #"""
				message: context.outputs.rollout.status.message
				"""#
			healthPolicy: #"""
				updated: *true | bool
				if len(context.outputs.rollout.spec.strategy.canary.steps) < 1 {
					updated: false
				}
				if len(context.outputs.rollout.spec.strategy.canary.steps) >= 1 {
					if context.parameter.weight != _|_ {
						if context.outputs.rollout.spec.strategy.canary.steps[0].weight == _|_ {
							updated: false
						}
						if context.outputs.rollout.spec.strategy.canary.steps[0].weight != _|_ {
							if context.outputs.rollout.spec.strategy.canary.steps[0].weight != context.parameter.weight {
								updated: false
							}
						}
					}
					if context.parameter.replicas != _|_ {
						if context.outputs.rollout.spec.strategy.canary.steps[0].replicas == _|_ {
							updated: false
						}
						if context.outputs.rollout.spec.strategy.canary.steps[0].replicas != _|_ {
							if context.outputs.rollout.spec.strategy.canary.steps[0].replicas != context.parameter.replicas {
								updated: false
							}
						}
					}
				}

				isHealth: *false | bool
				if updated {
					if context.outputs.rollout.status.phase == "Healthy" {
						isHealth: true
					}
					if context.outputs.rollout.status.phase != "Healthy" {
						if context.outputs.rollout.status.canaryStatus != _|_ {
							isHealth: context.outputs.rollout.status.canaryStatus.currentStepState == "StepPaused"
						}
					}
				}
				"""#
		}
	}
}
template: {
	#TrafficRouting: {
		// +usage=holds the name of a service which selects pods with stable version and don't select any pods with canary version. Use context.name as service if not filled
		service?:           string
		gracePeriodSeconds: *5 | int
		// +usage=refers to the ingress as traffic route. Use context.name as service if not filled
		ingressName?: string
		// +usage=refers to the name of an `HTTPRoute` of gateway API.
		gatewayHTTPRouteName?: string
		// +usage=specify the type of traffic route, can be ingress or gateway.
		type: *"ingress" | "gateway"
	}
	#WorkloadType: {
		apiVersion: string
		kind:       string
	}
	parameter: {
		// +usage=Define the percentage of traffic routing to the new version in each step, e.g., 20, 40...
		weight?: int
		// +usage=Define the replicas of release to the new version in each step, e.g., 5, 10...
		replicas?: int | string
		// +usage=Declare whether the rolling reach end
		final: *false | bool

		// +usage=Define traffic routing related service, ingress information
		trafficRoutings?: [...#TrafficRouting]
		// +usage=Define the workload for rolling. If not specified, it will be auto detected.
		workloadType?: #WorkloadType
	}

	patch: metadata: annotations: "app.oam.dev/disable-health-check": "true"

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
					apiVersion: *context.output.apiVersion | string
					kind:       *context.output.kind | string
					if parameter.workloadType != _|_ {
						apiVersion: parameter.workloadType.apiVersion
						kind:       parameter.workloadType.kind
					}
					if parameter.workloadType == _|_ && context.output.kind == "HelmRepository" {
						apiVersion: "apps/v1"
						kind:       "Deployment"
					}

					name: *context.name | string
					if context.output.metadata.name != _|_ {
						name: context.output.metadata.name
					}
				}
			}
			strategy: {
				canary: {
					steps: [{
						if parameter.weight != _|_ {
							weight: parameter.weight
							pause: {
								if parameter.weight >= 100 {
									duration: 0
								}
							}
						}
						if parameter.replicas != _|_ {
							replicas: parameter.replicas
							pause: {
								if parameter.final {
									duration: 0
								}
							}
						}
					}]
					if parameter.trafficRoutings != _|_ {
						trafficRoutings: [
							for routing in parameter.trafficRoutings {
								service: *context.name | string
								if routing.service != _|_ {
									service: routing.service
								}
								gracePeriodSeconds: routing.gracePeriodSeconds

								if routing.type == "ingress" {
									ingress: name: *context.name | string
									if routing.ingressName != _|_ {
										ingress: name: routing.ingressName
									}
								}

								if routing.type == "gateway" {
									gateway: httpRouteName: *context.name | string
									if routing.gatewayHTTPRouteName != _|_ {
										gateway: httpRouteName: routing.gatewayHTTPRouteName
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
