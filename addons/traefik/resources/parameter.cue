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
	// +usage=Enable the Kubernetes Gateway provider, used by the http-route, https-route and tcp-route traits. Needs the Gateway API v1alpha2 CRDs (v0.4 to v0.6) in each cluster first
	gatewayAPI: *false | bool
	// +usage=Specify if upgrade the CRDs when upgrading traefik or not
	upgradeCRD: *false | bool
}
