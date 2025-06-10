package main

parameter: {
	// +usage=Service type
	serviceType: *"ClusterIP" | "NodePort" | "LoadBalancer"
	name:        "addon-backstage"
	// +usage=The clusters to install
	clusters?: [...string]
	image:      *"oamdev/backstage@sha256:e42e7de7c1007f456751a17fb3eb11794e6d80fb99eda0c03f7a4e34e91e6bec" | string
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
