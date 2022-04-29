"http-route": {
	annotations: {}
	attributes: {
		appliesToWorkloads: ["*"]
		conflictsWith: []
		podDisruptive: false
	}
	description: "defines HTTP rules for mapping requests from a Gateway to Application."
	labels: {}
	type: "trait"
}

template: {
	outputs: {
		httpRoute: {
			apiVersion: "gateway.networking.k8s.io/v1alpha2"
			kind:       "HTTPRoute"
			metadata: {
				name:      context.name
				namespace: context.namespace
			}
			spec: {
				parentRefs: [{
					if parameter.gatewayName != _|_ {
						name: parameter.gatewayName
					}
					if parameter.gatewayName == _|_ {
						name: "traefik-gateway"
					}
					namespace: "vela-system"
					if parameter.listenerName != _|_ {
						sectionName: parameter.listenerName
					}
					if parameter.listenerName == _|_ {
						sectionName: "web"
					}
				}]
				hostnames: parameter.domains
				rules: [
					for rule in parameter.rules {
						{
							matches: [
								{
									if rule.path != _|_ {
										path: rule.path
									}
									if rule.headers != _|_ {
										headers: rule.headers
									}
								},
							]
							backendRefs: [{
								if rule.serviceName != _|_ {
									name: rule.serviceName
								}
								if rule.serviceName == _|_ {
									name: context.name
								}
								port: rule.port
							}]
						}
					},
				]
			}
		}
	}
	parameter: {
		// +usage=Specify some domains, the domain may be prefixed with a wildcard label (*.)
		domains: [...string]
		// +usage=Specify some HTTP matchers, filters and actions.
		rules: [...{
			// +usage=An HTTP request path matcher. If this field is not specified, a default prefix match on the "/" path is provided.
			path?: {
				type:  *"PathPrefix" | "Exact"
				value: *"/" | string
			}
			// +usage=Conditions to select a HTTP route by matching HTTP request headers.
			headers?: [...{
				type:  "Exact"
				name:  string
				value: string
			}]
			// +usage=Specify the service name of component, the default is component name.
			serviceName?: string
			// +usage=Specify the service port of component.
			port: int
		}]
		// +usage=Specify the gateway name
		gatewayName?: *"traefik-gateway" | string
		// +usage=Specify the listner name of the gateway
		listenerName?: *"web" | string
	}
}
