"trigger-service": {
	attributes: {
		workload: type: "autodetects.core.oam.dev"
	}
	description: "Trigger service integrates kube-trigger, allowing you to configure event triggers."
	type:        "component"
}

template: {
	output: {
		apiVersion: "standard.oam.dev/v1alpha1"
		kind:       "TriggerService"
		metadata: {
			name:      parameter.name
			namespace: parameter.namespace
		}
		spec: {
			selector: {
				instance: parameter.name
			}
			triggers: parameter.triggers
		}
	}

	parameter: {
		//+usage=The namespace of the trigger service to configure
		namespace: *"vela-system" | string
		//+usage=The name of the trigger service
		name: string
		//+usage=Trigger configurations. Refer to https://github.com/kubevela/kube-trigger for details.
		triggers: [...{
			source: {
				type: string
				properties: {...}
			}
			filter: string
			action: {
				type: string
				properties: {...}
			}
		}]
	}
}
