"elasticsearch-agent": {
	alias: ""
	annotations: {}
	attributes: workload: type: "autodetects.core.oam.dev"
	description: "elasticsearch agent trait"
	labels: {}
	type: "trait"
}

template: {
	outputs: agent: {
		kind:       "Agent"
		apiVersion: "agent.k8s.elastic.co/v1alpha1"
		metadata: {
			name: context.name
		}
		spec: {
			config:    				parameter.config
			configRef: 				parameter.configRef
            daemonSet:  			parameter.daemonSet
            deployment: 			parameter.deployment
            fleetServerEnabled: 	parameter.fleetServerEnabled
			fleetServerRef: 		parameter.fleetServerRef
			http:					parameter.http
			image:					parameter.image
			kibanaRef: 				parameter.kibanaRef
			mode:					parameter.mode
			policyID: 				parameter.policyID
			revisionHistoryLimit: 	parameter.revisionHistoryLimit
			secureSettings:			parameter.secureSettings
			serviceAccountName: 	parameter.serviceAccountName
			version: 				parameter.version
		}
	}
	parameter: {
		//+usage=Config holds the Agent configuration. At most one of [`Config`, `ConfigRef`] can be specified.
		config: *null | {...}
		//+usage=ConfigRef contains a reference to an existing Kubernetes Secret holding the Agent configuration. Agent settings must be specified as yaml, under a single "agent.yml" entry. At most one of [`Config`, `ConfigRef`] can be specified.
		configRef: *null | {...}
		//+usage=DaemonSet specifies the Agent should be deployed as a DaemonSet, and allows providing its spec. Cannot be used along with `deployment`.
		daemonSet: *null | {...}
		//+usage=Deployment specifies the Agent should be deployed as a Deployment, and allows providing its spec. Cannot be used along with `daemonSet`.
		deployment: *null | {...}
		//+usage=FleetServerEnabled determines whether this Agent will launch Fleet Server. Don't set unless `mode` is set to `fleet`.
		fleetServerEnabled: *null | bool
		//+usage=FleetServerRef is a reference to Fleet Server that this Agent should connect to to obtain it's configuration. Don't set unless `mode` is set to `fleet`.
		fleetServerRef: *null | {...}
		//+usage=HTTP holds the HTTP layer configuration for the Agent in Fleet mode with Fleet Server enabled.
		http: *null | {...}
		//+usage=Image is the Agent Docker image to deploy. Version has to match the Agent in the image.
		image: *null | string
		//+usage=KibanaRef is a reference to Kibana where Fleet should be set up and this Agent should be enrolled. Don't set unless `mode` is set to `fleet`.
		kibanaRef: *null | {...}
        //+usage=Mode specifies the source of configuration for the Agent. The configuration can be specified locally through `config` or `configRef` (`standalone` mode), or come from Fleet during runtime (`fleet` mode). Defaults to `standalone` mode.
		mode: *null | string
        //+usage=PolicyID optionally determines into which Agent Policy this Agent will be enrolled. If left empty the default policy will be used.
		policyID: *null | string
        //+usage=RevisionHistoryLimit is the number of revisions to retain to allow rollback in the underlying DaemonSet or Deployment.
		revisionHistoryLimit: *null | int
        //+usage=SecureSettings is a list of references to Kubernetes Secrets containing sensitive configuration options for the Agent. Secrets data can be then referenced in the Agent config using the Secret's keys or as specified in `Entries` field of each SecureSetting.
		secureSettings: *null | [...]
        //+usage=ServiceAccountName is used to check access from the current resource to an Elasticsearch resource in a different namespace. Can only be used if ECK is enforcing RBAC on references.
		serviceAccountName: *null | string
        //+usage=Version of the Agent.
		version: *null | string
	}
}
