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
			deletionPriority: parameter.deletionPriority
			networkDisabled:  parameter.networkDisabled
			opsState:         parameter.opsState
			updatePriority:   parameter.updatePriority
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
