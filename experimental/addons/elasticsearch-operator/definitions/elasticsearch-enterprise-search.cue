"elasticsearch-enterprise-search": {
	alias: ""
	annotations: {}
	attributes: workload: type: "autodetects.core.oam.dev"
	description: "elasticsearch enterprise search"
	labels: {}
	type: "component"
}

template: {
	output: {
		kind:       "EnterpriseSearch"
		apiVersion: "enterprisesearch.k8s.elastic.co/v1"
		metadata: {
			name: context.name
		}
		spec: {
			config:               parameter.config
			configRef:            parameter.configRef
			count:                parameter.count
			elasticsearchRef:     parameter.elasticsearchRef
			http:                 parameter.http
			image:                parameter.image
			podTemplate:          parameter.podTemplate
			revisionHistoryLimit: parameter.revisionHistoryLimit
			serviceAccountName:   parameter.serviceAccountName
			version:              parameter.version
		}
	}
	parameter: {
		//+usage=Config holds the Enterprise Search configuration.
		config: *null | {...}
		//+usage=ConfigRef contains a reference to an existing Kubernetes Secret holding the Enterprise Search configuration. Configuration settings are merged and have precedence over settings specified in `config`.
		configRef: *null | {...}
		//+usage=Count of Enterprise Search instances to deploy.
		count: *null | int
		//+usage=ElasticsearchRef is a reference to the Elasticsearch cluster running in the same Kubernetes cluster.
		elasticsearchRef: *null | {...}
		//+usage=HTTP holds the HTTP layer configuration for Enterprise Search resource.
		http: *null | {...}
		//+usage=Image is the Enterprise Search Docker image to deploy.
		image: *null | string
		//+usage=PodTemplate provides customisation options (labels, annotations, affinity rules, resource requests, and so on) for the Enterprise Search pods.
		podTemplate: *null | {...}
		//+usage=RevisionHistoryLimit is the number of revisions to retain to allow rollback in the underlying Deployment.
		revisionHistoryLimit: *null | int
		//+usage=ServiceAccountName is used to check access from the current resource to a resource (for ex. Elasticsearch) in a different namespace. Can only be used if ECK is enforcing RBAC on references.
		serviceAccountName: *null | string
		//+usage=Version of Enterprise Search.
		version: *null | string
	}
}
