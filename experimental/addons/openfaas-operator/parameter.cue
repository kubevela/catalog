// parameter.cue is used to store addon parameters.
//
// You can use these parameters in template.cue or in resources/ by 'parameter.myparam'
//
// For example, you can use parameters to allow the user to customize
// container images, ports, and etc.
parameter: {
	// +usage=Custom parameter description
	namespace: *"openfaas-operator" | string
	clusters?: [...string]
	// +usage=Specify the image repository
	"imageRepository": *"ghcr.io/openfaas/faas-cli" | string
	// +usage=Specify the image tag
	"imageTag": *"0.15.6" | string
}