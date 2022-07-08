"clickhouse": {
	annotations: {}
	attributes: workload: definition: {
		apiVersion: "clickhouse.altinity.com/v1"
		kind:       "ClickHouseInstallation"
	}
	description: "Clickhouse Component provision a clickhouse cluster."
	labels: {}
	type: "component"
}

template: {
	output: {
		apiVersion: "clickhouse.altinity.com/v1"
		kind:       "ClickHouseInstallation"
		metadata: name: context.name
		spec: {
			configuration: {
				clusters: [{
					name: "simple"
				}]
			}
			defaults: {
				replicasUseFQDN: "no"
				distributedDDL: profile:    "default"
				templates: serviceTemplate: "chi-service-template"
			}
			templates: {
				serviceTemplates: [{
					name:         "chi-service-template"
					generateName: "service-{chi}"
					metadata: {
						labels: "custom.label": "custom.value"
						annotations: {
							"cloud.google.com/load-balancer-type":                         "Internal"
							"service.beta.kubernetes.io/aws-load-balancer-internal":       "0.0.0.0/0"
							"service.beta.kubernetes.io/azure-load-balancer-internal":     "true"
							"service.beta.kubernetes.io/openstack-internal-load-balancer": "true"
							"service.beta.kubernetes.io/cce-load-balancer-internal-vpc":   "true"
						}
					}
					spec: {
						ports: [
							{
								name: "http"
								port: 8123
							},
							{
								name: "client"
								port: 9000
							},
						]
						type: "NodePort"
					}
				}]
			}
		}
	}
	parameter: {
		nots:         *"2" | string
		flinkVersion: *"v1_14" | string
		image:        *"flink:latest" | string
		name:         string
		namespace:    string

		jarURI:      *"local:///opt/flink/examples/streaming/StateMachineExample.jar" | string
		parallelism: *2 | int
		upgradeMode: *"stateless" | string
		replicas:    *1 | int
		jmcpu:       *1 | int
		jmmem:       *"1024m" | string

		tmcpu: *1 | int
		tmmem: *"1024m" | string
	}
}
