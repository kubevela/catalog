import (
	"vela/op"
)

"canary-deploy": {
	type: "workflow-step"
	annotations: {
		"category": "Application Delivery"
	}
	labels: {
		"scope": "Application"
	}
	description: "A powerful and unified deploy step for components multi-cluster delivery with policies."
}
template: {
	deploy: op.#Deploy & {
		policies:                 parameter.policies
		parallelism:              5
		ignoreTerraformComponent: true
		inlinePolicies:           [{
			type: "override"
			name: "canary"
			properties: {
				selector: [parameter.component]
				components: [{
					name: parameter.component
					traits: [{
						type: "rolling-release"
						properties: {
							 weight: parameter.weight
						}
					}]
				}]
			}
		}]
	}
	parameter: {
		//+usage=Declare the policies that used for this deployment. If not specified, the components will be deployed to the hub cluster.
		policies: *[] | [...string]
		component: string
		weight: int
	}
}
