package main

const: {
	// +usage=The name of the grafana addon application
	name: "addon-grafana"
}

parameter: {

	// global parameters

	// +usage=The namespace of the grafana to be installed
	namespace: *"o11y-system" | string
	// +usage=The clusters to install
	clusters?: [...string]

	// grafana parameters

	// +usage=Specify the image of kube-state-metrics
	image: *"grafana/grafana:8.5.3" | string
	// +usage=Specify the imagePullPolicy of the image
	imagePullPolicy: *"IfNotPresent" | "Never" | "Always"
	// +usage=Specify the number of CPU units
	cpu: *0.5 | number
	// +usage=Specifies the attributes of the memory resource required for the container.
	memory: *"1024Mi" | string
	// +usage=Specify the service type for expose prometheus server. Default to be ClusterIP.
	serviceType: *"ClusterIP" | "NodePort" | "LoadBalancer"
	// +usage=Specify the storage size to use. If empty, emptyDir will be used. Otherwise pvc will be used.
	storage?: =~"^([1-9][0-9]{0,63})(E|P|T|G|M|K|Ei|Pi|Ti|Gi|Mi|Ki)$"
	// +usage=Specify the storage class to use.
	storageClassName?: string
	// +usage=Specify the admin user for grafana
	adminUser: *"admin" | string
	// +usage=Specify the admin password for grafana
	adminPassword: *"kubevela" | string
}
