package main

parameter: {

	// global parameters

	// +usage=The namespace of the prometheus-server to be installed
	namespace: *"o11y-system" | string
	// +usage=The name of the addon application
	name: "addon-prometheus-server"
	// +usage=The clusters to install
	clusters?: [...string]

	// prometheus-server parameters

	// +usage=Specify the image of prometheus-server
	image: *"quay.io/prometheus/prometheus:v2.34.0" | string
	// +usage=Specify the imagePullPolicy of the image
	imagePullPolicy: *"IfNotPresent" | "Never" | "Always"
	// +usage=Specify the number of CPU units
	cpu: *0.5 | number
	// +usage=Specifies the attributes of the memory resource required for the container.
	memory: *"1024Mi" | string
	// +usage=Specify the service type for expose prometheus server. If empty, it will be not exposed.
	serviceType: *"ClusterIP" | "NodePort" | "LoadBalancer" | ""
	// +usage=Specify the storage size to use. If empty, emptyDir will be used. Otherwise pvc will be used.
	storage: *"" | string
	// +usage=If specified, the prometheus server will mount the config map as the additional config.
	customConfig: *"" | string
	// +usage=If specified, thanos sidecar will be attached and ports will be exposed
	thanos: *false | bool
}
