parameter: {
	// +usage=The size of disk used by Prometheus alart manager and Prometheus server, The unit is GB.
	"disk-size": *"20" | string
	// +usage=Specify the service type.
	serviceType: *"ClusterIP" | "NodePort" | "LoadBalancer"
}
