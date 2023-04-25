"game-server-set": {
	alias: ""
	annotations: {}
	attributes: workload: type: "autodetects.core.oam.dev"
	description: "game server set component"
	labels: {}
	type: "component"
}

template: {
	output: {
		kind:       "GameServerSet"
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
		//+usage=INSERT ADDITIONAL SPEC FIELDS - desired state of cluster Important: Run "make" to regenerate code after modifying this file
		gameServerTemplate: *null | {...}
		//+usage=Configure Network.
		network: *null | {...}
		//+usage=replicas is the desired number of replicas of the given Template. These are replicas in the sense that they are instantiations of the same Template, but individual replicas also have a consistent identity.
		replicas: *1 | int
		//+usage=Enter Reserve game server Ids.
		reserveGameServerIds: *null | [...]
		//+usage=It takes an interger for attribute `maxUnavailable`.
		scaleStrategy: {
			//+usage=The maximum number of pods that can be unavailable during scaling. Value can be an absolute number (ex: 5) or a percentage of desired pods (ex: 10%). Absolute number is calculated from percentage by rounding down. It can just be allowed to work with Parallel podManagementPolicy.
			maxUnavailable: *null | int
		}
		//+usage=Configure serviceQualities.
		serviceQualities: *null | [...]
		//+usage=Configure updateStrategy.
		updateStrategy: {
			//+usage=Type indicates the type of the StatefulSetUpdateStrategy. Default is RollingUpdate.
			type: *null | string
			//+usage=RollingUpdate is used to communicate parameters when Type is RollingUpdateStatefulSetStrategyType.
			rollingUpdate: *null | {...}
		}
	}
}
