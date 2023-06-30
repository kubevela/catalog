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
			if parameter.dns01 != _|_ && parameter.dns01.alidns != _|_ {
				alidnsWebhook
			}
			if parameter.dns01 != _|_ && parameter.dns01.alidns != _|_ {
				{
					type: "k8s-objects"
					name: "certificate-conf"
					dependsOn: ["alidns-webhook"]
					properties: objects: [
						alidnsTokenSecret,
						alidnsCertificate,
						alidnsIssuer,
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
						{
				type: "take-over"
				name: "take-over-CRD-namespace"
				properties: rules: [{
					selector: resourceTypes: ["CustomResourceDefinition", "Namespace"]
				}]
			},
			{
				type: "shared-resource"
				name: "shared-CRD-namespace"
				properties: rules: [{
					selector: resourceTypes: ["CustomResourceDefinition", "Namespace"]
				}]
			},
			{
				type: "garbage-collect"
				name: "not-gc-CRD-namespace"
				properties: {
					rules: [{
						selector: resourceTypes: ["CustomResourceDefinition", "Namespace"]
						strategy: "never"
					},
					]
				}
			},
			{
				type: "apply-once"
				name: "not-keep-CRD"
				properties: {
					rules: [{
						selector: resourceTypes: ["CustomResourceDefinition"]
						strategy: {
							path: ["*"]
						}
					},
					]
				}
			},
		]
	}
}
