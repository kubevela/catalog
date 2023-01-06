package main

parameter: {
	// +usage=Service type
	serviceType: *"ClusterIP" | "NodePort" | "LoadBalancer"
	name:        "addon-backstage"
	// +usage=The clusters to install
	clusters?: [...string]
	image:      *"wonderflow/backstage:v0.2" | string
	pluginOnly: *false | bool
	// +usage=Specify the number of CPU units
	cpu: *0.1 | number
	// +usage=Specifies the attributes of the memory resource required for the container.
	memory: *"200Mi" | string
	backstageapp: {
		// +usage=Specify the number of CPU units for backstage app
		cpu: *0.5 | number
		// +usage=Specifies the attributes of the memory resource required for backstage app
		memory: *"500Mi" | string
	}
}
