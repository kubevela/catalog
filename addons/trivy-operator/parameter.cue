parameter: {
	//+usage=Deploy to specified clusters. Leave empty to deploy to all clusters.
	clusters?: [...string]

	//+usage=Namespace to deploy to, defaults to cert-manager
	namespace: *"trivy-system" | string

	// +usage=Specify image including image repository address and image name to use for the trivy-operator
	"repository": *"devopstales/trivy-operator" | string

	// +usage=Specify image tag to use for the trivy-operator
	"tag": *"2.4.1" | string

	// +usage=Specify if persistent storage (pv) is enabled or not, no persistent storage when false
	"enabled": *false | bool

	// +usage=Specify the crontab for trivy-operator to scanning image in labled namespace
	"crontab": *"*/5 * * * *" | string
}
