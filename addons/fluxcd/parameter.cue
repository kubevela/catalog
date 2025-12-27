parameter: {
	//+usage=Base URL for images that the FluxCD controllers use, e.g. ghcr.io
	registry?: string
	//+usage=Deploy to specified clusters. Leave empty to deploy to all clusters.
	clusters?: [...string]
	//+usage=Namespace to deploy to, defaults to flux-system
	namespace: *"flux-system" | string
	//+usage=OnlyHelmComponents only enable helm associated components, default to false
	onlyHelmComponents: *false | bool
	//+usage=advanced options for Helm Controller
	helmControllerOptions?: [...string]
	//+usage=advanced options for Helm Controller
	helmControllerResourceLimits?: {}
	//+usage=advanced options for Helm Controller
	helmControllerResourceRequests?: {}
	//+usage=advanced options for Source Controller
	sourceControllerOptions?: [...string]
	//+usage=advanced options for Source Controller
	sourceControllerResourceLimits?: {}
	//+usage=advanced options for Source Controller
	sourceControllerResourceRequests?: {}
	//+usage=advanced options for Kustomize Controller
	kustomizeControllerOptions?: [...string]
	//+usage=advanced options for Kustomize Controller
	kustomizeControllerResourceLimits?: {}
	//+usage=advanced options for Kustomize Controller
	kustomizeControllerResourceRequests?: {}
	//+usage=advanced options for Image Reflector Controller
	imageReflectorControllerOptions?: [...string]
	//+usage=advanced options for Image Reflector Controller
	imageReflectorControllerResourceLimits?: {}
	//+usage=advanced options for Image Reflector Controller
	imageReflectorControllerResourceRequests?: {}
	//+usage=advanced options for Image Automation Controller
	imageAutomationControllerOptions?: [...string]
	//+usage=advanced options for Image Automation Controller
	imageAutomationControllerResourceLimits?: {}
	//+usage=advanced options for Image Automation Controller
	imageAutomationControllerResourceRequests?: {}
	//+usage=advanced options for Notification Controller
	notificationControllerOptions?: [...string]
	//+usage=advanced options for Notification Controller
	notificationControllerResourceLimits?: {}
	//+usage=advanced options for Notification Controller
	notificationControllerResourceRequests?: {}
}