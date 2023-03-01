package main

parameter: {
	// vela-core replica parameters
	deploymentName: *"kubevela-vela-core" | string
	containerName: *"kubevela" | string
	instanceName: *"kubevela-slave" | string

	nShards: *1 | int
	shardNames?: [...string]
	replicas: *1 | int
}
