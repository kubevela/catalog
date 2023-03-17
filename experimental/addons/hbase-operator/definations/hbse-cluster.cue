"hbase-cluster": {
	alias: ""
	annotations: {}
	attributes: workload: type: "autodetects.core.oam.dev"
	description: "hbase-cluster component"
	labels: {}
	type: "component"
}

template: {
	output: {
		kind:       "HBASECluster"
		apiVersion: "hbase.stackable.tech/v1alpha1"
		metadata: {
			name: context.name
		}
		spec: {
			image: parameter.image
			config: parameter.config
			hdfsConfigMapName: *null | string
			zookeeperConfigMapName: *null | string
			masters: parameter.masters
			regionServers: parameter.regionServers
			restServers: parameter.restServers
			
		}
	}
	parameter: {
		//+usage=The Hive metastore image to use.
		image: {
            //+usage=Overwrite the docker image. Specify the full docker image name, e.g. `docker.stackable.tech/stackable/superset:1.4.1-stackable2.1.0
	    custom: *null | string
            //+usage=Version of the product, e.g. `1.4.1`.
            productVersion: *null | string
            //+usage=Pull policy used when pulling the Images.
            pullPolicy: *"IfNotPresent" | string
            //+usage=Image pull secrets to pull images from a private registry.
            pullSecrets: *null | [...]
            //+usage=Name of the docker repo, e.g. `docker.stackable.tech/stackable.
            repo: *null | string
            //+usage=Stackable version of the product, e.g. 2.1.0.
            stackableVersion: *null | string
        }
		//+usage=General Hive metastore cluster settings.
		config: {
         

	     hbaseOpts: *null | string
	     hbaseRootdir: *null | string	
      
        }
		master: {
	     roleGroups: *{} | {...}
}

		regionServers: {
	     roleGroups: *{} | {...}
}
		restServers: {
	     roleGroups: *{} | {...}
}
		
		
