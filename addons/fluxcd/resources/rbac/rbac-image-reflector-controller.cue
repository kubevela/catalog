package main

rbac_image_reflector_controller: {
	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata: {
		name:      "sa-image-reflector-controller"
		namespace: parameter.namespace
	}
}
