import (
	"vela/op"
)

"canary-deploy": {
	type: "workflow-step"
	annotations: {
		"category": "Application Delivery"
	}
	labels: {
		"scope":   "Application"
		"catalog": "Delivery"
	}
	description: "A canary rollout step for components multi-cluster delivery with policies."
}
template: {
	deploy: op.#Deploy & {
		if parameter.policies != _|_ {
			policies: parameter.policies
		}
		parallelism:              5
		ignoreTerraformComponent: true
		inlinePolicies: [{
			type: "override"
			name: "canary"
			properties: {
				if parameter.component != _|_ {
					if len(parameter.component) != 0 {
						selector: parameter.component
					}
				}
				components: [{
					traits: [{
						type: "rolling-release"
						properties: {
							weight: parameter.weight
							if parameter.trafficRoutingType != _|_ {
								trafficRoutings: [{type: parameter.trafficRoutingType}]
							}
						}
					}]
				}]
			}
		}]
	}
	parameter: {
		//+usage=Declare the policies that used for this deployment. If not specified, the components will be deployed to the hub cluster.
		policies?: *[] | [...string]
		//+usage=Specify which component(s) to use for the canary rollout. If you do not specify, all components will be affected.
		components?: *[] | [...string]
		//+usage=Specify the percentage of replicas to update to the new version at each step, as well as the routing of traffic to the new version, e.g., 20, 40...
		weight: int
		//+usage=specify the type of traffic route, can be ingress, gateway or aliyun-alb
		trafficRoutingType?: "ingress" | "gateway" | "aliyun-alb"
	}
}
