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
			"gateway-tcp-\(rule.gatewayPort)": {
				apiVersion: "gateway.networking.k8s.io/v1alpha2"
				kind:       "Gateway"
				metadata: {
					name:      context.name + "-gateway-tcp-\(rule.gatewayPort)"
					namespace: context.namespace
				}
				spec: {
					gatewayClassName: "traefik"
					listeners: [{
						allowedRoutes: {
							namespaces: {
								from: "Same"
							}
							kinds: [{
								kind:  "TCPRoute"
								group: "gateway.networking.k8s.io"
							}]
						}
						name:     "listener-tcp-\(rule.gatewayPort)"
						port:     rule.gatewayPort
						protocol: "TCP"
					}]
				}
			}
			"tcp-route-\(rule.gatewayPort)": {
				apiVersion: "gateway.networking.k8s.io/v1alpha2"
				kind:       "TCPRoute"
				metadata: {
					name:      "tcp-route-\(rule.gatewayPort)"
					namespace: context.namespace
				}
				spec: {
					parentRefs: [{
						name:        context.name + "-gateway-tcp-\(rule.gatewayPort)"
						namespace:   context.namespace
						sectionName: "listener-tcp-\(rule.gatewayPort)"
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
		}]
	}
}
