package main

appProject: {
	type: "k8s-objects"
	name: "appProject"
	dependsOn: ["argocd-resources"]
	properties: objects: [{
		apiVersion: "argoproj.io/v1alpha1"
		kind:       "AppProject"
		metadata: {
			name:      "default"
			namespace: "argocd"
		}
		spec: {
			clusterResourceWhitelist: [{
				group: "*"
				kind:  "*"
			}]
			destinations: [{
				namespace: "*"
				server:    "*"
			}]
			sourceRepos: ["*"]
		}
	}]
}
