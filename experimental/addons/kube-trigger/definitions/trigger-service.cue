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
			name:      context.appName + "-" + context.name + "-" + parameter.instanceName
			namespace: parameter.instanceNamespace
		}
		spec: {
			selector: {
				instance: parameter.instanceName
			}
			triggers: parameter.triggers
		}
	}

	outputs: {
		if parameter.createNewInstance {
			instance: {
				apiVersion: "standard.oam.dev/v1alpha1"
				kind:       "TriggerInstance"
				metadata: {
					name:      parameter.instanceName
					namespace: parameter.instanceNamespace
					labels: {
						instance: parameter.instanceName
					}
					spec: {}
				}
			}
		}
	}

	parameter: {
		//+usage=The namespace of the trigger instance to configure. Leave it to default to use the default instance.
		instanceNamespace: *"kube-trigger-system" | string
		//+usage=The name of the trigger instance to configure. Leave it to default to use the default instance.
		instanceName: *"default" | string
		//+usage=Create the trigger instance instead of using a existing one.
		createNewInstance: *false | true
		//+usage=Trigger configurations. Refer to https://github.com/kubevela/kube-trigger for details.
		triggers: [{...}]
	}
}
