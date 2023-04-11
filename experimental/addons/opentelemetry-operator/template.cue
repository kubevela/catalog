package main
output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	spec: {
		components: [
			{
				name: "ns-opentelemetry-operator"
				type: "k8s-objects"
				properties: objects: [{
					kind: "Namespace"
					apiVersion: "v1"
					metadata: {
						name: parameter.namespace
					}
				}]
			},
			{
				name: "cert-manager"
				type: "helm"
				properties:	{
					repoType: "helm"
					url: "https://charts.jetstack.io"
					chart: "cert-manager"
					version: "1.11.1"
					targetNamespace: parameter.namespace
					values:	{
						installCRDs: true
					}
				}
			},
			{
				name: "opentelemetry-operator"
				type: "helm"
				properties:	{
					repoType: "helm"
					url: "https://open-telemetry.github.io/opentelemetry-helm-charts"
					chart: "opentelemetry-operator"
					version: "0.26.0"
					targetNamespace: parameter.namespace
				}
			},
		]

		policies: [
			{
				type: "shared-resource"
				name: "opentelemetry-operator-ns"
				properties: rules: [{
					selector: resourceTypes: ["Namespace"]
				}]
			},
			{
				type: "topology"
				name: "deploy-opentelemetry-operator"
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

		workflow: {
			steps: [
				{
					name: "ns-opentelemetry-operator-step"
					type: "apply-component"
					properties: {
						component: "ns-opentelemetry-operator"
					}
				},
				{
					name: "cert-manager-step"
					type: "apply-component"
					dependsOn: ["ns-opentelemetry-operator-step"]
					properties: {
						component: "cert-manager"
					}
				},
				{
					name: "opentelemetry-operator-step"
					type: "apply-component"
					dependsOn: ["cert-manager-step"]
					properties: {
						component: "opentelemetry-operator"
					}
				}
			]
		}
	}
}
