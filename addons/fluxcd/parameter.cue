parameter: {
	images: {
		helmController:            *"fluxcd/helm-controller:v0.22.0" | string
		imageAutomationController: *"fluxcd/image-automation-controller:v0.23.0" | string
		imageReflectorController:  *"fluxcd/image-reflector-controller:v0.19.0" | string
		kustomizeController:       *"fluxcd/kustomize-controller:v0.26.0" | string
		sourceController:          *"fluxcd/source-controller:v0.25.1" | string
	}
}
