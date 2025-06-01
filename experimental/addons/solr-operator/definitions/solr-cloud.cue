import "encoding/base64"

"solr-cloud": {
	alias: "sc"
	annotations: {}
	attributes: {
		workload: type: "autodetects.core.oam.dev"
		// status: {}
	}
	description: "SolrCloud"
	labels: {}
	type: "component"
}

template: {
	output: {
		apiVersion: "solr.apache.org/v1beta1"
		kind:       "SolrCloud"
		metadata: name: context.name
		spec: {
            replicas:                   parameter.replicas
            solrImage:                  parameter.solrImage
            solrJavaMem:                parameter.solrJavaMem
            solrOpts:                   parameter.solrOpts
            solrGCTune:                 parameter.solrGCTune
            customSolrKubeOptions:      parameter.customSolrKubeOptions
            zookeeperRef:               parameter.zookeeperRef
		}
	}
	parameter: {
	    //+usage=the size of the solrcloud cluster.
        replicas: *3 | int
        //+usage=Image configuration
        solrImage: {
                //+usage=Image repository
                repository: *"library/solr" | string
                //+usage=Image tag
                tag: *"8.11" | string
                //+usage=Image pull policy
                pullPolicy: *"IfNotPresent" | string
        }
        //+usage=External host name appended for dns annotation
        solrJavaMem: *"-Xms1g -Xmx2g" | string
        solrOpts: *"-Dsolr.autoSoftCommit.maxTime=10000" | string
        solrGCTune: *"-XX:SurvivorRatio=4 -XX:TargetSurvivorRatio=90 -XX:MaxTenuringThreshold=8" | string
        customSolrKubeOptions: {
           podOptions: {
                resources: {
                   limits:
                      cpu: *"2" | string
                      memory: *"10G" | string
                    requests: {
                      cpu: *"500m" | string
                      memory: *"4G" | string
                    }
                }
           }
        }
        zookeeperRef: {
            provided: {
                image: {
                    repository: *"pravega/zookeeper" | string
                    tag: *"0.2.15" | string
                }
            }
        }
	}
}

