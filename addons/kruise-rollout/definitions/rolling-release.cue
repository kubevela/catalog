"rolling-release": {
	type: "trait"
	annotations: {}
	labels: {}
	description: "Rolling workload with specified weight via kruise rollout. It's advisable not to use this trait directly. Instead, if you use the canary-deploy step, this trait will be added implicitly"
	attributes: {
		stage:         "PreDispatch"
		podDisruptive: true
		appliesToWorkloads: ["*"]
		status: {
			customStatus: #"""
				message: context.outputs.rollout.status.message
				"""#
			healthPolicy: #"""
				outdated: *false | bool
				if len(context.outputs.rollout.spec.strategy.canary.steps) < 1 {
					outdated: true
				}
				if len(context.outputs.rollout.spec.strategy.canary.steps) >= 1 {
					if context.parameter.weight != _|_ {
						if context.outputs.rollout.spec.strategy.canary.steps[0].weight == _|_ {
							outdated: true
						}
						if context.outputs.rollout.spec.strategy.canary.steps[0].weight != _|_ {
							if context.outputs.rollout.spec.strategy.canary.steps[0].weight != context.parameter.weight {
								outdated: true
							}
						}
					}
					if context.parameter.replicas != _|_ {
						if context.outputs.rollout.spec.strategy.canary.steps[0].replicas == _|_ {
								outdated: true
						}
						if context.outputs.rollout.spec.strategy.canary.steps[0].replicas != _|_ {
							if context.outputs.rollout.spec.strategy.canary.steps[0].replicas != context.parameter.replicas {
									outdated: true
							}
						}
					}
				}
				isHealth: *false | bool
				if context.outputs.rollout.status.phase == "Healthy" {
					if !outdated {
							isHealth: true
					}
				}
				if context.outputs.rollout.status.phase != "Healthy" {
					if context.outputs.rollout.status.canaryStatus != _|_ {
						if !outdated {
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
		// +usage=specify the type of traffic route, can be ingress, gateway or aliyun-alb.
		type: *"ingress" | "gateway" | "aliyun-alb"
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
		// +usage=Define the workload for rolling. If not specified, it will be auto detected.
		workloadType?: #WorkloadType
	}

	app: component: {...}
	app: {
		for comp in context.components {
			if comp.name == context.name {
				component: comp
			}
		}
	}

	trafficRouting: {
		type?: "ingress" | "gateway"
		if app.component != _|_ {
			if app.component.traits != _|_ {
				for t in app.component.traits {
					if t.type == "gateway" {
						type: "ingress"
					}

					if t.type == "http-route" || t.type == "https-route" || t.type == "tcp-route" {
						type: "gateway"
					}
				}
			}
		}
	}

	patch: metadata: annotations: "app.oam.dev/disable-health-check": "true"

	outputs: rollout: {
		apiVersion: "rollouts.kruise.io/v1alpha1"
		kind:       "Rollout"
		metadata: {
			name:      context.name
			namespace: context.namespace
			annotations: {
				"rollouts.kruise.io/rolling-style":    "partition"
				"controller.core.oam.dev/skip-resume": "true"
			}
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
					if trafficRouting.type != _|_ {
						trafficRoutings: [{
							service:            *context.name | string
							gracePeriodSeconds: *5 | int

							if trafficRouting.type == "ingress" {
								ingress: {
									name:      *context.name | string
									classType: "nginx"
								}
							}

							if trafficRouting.type == "gateway" {
								gateway: httpRouteName: *context.name | string
							}
						},
						]
					}
				}
			}
		}
	}
}
