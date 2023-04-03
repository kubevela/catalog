"elasticsearch-beat": {
	alias: ""
	annotations: {}
	attributes: workload: type: "autodetects.core.oam.dev"
	description: "elasticsearch beat trait"
	labels: {}
	type: "trait"
}

template: {
	outputs: beat: {
		kind:       "Beat"
		apiVersion: "beat.k8s.elastic.co/v1beta1"
		metadata: {
			name: context.name
		}
		spec: {
			config:    				parameter.config
			configRef: 				parameter.configRef
            daemonSet:  			parameter.daemonSet
            deployment: 			parameter.deployment
            elasticsearchRef:       parameter.elasticsearchRef
			image:					parameter.image
			kibanaRef: 				parameter.kibanaRef
			monitoring:				parameter.monitoring
			revisionHistoryLimit: 	parameter.revisionHistoryLimit
			secureSettings:			parameter.secureSettings
			serviceAccountName: 	parameter.serviceAccountName
            type:                   parameter.type
			version: 				parameter.version
		}
	}
	parameter: {
		//+usage=Config holds the beat configuration. At most one of [`Config`, `ConfigRef`] can be specified.
		config: *null | {...}
		//+usage=ConfigRef contains a reference to an existing Kubernetes Secret holding the Beat configuration. Beat settings must be specified as yaml, under a single "beat.yml" entry. At most one of [`Config`, `ConfigRef`] can be specified.
		configRef: *null | {...}
		//+usage=DaemonSet specifies the Beat should be deployed as a DaemonSet, and allows providing its spec. Cannot be used along with `deployment`.
		daemonSet: *null | {...}
		//+usage=Deployment specifies the Beat should be deployed as a Deployment, and allows providing its spec. Cannot be used along with `daemonSet`.
		deployment: *null | {...}
		//+usage=ElasticsearchRef is a reference to an Elasticsearch cluster running in the same Kubernetes cluster.
		elasticsearchRef: *null | {...}
		//+usage=Image is the Beat Docker image to deploy. Version has to match the Beat in the image.
		image: *null | string
		//+usage=KibanaRef is a reference to Kibana where Fleet should be set up and this Beat should be enrolled. Don't set unless `mode` is set to `fleet`.
		kibanaRef: *null | {...}
        //+usage=Monitoring enables you to collect and ship logs and metrics for this Beat. Metricbeat and/or Filebeat sidecars are configured and send monitoring data to an Elasticsearch monitoring cluster running in the same Kubernetes cluster.
		monitoring: *null | {...}
        //+usage=RevisionHistoryLimit is the number of revisions to retain to allow rollback in the underlying DaemonSet or Deployment.
		revisionHistoryLimit: *null | int
        //+usage=SecureSettings is a list of references to Kubernetes Secrets containing sensitive configuration options for the Beat. Secrets data can be then referenced in the Beat config using the Secret's keys or as specified in `Entries` field of each SecureSetting.
		secureSettings: *null | [...]
        //+usage=ServiceAccountName is used to check access from the current resource to an Elasticsearch resource in a different namespace. Can only be used if ECK is enforcing RBAC on references.
		serviceAccountName: *null | string
        //+usage=Type is the type of the Beat to deploy (filebeat, metricbeat, heartbeat, auditbeat, journalbeat, packetbeat, and so on). Any string can be used, but well-known types will have the image field defaulted and have the appropriate Elasticsearch roles created automatically. It also allows for dashboard setup when combined with a `KibanaRef`.
		type: *null | string
        //+usage=Version of the Beat.
		version: *null | string
	}
}
