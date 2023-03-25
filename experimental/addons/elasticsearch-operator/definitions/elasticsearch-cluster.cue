"elasticsearch-cluster": {
	alias: ""
	annotations: {}
	attributes: workload: type: "autodetects.core.oam.dev"
	description: "elasticsearch cluster component"
	labels: {}
	type: "component"
}

template: {
	output: {
		kind:       "Elasticsearch"
		apiVersion: "elasticsearch.k8s.elastic.co/v1"
		metadata: {
			name: context.name
		}
		spec: {
			auth:                       parameter.auth
            http:                       parameter.http
			image:                      parameter.image
			monitoring:                 parameter.monitoring
			nodeSets:                   parameter.nodeSets
			podDisruptionBudget:        parameter.podDisruptionBudget
			remoteClusters:             parameter.remoteClusters
 			revisionHistoryLimit:       parameter.revisionHistoryLimit
			secureSettings:             parameter.secureSettings
            serviceAccountName:         parameter.serviceAccountName
            transport:                  parameter.transport
            updateStrategy:             parameter.updateStrategy
            version:                    parameter.version
            volumeClaimDeletePolicy:    parameter.volumeClaimDeletePolicy
		}
	}
	parameter: {
		//+usage=Auth contains user authentication and authorization security settings for Elasticsearch.
		auth: *null | {...}
        //+usage=HTTP holds HTTP layer settings for Elasticsearch.
		http: *null | {...}
        //+usage=Image is the Elasticsearch Docker image to deploy.
		image: *null | string
        //+usage=Monitoring enables you to collect and ship log and monitoring data of this Elasticsearch cluster. See https://www.elastic.co/guide/en/elasticsearch/reference/current/monitor-elasticsearch-cluster.html. Metricbeat and Filebeat are deployed in the same Pod as sidecars and each one sends data to one or two different Elasticsearch monitoring clusters running in the same Kubernetes cluster.
		monitoring: *null | {...}
        //+usage=NodeSets allow specifying groups of Elasticsearch nodes sharing the same configuration and Pod templates.
		nodeSets: *null | [...]
        //+usage=PodDisruptionBudget provides access to the default pod disruption budget for the Elasticsearch cluster. The default budget selects all cluster pods and sets `maxUnavailable` to 1. To disable, set `PodDisruptionBudget` to the empty value (`{}` in YAML).
		podDisruptionBudget: *null | {...}
        //+usage=RemoteClusters enables you to establish uni-directional connections to a remote Elasticsearch cluster.
		remoteClusters: *null | [...]
        //+usage=RevisionHistoryLimit is the number of revisions to retain to allow rollback in the underlying StatefulSets.
		revisionHistoryLimit: *null | int
        //+usage=SecureSettings is a list of references to Kubernetes secrets containing sensitive configuration options for Elasticsearch.
		secureSettings: *null | [...]
        //+usage=ServiceAccountName is used to check access from the current resource to a resource (for ex. a remote Elasticsearch cluster) in a different namespace. Can only be used if ECK is enforcing RBAC on references.
		serviceAccountName: *null | [...]
        //+usage=Transport holds transport layer settings for Elasticsearch.
		transport: *null | {...}
        //+usage=UpdateStrategy specifies how updates to the cluster should be performed.
		updateStrategy: *null | {...}
        //+usage=Version of Elasticsearch.
		version: *null | string
        //+usage=VolumeClaimDeletePolicy sets the policy for handling deletion of PersistentVolumeClaims for all NodeSets. Possible values are DeleteOnScaledownOnly and DeleteOnScaledownAndClusterDeletion. Defaults to DeleteOnScaledownAndClusterDeletion.
		volumeClaimDeletePolicy: *null | string
	}
}
