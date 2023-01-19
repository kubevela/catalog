package main

const: {
	// +usage=The name of the addon application
	name: "addon-vela-core-shard-manager"
}

parameter: {

	// global parameters

	// +usage=The namespace of the vela-prism to be installed
	namespace: *"vela-system" | string

	// vela-core replica parameters

	deploymentName: *"kubevela-vela-core" | string
	containerName: *"kubevela" | string
	instanceName: *"kubevela-slave" | string

	nShards: *1 | int
	shardNames?: [...string]
	replicas: *1 | int
}
