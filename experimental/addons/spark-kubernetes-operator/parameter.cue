// parameter.cue is used to store addon parameters.
//
// You can use these parameters in template.cue or in resources/ by 'parameter.myparam'
//
// For example, you can use parameters to allow the user to customize
// container images, ports, and etc.
parameter: {
	// +usage=Deploy to specified clusters. Leave empty to deploy to all clusters.
        clusters?: [...string]
	// +usage=Namespace to deploy to
        namespace: *"spark-operator" | string
	// +usage=Specify if create  the webhook or not
        "createWebhook": *false | bool
	// +usage=Specify the image repository
        "imageRepository": *"ghcr.io/googlecloudplatform/spark-operator" | string
        // +usage=Specify the image tag
        "imageTag": *"v1beta2-1.3.8-3.1.1" | string
	// +usage=Specify if create the sa for job or not
        "createSparkServiceAccount": *false|bool
}
