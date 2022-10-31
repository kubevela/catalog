package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	metadata: {
		name:      const.name
		namespace: const.namespace
	}
	spec: {
		components: [
			{
				name: "workflow-helm"
				type: "helm"
				properties: {
					repoType:        "helm"
					url:             "https://charts.kubevela.net/core"
					chart:           "vela-workflow"
					version:         "0.3.1"
					targetNamespace: const.namespace
					releaseName:     "vela-workflow"
				}
			},
		]
	}
}
