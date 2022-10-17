package main

const: {
	// +usage=The name of the addon application
	name: "addon-vela-workflow"
}

parameter: {
	// global parameters

	// +usage=The namespace of the vela-prism to be installed
	namespace: *"vela-system" | string
}
