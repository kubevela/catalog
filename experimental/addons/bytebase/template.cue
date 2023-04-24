package main

output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	spec: {
		components: [
			{
				name: "ns-bytebase"
				type: "k8s-objects"
				properties: objects: [{
					kind:       "Namespace"
					apiVersion: "v1"
					metadata:
						name: parameter.namespace
				}]
			},
			{
				name: "deploy-bytebase"
				type: "k8s-objects"
				properties: objects: [{
					apiVersion: "apps/v1"
					kind: "Deployment"
					metadata: {
						name: "bytebase"
						namespace: parameter.namespace
					}
					spec: {
						selector: {
							matchLabels: {
								app: "bytebase"
							}
						}
						template: {
							metadata: {
								labels:
									app: "bytebase"
							}
							spec: {
								containers: [
									{
										name: "bytebase"
										image: "bytebase/bytebase:" + parameter.version
										imagePullPolicy: "Always"
										env: [
											{
												name: "PG_URL"
												value: parameter.postgresURL
											}
										]
										args: [
											"--data",
											"/var/opt/bytebase",
											"--external-url",
											parameter.externalURL,
											"--port",
											"8080",
										]
										ports: [
											{
												containerPort: parameter.bytebasePort
											}
										]
										volumeMounts: [
											{
												name: "data"
												mountPath: "/var/opt/bytebase"
											}
										]
										livenessProbe: {
											httpGet: {
												path: "/healthz"
												port: 8080
											}
											initialDelaySeconds: 300
											periodSeconds: 300
											timeoutSeconds: 60
										}
									}
								]
								volumes: [
									{
										name: "data"
          								emptyDir: {}
									}
								]
							}
						}
					}
				}]
			},
			{
				name: "svc-bytebase"
				type: "k8s-objects"
				properties: objects: [{
					apiVersion: "v1"
					kind: "Service"
					metadata:{
						name: "bytebase-nodeport-entrypoint"
						namespace: parameter.namespace
					}
					spec: {
						type: "NodePort"
						selector: {
							app: "bytebase"
						}
						ports: [
							{
								protocol: "TCP"
								port: 8080
								targetPort: parameter.bytebasePort
							}
						]
					}
				}]
			},
		]
		policies: [
			{
				type: "shared-resource"
				name: "bytebase-ns"
				properties: rules: [{
					selector: resourceTypes: ["Namespace"]
				}]
			},
			{
				type: "topology"
				name: "deploy-bytebase"
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
