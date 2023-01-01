parameter: {
	// +usage=Specify the image registry of cronhpa controller, eg. "registry.aliyuncs.com/acs"
	registry: *"registry.aliyuncs.com" | string
	// +usage=Specify the image repository of cronhpa controller, eg. "kubernetes-cronhpa-controller"
	repository: *"acs/kubernetes-cronhpa-controller" | string
	// +usage=Specify the image tag of cronhpa controller, eg. "v1.4.1"
	imageTag: *"v1.4.1-b8cd52c-aliyun" | string
	// +usage=Specify the names of imagePullSecret for private image registry, eg. "{a,b,c}"
	imagePullSecrets?: [...string]
	// +usage=Specify the imagePullPolicy of the image
	imagePullPolicy: *"Always" | string
	// +usage=Specify the replicas.
	replicas: *1 | int
	// +usage=Specify the namespace to install
	namespace: *"vela-system" | string
	// +usage=Specify the clusters to install
	clusters?: [...string]
	// +usage=Specifies the attributes of the resource required
	resources: {
		requests: {
			cpu:    *1 | number
			memory: *"100Mi" | string
		}
		limits: {
			cpu:    *1 | number
			memory: *"100Mi" | string
		}
	}
}
