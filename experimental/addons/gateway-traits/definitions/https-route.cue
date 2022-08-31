"https-route": {
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
		_gatewayName: context.name + "-gateway-tls"
		gateway: {
			apiVersion: "gateway.networking.k8s.io/v1alpha2"
			kind:       "Gateway"
			metadata: {
				name:      _gatewayName
				namespace: context.namespace
			}
			spec: {
				gatewayClassName: parameter.gatewayClassName
				listeners: [
					for secret in parameter.secrets {
						{
							name:     secret.name
							protocol: "HTTPS"
							port:     parameter.TLSPort
							tls: {
								certificateRefs: [
									{
										kind: "Secret"
										name: secret.name
										if secret.namespace != _|_ {
											namespace: secret.namespace
										}
										if secret.namespace == _|_ {
											namespace: context.namespace
										}
									},
								]
							}
						}
					}]
			}
		}

		httpsRoute: {
			apiVersion: "gateway.networking.k8s.io/v1alpha2"
			kind:       "HTTPRoute"
			metadata: {
				name:      context.name + "-ssl"
				namespace: context.namespace
			}
			spec: {
				parentRefs: [{
					name:      _gatewayName
					namespace: context.namespace
					port:      parameter.TLSPort
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

		TLSPort: *8443 | int

		// +usage=Specify the gatewayClassName.
		gatewayClassName: *"traefik" | "istio"

		// +usage=Specify the TLS secrets.
		secrets: [...{
			name:       string
			namespace?: string
		}]
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
	}
}
