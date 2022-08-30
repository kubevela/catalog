output: {
	type: "k8s-objects"
	name: "traefik-web-gateway"
	properties: objects: [{
		apiVersion: "gateway.networking.k8s.io/v1alpha2"
		kind:       "Gateway"
		metadata:
			name: "traefik-web-gateway"
		    namespace: parameter.gatewayNamespace
		spec: {
			gatewayClassName: "traefik"
			if parameter.gatewayListeners != _|_ {
				listeners: [
					for entry in parameter.gatewayListeners {
						{
							name: "web"
							if entry.hostname != _|_ {
								hostname: entry.hostname
							}
							port:     entry.port
							protocol: "HTTP"
							allowedRoutes: namespaces: from: entry.routeNamespace
						}
					},
				]
			}
		}
	}]
}
