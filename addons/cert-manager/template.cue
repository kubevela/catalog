package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	spec: {
		components: [
			{
				type: "k8s-objects"
				name: "cert-manager-ns"
				properties: objects: [{
					apiVersion: "v1"
					kind:       "Namespace"
					metadata: name: parameter.namespace
				}]
			},
			certManager,
			if parameter.dns01 != _|_ && parameter.dns01.cloudflare != _|_ {
				{
					type: "k8s-objects"
					name: "certificate-conf"
					dependsOn: ["cert-manager"]
					properties: objects: [
						cfTokenSecret,
						cfCertificate,
						cfIssuer,
					]
				}
			},
		]
		policies: [
			{
				type: "shared-resource"
				name: "namespace"
				properties: rules: [{
					selector: resourceTypes: ["Namespace"]
				}]
			},
			{
				type: "topology"
				name: "deploy-cert-manager-ns"
				properties: {
					namespace: parameter.namespace
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
