"kibana": {
	alias: ""
	annotations: {}
	attributes: workload: type: "autodetects.core.oam.dev"
	description: "kibana component"
	labels: {}
	type: "component"
}

template: {
	output: {
		kind:       "Kibana"
		apiVersion: "kibana.k8s.elastic.co/v1"
		metadata: {
			name: context.name
		}
		spec: {
			config:               parameter.config
			count:                parameter.count
			elasticsearchRef:     parameter.elasticsearchRef
			enterpriseSearchRef:  parameter.enterpriseSearchRef
			http:                 parameter.http
			image:                parameter.image
			monitoring:           parameter.monitoring
			podTemplate:          parameter.podTemplate
			revisionHistoryLimit: parameter.revisionHistoryLimit
			secureSettings:       parameter.secureSettings
			serviceAccountName:   parameter.serviceAccountName
			version:              parameter.version
		}
	}
	parameter: {
		//+usage=Config holds the Kibana configuration. See: https://www.elastic.co/guide/en/kibana/current/settings.html.
		config: *null | {...}
		//+usage=Count of Kibana instances to deploy.
		count: *null | int
		//+usage=ElasticsearchRef is a reference to an Elasticsearch cluster running in the same Kubernetes cluster.
		elasticsearchRef: *null | {...}
		//+usage=EnterpriseSearchRef is a reference to an EnterpriseSearch running in the same Kubernetes cluster. Kibana provides the default Enterprise Search UI starting version 7.14.
		enterpriseSearchRef: *null | {...}
		//+usage=HTTP holds the HTTP layer configuration for Kibana.
		http: *null | {...}
		//+usage=Image is the Kibana Docker image to deploy.
		image: *null | string
		//+usage=Monitoring enables you to collect and ship log and monitoring data of this Kibana. See https://www.elastic.co/guide/en/kibana/current/xpack-monitoring.html. Metricbeat and Filebeat are deployed in the same Pod as sidecars and each one sends data to one or two different Elasticsearch monitoring clusters running in the same Kubernetes cluster.
		monitoring: *null | {...}
		//+usage=PodTemplate provides customisation options (labels, annotations, affinity rules, resource requests, and so on) for the Kibana pods.
		podTemplate: *null | {...}
		//+usage=RevisionHistoryLimit is the number of revisions to retain to allow rollback in the underlying Deployment.
		revisionHistoryLimit: *null | int
		//+usage=SecureSettings is a list of references to Kubernetes secrets containing sensitive configuration options for Kibana.
		secureSettings: *null | [...]
		//+usage=ServiceAccountName is used to check access from the current resource to a resource (for ex. Elasticsearch) in a different namespace. Can only be used if ECK is enforcing RBAC on references.
		serviceAccountName: *null | string
		//+usage=Version of Kibana.
		version: *null | string
	}
}
