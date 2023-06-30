package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	spec: {
		components: [
			{
				name: "postgrest"
				type: "webservice"
				properties: {
					image: "postgrest/postgrest"
					port:  3000
					env: [
						{
							name:  "PGRST_DB_URI"
							value: parameter.PGRST_DB_URI
						},
					]
				}
			},
			{
				name: "svc-postgrest"
				type: "k8s-objects"
				properties: objects: [{
					apiVersion: "v1"
					kind:       "Service"
					metadata: {
						name:      "postgrest-nodeport-entrypoint"
						namespace: parameter.namespace
					}
					spec: {
						type: "NodePort"
						selector: {
							"app.oam.dev/name": "addon-postgrest"
						}
						ports: [
							{
								protocol:   "TCP"
								port:       3000
								targetPort: 3000
							},
						]
					}
				}]
			},
		]
		policies: [
			{
				type: "topology"
				name: "deploy-postgrest"
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
