package main

const: {
	name: "sae-apiserver-proxy"
}

parameter: {
	// +usage=The namespace to be installed to
	namespace: *"vela-system" | string

	// +usage=Specify the image
	image: *"kubevelacontrib/sae-apiserver-proxy:latest" | string
	// +usage=Specify the imagePullPolicy of the image
	imagePullPolicy: *"IfNotPresent" | "Never" | "Always"
	// +usage=Specify the number of CPU units
	cpu: *0.1 | number
	// +usage=Specifies the attributes of the memory resource required for the container.
	memory: *"200Mi" | string
}
