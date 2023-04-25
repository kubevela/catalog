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
					cmd: ["node", "server.js"]
					port: 3000
					cpu:  "0.1"
					env: [
						{
							name:  "PGRST_DB_URI"
							value: parameter.PGRST_DB_URI
						},
						{
							name:  "PGRST_OPENAPI_SERVER_PROXY_URI"
							value: parameter.PGRST_OPENAPI_SERVER_PROXY_URI
						}
					]
				}
			},
		]
		policies: [
			// {
			// 	type: "shared-resource"
			// 	name: "zookeeper-operator-ns"
			// 	properties: rules: [{
			// 		selector: resourceTypes: ["Namespace"]
			// 	}]
			// },
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
