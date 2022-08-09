parameter: {
	//+usage=Redis Operator image.
	image: *"quay.io/spotahome/redis-operator:v1.1.0" | string
	//+usage=Namespace to deploy to, defaults to vela-system
	namespace?: *"vela-system" | string
	//+usage=Deploy to specified clusters. Leave empty to deploy to all clusters.
	clusters?: [...string]
}
