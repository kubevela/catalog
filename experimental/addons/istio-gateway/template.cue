output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	metadata:
		name: 	   "istio-gateway"
		namespace: "vela-system"
	spec: {
		components: [{
			type: "k8s-objects"
			name: "ns-istio-system"
			properties: objects: [{
				apiVersion: "v1"
				kind:       "Namespace"
				metadata: name: "istio-system"
			}]
		}, {
			type: "helm"
			name: "base"
			properties: {
				repoType:        "helm"
				url:             "https://istio-release.storage.googleapis.com/charts"
				chart:           "base"
				version:         "1.14.2"
				targetNamespace: "istio-system"
			}
		}, {
			type: "helm"
			name: "istiod"
			properties: {
				repoType:        "helm"
				url:             "https://istio-release.storage.googleapis.com/charts"
				chart:           "istiod"
				version:         "1.14.2"
				targetNamespace: "istio-system"
			}
		}, {
			type: "helm"
			name: "gateway"
			properties: {
				repoType:        "helm"
				url:             "https://istio-release.storage.googleapis.com/charts"
				chart:           "gateway"
				version:         "1.14.2"
				targetNamespace: "istio-system"
				values: {
					service: {
						type: "ClusterIP"
						if parameter.entryPoints != _|_ {
							ports: [
								for entry in parameter.entryPoints {
									{
										"\(entry.name)": {
											port:       entry.port
											protocol:   entry.protocol
											targetPort: entry.port
										}
									}
								},
							]
						}
					}
				}
			}
		}, {
			type: "k8s-objects"
			name: "istio-gateway"
			properties: objects: [{
				apiVersion: "gateway.networking.k8s.io/v1alpha2"
				kind: "Gateway"
				metadata: {
					name: "istio-gateway"
					namespace: parameter.gatewayNamespace
					annotations: {
						"networking.istio.io/service-type": parameter.gatewayType
					}
				}
				spec: {
					gatewayClassName: "istio"
					if parameter.gatewayListeners != _|_ {
						listeners: [
							for item in parameter.gatewayListeners {
								{	
									name: 	  item.name
									if item.hostname != _|_ {
										hostname: item.hostname
									}
									port: 	  item.port
									protocol: item.protocol
									allowedRoutes: namespaces: from: item.routeNamespace
								}
							},
						]
					}
				}
			}]
		}]
	}
}
