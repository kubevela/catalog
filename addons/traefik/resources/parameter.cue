parameter: {
	// +usage=Specify the service type.
	serviceType:  *"ClusterIP" | "NodePort" | "LoadBalancer" | "ExternalName"
	// +usage=Enabled the autoscaling
	autoscaling?: bool
	// +usage=Enabled the access log
	accessLog:    *true | bool
	// +usage=Exposed the dashboard of traefik
	exposeDashboard: *true | bool
}