"hive-cluster": {
	alias: ""
	annotations: {}
	attributes: workload: type: "autodetects.core.oam.dev"
	description: "s3 bucket component"
	labels: {}
	type: "component"
}

template: {
	output: {
		kind:       "HiveCluster"
		apiVersion: "hive.stackable.tech/v1alpha1"
		metadata: {
			name: context.name
		}
		spec: {
			image: parameter.image
			clusterConfig: parameter.clusterConfig
            metastore: parameter.metastore
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
		clusterConfig: {
            //+usage=Database connection specification.
            database: {
                connString: *null | string
                dbType:     *null | string
                password:   *null | string
                user:       *null | string
            }
            //+usage=HDFS connection specification.
            hdfs: *null | {...}
            //+usage=S3 connection specification.
            s3: {
                //+usage=S3 connection definition as CRD.
                inline: *null | {...}
                reference: *null | string
            }
            //+usage=Specify the type of the created kubernetes service. This attribute will be removed in a future release when listener-operator is finished. Use with caution.
            serviceType: *"ClusterIP" | string
            //+usage=Name of the Vector aggregator discovery ConfigMap. It must contain the key `ADDRESS` with the address of the Vector aggregator.
            vectorAggregatorConfigMapName: *null | string
        }
        //+usage=Configure metastore.
		metastore: {
            //+usage=Name of the discovery-configmap providing information about the HDFS cluster.
            cliOverrides: *{} | {...}
            //+usage=Name of the discovery-configmap providing information about the HDFS cluster.
            config: *{} | {...}
            //+usage=Name of the discovery-configmap providing information about the HDFS cluster.
            configOverrides: *{} | {...}
            //+usage=Name of the discovery-configmap providing information about the HDFS cluster.
            envOverrides: *{} | {...}
            //+usage=Name of the discovery-configmap providing information about the HDFS cluster.
            roleGroups: *{} | {...}
        }
        //+usage=Emergency stop button, if `true` then all pods are stopped without affecting configuration (as setting `replicas` to `0` would.
        stopped: *null | bool
	}
}
