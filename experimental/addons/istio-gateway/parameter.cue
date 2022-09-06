parameter: {
	// +usage=Specify the istio entry points, only configured ports can be used for listenner.
	entryPoints?: [...{
		name:     string
		port:     int
		protocol: *"TCP" | "UDP"
	}]
	// +usage=Specify the gateway namespace
	gatewayNamespace: *"vela-system" | string
	// +usage=Specify the gateway service type
	gatewayType: *"ClusterIP" | "NodePort" | "LoadBalancer"
	// +usage=Specify the gateway listeners
	gatewayListeners: [...{
		name:			*"web" | string
		hostname?: 		string
		port:     		*8050 | int
		routeNamespace: *"All" | "Same"
	}]
}