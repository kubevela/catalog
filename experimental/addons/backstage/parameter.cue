package main

parameter: {
	// +usage=Service type
	serviceType: *"ClusterIP" | "NodePort" | "LoadBalancer"
	name:        "addon-backstage"
	// +usage=The clusters to install
	clusters?: [...string]
	image:      *"wonderflow/backstage:v0.1" | string
	pluginOnly: *false | bool
}
