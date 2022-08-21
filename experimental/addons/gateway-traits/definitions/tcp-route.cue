"tcp-route": {
	annotations: {}
	attributes: {
		appliesToWorkloads: ["*"]
		conflictsWith: []
		podDisruptive: false
	}
	description: "defines TCP rules for mapping requests from a Gateway to Application."
	labels: {
		
	}
	type: "trait"
}

template: {
	outputs: {
		for rule in parameter.rules {
			_gatewayName:  context.name + "-gateway-tcp-\(rule.gatewayPort)"
			_listenerName: "listener-tcp-\(rule.gatewayPort)"
			_ruleName:     "tcp-route-\(rule.gatewayPort)"
			"gateway-tcp-\(rule.gatewayPort)": {
				apiVersion: "gateway.networking.k8s.io/v1alpha2"
				kind:       "Gateway"
				metadata: {
					name:      _gatewayName
					namespace: context.namespace
				}
				spec: {
					gatewayClassName: rule.gatewayClassName
					listeners: [{
						allowedRoutes: {
							namespaces: {
								from: "Same"
							}
							kinds: [{
								kind: "TCPRoute"
								group: "gateway.networking.k8s.io"
							}]
						}
						name:     _listenerName
						port:     rule.gatewayPort
						protocol: "TCP"
					}]
				}
			}
			"tcp-route-\(rule.gatewayPort)": {
				apiVersion: "gateway.networking.k8s.io/v1alpha2"
				kind:       "TCPRoute"
				metadata: {
					name:      _ruleName
					namespace: context.namespace
				}
				spec: {
					parentRefs: [{
						name:        _gatewayName
						namespace:   context.namespace
						sectionName: _listenerName
					}]
					rules: [{
						backendRefs: [{
							if rule.serviceName != _|_ {
								name: rule.serviceName
							}
							if rule.serviceName == _|_ {
								name: context.name
							}
							port: rule.port
						}]
					}]
				}
			}
		}
	}
	parameter: {
		// +usage=Specify the TCP matchers
		rules: [...{
			// +usage=Specify the gateway listener port
			gatewayPort: int
			// +usage=Specify the service name of component, the default is component name.
			serviceName?: string
			// +usage=Specify the service port of component.
			port: int
			// +usage=Specify the gatewayClassName
			gatewayClassName: string
		}]
	}
}
