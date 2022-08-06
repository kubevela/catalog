package main

_targetNamespace: *"vela-system" | string
if parameter.namespace != _|_ {
	_targetNamespace: parameter.namespace
}

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	spec: {
		components: [
			redisOperator
		]
		policies: [
			{
				type: "shared-resource"
				name: "redis-operator-ns"
				properties: rules: [{
					selector: resourceTypes: ["Namespace"]
				}]
			},
			{
				type: "topology"
				name: "deploy-redis-operator"
				properties: {
					namespace: _targetNamespace
					if parameter.clusters != _|_ {
						clusters: parameter.clusters
					}
					if parameter.clusters == _|_ {
						clusterLabelSelector: {}
					}
				}
			},
		]
	}
}
