package main

rbac_image_automation_controller: {
	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata: {
		name:      "sa-image-automation-controller"
		namespace: parameter.namespace
	}
}
