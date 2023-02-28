"kruise-rollout": {
	type: "trait"
	annotations: {}
	labels: {}
	description: "Rollout workload by kruise controller."
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
						if context.outputs.rollout.metadata.annotations[""rollout.addon.dev/weight"] != _|_ {
							if context.outputs.rollout.metadata.annotations[""rollout.addon.dev/weight"] != context.parameter.canary.steps[0].weight {
								updated: false
							}
						}
					}
					if context.parameter.replicas != _|_ {
						if context.outputs.rollout.spec.strategy.canary.steps[0].replicas == _|_ {
							updated: false
						}
						if context.outputs.rollout.spec.strategy.canary.steps[0].replicas != _|_ {
							if context.outputs.rollout.spec.strategy.canary.steps[0].replicas != context.parameter.canary.steps[0].replicas {
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
	#CanaryStep: {
		// +usage=Define the percentage of traffic routing to the new version in each step, e.g., 20%, 40%...
		weight?: int
		// +usage=Define the replicas of release to the new version in each step, e.g., 5, 10...
		replicas?: int | string
		// +usage=Define the behavior after release each step, if not filled, the default requires manual determination. If filled, it indicates the time to wait in seconds, e.g., 60
		duration?: int
		// +usage=Define the Header/Cookie rules for the canary traffic in current step.
		matches?: [...#HttpRouteMatch]
	}
	#HttpRouteMatch: {
		// +usage=
		headers: [...#HTTPHeaderMatch]
	}
	#HTTPHeaderMatch: {
		Type?: *"Exact" | "RegularExpression"
		Name:  string
		Value: string
	}
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
		// +usage=If true, a streaming release will be performed, i.e., after the current step is released, subsequent steps will be released without interval
		auto: *false | bool
		// +usage=Defines the rolling style of Deployment, cloud be "canary" or "batch"
		releaseMode?: *"canary" | "batch"
		canary: {
			// +usage=Defines the entire rollout process in steps
			steps: [...#CanaryStep]
			// +usage=Define traffic routing related service, ingress information
			trafficRoutings?: [...#TrafficRouting]
		}
		workloadType?: #WorkloadType
		// *usage=Define the expect step
		stepPartition?: int
	}

	srcName: context.output.metadata.name


	patch: {
		 metadata: {
		 	   // +patchStrategy=jsonMergePatch
		 	   annotations: {"app.oam.dev/disable-health-check": "true"}
		 }
	}

	outputs: rollout: {
		apiVersion: "rollouts.kruise.io/v1alpha1"
		kind:       "Rollout"
		metadata: {
			name:      context.name
			namespace: context.namespace
			if parameter.releaseMode != _|_ {
				if parameter.releaseMode == "batch" {
					annotations: {
						"rollouts.kruise.io/rolling-style": "partition"
					}
				}
			}
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

							if v.matches != _|_ {
								matches: [
									for _, match in v.matches {
										headers: [
											for _, header in match.headers {
												type:  header.type
												name:  header.name
												value: header.value
											},
										]
									},
								]
							}

							pause: {
								if parameter.auto {
									duration: 0
								}
								if parameter.stepPartition != _|_ {
									if k <= parameter.stepPartition-1 {
										duration: 0
									}
								}
								if !parameter.auto && v.duration != _|_ && parameter.stepPartition == _|_ {
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

								if routing.type == "ingress" {
									if routing.ingressName != _|_ {
										ingress: name: routing.ingressName
									}
									if routing.ingressName == _|_ {
										ingress: name: context.name
									}
								}

								if routing.type == "gateway" {
									if routing.gatewayHTTPRouteName != _|_ {
										gateway: httpRouteName: routing.gatewayHTTPRouteName
									}
									if routing.gatewayHTTPRouteName == _|_ {
										gateway: httpRouteName: context.name
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
