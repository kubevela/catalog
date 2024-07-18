"zookeperznode-cluster": {
	alias: ""
	annotations: {}
	attributes: workload: type: "autodetects.core.oam.dev"
	description: "s3 bucket component"
	labels: {}
	type: "component"
}

template: {
	output: {
		kind:       "ZookeeperZnode"
		apiVersion: "zookeeper.stackable.tech/v1alpha1"
		metadata: {
			name: context.name
		}
		spec: {
			clusterRef: parameter.clusterRef
		}
	}
	parameter: {
		clusterRef: {
	    name: *null | string
    }
	
       }
