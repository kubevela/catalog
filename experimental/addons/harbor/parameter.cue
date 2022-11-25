package main

parameter: {
	// +usage=Service type
	serviceType: *"ClusterIP" | "NodePort" | "LoadBalancer"
	// +usage=The clusters to install
	clusters?: [...string]
}
