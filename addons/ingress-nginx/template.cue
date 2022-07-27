package main

output: {apiVersion: "core.oam.dev/v1beta1"
			kind: "Application"
	metadata: {
		name:      "ingress-nginx"
		namespace: "vela-system"
	}
	spec: {
		components: [nginxIngress]
		policies: [{
			type: "topology"
			name: "deploy-topology"
			properties: {
				if parameter.clusters != _|_ {
					clusters: parameter.clusters
				}
				if parameter.clusters == _|_ {
					clusterLabelSelector: {}
				}
			}
		}]
	}}
