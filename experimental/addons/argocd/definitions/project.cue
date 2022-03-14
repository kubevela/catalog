"argocd-project": {
	annotations: {}
	attributes: workload: {
		type: "autodetects.core.oam.dev"
	}
	description: "Argocd-project is a definition of appproject resource."
	labels: {}
	type: "component"
}

template: {

	output: {
		apiVersion: "argoproj.io/v1alpha1"
		kind:       "AppProject"
		metadata:   {
			namespace: "argocd"
			finalizers: ["resources-finalizer.argocd.argoproj.io"]

		} & parameter.metadata
		spec: {} & parameter.spec
	}

	parameter: {
		#GK: {
			group: string
			kind:  string
		}

		#role: {
			description?: string
			group?: [...string]
			jwtTokens?: [...{exp?: int, iat: int, id?: id}]
			name?: string
			policies?: [...string]
		}

		#ignore: {
			group: string
			kind:  string
			name:  string
		}

		#syncWindows: {
			applications?: [...string]
			clusters?: [...string]
			duration?:   string
			kind?:       string
			manualSync?: bool
			namespace?: [...string]
			schedule?: string
			timeZone?: string
		}

		metadata: {
			name: string
		}
		spec: {
			description?: string
			clusterResourceWhitelist?: [...#GK]
			clusterResourceBlacklist?: [...#GK]
			destinations?: [...{name: string, namespace: string, server: string}]
			namespaceResourceBlacklist?: [...#GK]
			namespaceResourceWhitelist?: [...#GK]
			roles?: [...#role]
			sourceRepos?: [...string]
			signatureKeys?: [...{keyID: string}]
			SyncWindows?: [...#syncWindows]
			orphanedResources?: [...{ignore?: [...#ignore], warn?: bool}]
		}
	}
}
