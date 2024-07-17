parameter: {
	//+usage=Deploy to specified clusters. Leave empty to deploy to all clusters.
	clusters?: [...string]
	//+usage=Namespace to deploy to, defaults to flink-operator
	namespace: *"flink-operator" | string
	// +usage=Specify if create  the webhook or not
	"createWebhook": *false | bool
	// +usage=Specify the image repository
	"imageRepository": *"apache/flink-kubernetes-operator" | string
	// +usage=Specify the image tag
	"imageTag": *"latest" | string
	// +usage=Specify if create the sa for job or not
	"createJobServiceAccount": *false | bool
	//+usage=Specify if upgrade the CRDs when upgrading flink-kubernetes-operator or not
	upgradeCRD: *false | bool
	//+usage=Specify the flink operator version, defaults to 1.9.0
	flinkOperatorVersion: *"1.9.0" | string
}
