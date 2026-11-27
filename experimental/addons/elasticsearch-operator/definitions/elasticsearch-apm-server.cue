"elasticsearch-apm-server": {
	alias: ""
	annotations: {}
	attributes: workload: type: "autodetects.core.oam.dev"
	description: "elasticsearch apm server component"
	labels: {}
	type: "component"
}

template: {
	output: {
		kind:       "ApmServer"
		apiVersion: "apm.k8s.elastic.co/v1"
		metadata: {
			name: context.name
		}
		spec: {
			config:               parameter.config
			count:                parameter.count
			elasticsearchRef:     parameter.elasticsearchRef
			image:                parameter.image
			kibanaRef:            parameter.kibanaRef
			podTemplate:          parameter.podTemplate
			revisionHistoryLimit: parameter.revisionHistoryLimit
			secureSettings:       parameter.secureSettings
			serviceAccountName:   parameter.serviceAccountName
			version:              parameter.version
		}
	}
	parameter: {
		//+usage=Config holds the APM Server configuration. See: https://www.elastic.co/guide/en/apm/server/current/configuring-howto-apm-server.html.
		config: *null | {...}
		//+usage=Count of APM Server instances to deploy.
		count: *null | int
		//+usage=ElasticsearchRef is a reference to the output Elasticsearch cluster running in the same Kubernetes cluster.
		elasticsearchRef: *null | {...}
		//+usage=Image is the APM Server Docker image to deploy.
		image: *null | string
		//+usage=KibanaRef is a reference to a Kibana instance running in the same Kubernetes cluster. It allows APM agent central configuration management in Kibana.
		kibanaRef: *null | {...}
		//+usage=PodTemplate provides customisation options (labels, annotations, affinity rules, resource requests, and so on) for the APM Server pods.
		podTemplate: *null | {...}
		//+usage=RevisionHistoryLimit is the number of revisions to retain to allow rollback in the underlying Deployment.
		revisionHistoryLimit: *null | int
		//+usage=SecureSettings is a list of references to Kubernetes secrets containing sensitive configuration options for APM Server.
		secureSettings: *null | [...]
		//+usage=ServiceAccountName is used to check access from the current resource to a resource (for ex. Elasticsearch) in a different namespace. Can only be used if ECK is enforcing RBAC on references.
		serviceAccountName: *null | string
		//+usage=Version of the APM Server.
		version: *null | string
	}
}
