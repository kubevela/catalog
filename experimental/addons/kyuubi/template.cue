package main
output: {
	apiVersion: "core.oam.dev/v1beta1"
	kind:       "Application"
	spec: {
		components: [{
               		type: "k8s-objects"
                	name: "kyuubi-ns"
                	properties: objects: [{
                        	apiVersion: "v1"
                        	kind:       "Namespace"
                        	metadata: name: parameter.namespace
                	}]
		},
		{
			name: "kyuubi-helm"
			type: "helm"
			dependsOn: ["kyuubi-ns"]
			properties: {
					repoType:        "helm"
					url: 		 "https://awesome-kyuubi.github.io/kyuubi-helm-chart/"
					chart:           "kyuubi"
					targetNamespace: parameter["namespace"]
					version:         "0.1.0"
					values: {
						image: {
							repository: parameter["imageRepository"]
							tag:        parameter["imageTag"]
						},
						kyuubiConf: {
                            				kyuubiDefaults: """
							spark.master=local
							"""
                        			}
					}
			}
		}]
		policies: []
	}
}
