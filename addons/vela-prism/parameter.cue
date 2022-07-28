parameter: {

	// global parameters

	// +usage=The namespace of the vela-prism to be installed
	namespace: *"vela-system" | string
	// +usage=The name of the addon application
	name: "addon-vela-prism"

	// vela-prism parameters

	// +usage=Specify the image of vela-prism
	image: *"oamdev/vela-prism:v1.5.0" | string
	// +usage=Specify the imagePullPolicy of the image
	imagePullPolicy: *"IfNotPresent" | "Never" | "Always"
	// +usage=Specify the number of CPU units
	cpu: *0.1 | number
	// +usage=Specifies the attributes of the memory resource required for the container.
	memory: *"200Mi" | string
}
