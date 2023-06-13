parameter: {
	// +usage=Specify the service type.
	serviceType: *"ClusterIP" | "NodePort" | "LoadBalancer" | "ExternalName"
	// +usage=Enabled the autoscaling
	autoscaling?: bool
	// +usage=Enabled the access log
	accessLog: *true | bool
	// +usage=Exposed the dashboard of traefik
	exposeDashboard: *true | bool
	// +usage=Specify the traefik entry points, only configured ports can be used for listenner.
	entryPoints?: [...{
		name:     string
		port:     int
		protocol: *"TCP" | "UDP"
	}]
	// +usage=Specify if upgrade the CRDs when upgrading traefik or not
	upgradeCRD: *false | bool
}
