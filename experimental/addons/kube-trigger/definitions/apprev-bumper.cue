"apprev-bumper": {
	attributes: {
		workload: type: "autodetects.core.oam.dev"
	}
	description: "Trigger an application revision bump when a k8s resource changes. This is a wrapper over trigger-service."
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
			triggers: [{
				"k8s-resource-watcher": {
					parameter.watchResource
					events: []
				}
				filters: [{
					"cue-validator": template: "metadata: name: =~\"" + parameter.watchResource.nameRegex + "\""
				}]
				actions: [{
					"bump-application-revision": {
						namespace: context.namespace
						name:      context.appName
						labelSelectors: {}
					}
				}]
			}]
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
		//+usage=Watch changes of this resource then bump apprev.
		watchResource: {
			apiVersion: string
			kind:       string
			namespace:  string
			//+usage=Regex to match resource name.
			nameRegex: string
		}
	}
}
