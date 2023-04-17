"game-server": {
	alias: ""
	annotations: {}
	attributes: workload: type: "autodetects.core.oam.dev"
	description: "game server component"
	labels: {}
	type: "component"
}

template: {
	output: {
		kind:       "GameServer"
		apiVersion: "game.kruise.io/v1alpha1"
		metadata: {
			name: context.name
		}
		spec: {
			gameServerTemplate:   parameter.gameServerTemplate
			network:              parameter.network
			replicas:             parameter.replicas
			reserveGameServerIds: parameter.reserveGameServerIds
			scaleStrategy:        parameter.scaleStrategy
			serviceQualities:     parameter.serviceQualities
			updateStrategy:       parameter.updateStrategy
		}
	}
	parameter: {
		//+usage=Set delete priority.
		deletionPriority: *null | int
        //+usage=Set network disablity.
		networkDisabled: *null | bool
        //+usage= OPS state.
		opsState: *null | string
        //+usage=Set update priority.
		updatePriority: *null | int
	}
}
