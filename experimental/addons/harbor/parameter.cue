package main

parameter: {
	// +usage=Service type
	serviceType: *"ingress" | "clusterIP" | "loadBalancer" | "nodePort"
	// +usage=Specify the URL for harbor
	externalURL: string
	// +usage=The clusters to install
	clusters?: [...string]
}
