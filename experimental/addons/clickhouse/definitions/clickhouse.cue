"clickhouse": {
	annotations: {
		"definition.oam.dev/example-url": "https://raw.githubusercontent.com/kubevela/catalog/master/examples/clickhouse/ckapp.yaml"
	}
	attributes: workload: {
		type: "autodetects.core.oam.dev"
	}
	description: "Clickhouse Component provision a clickhouse cluster."
	labels: {}
	type: "component"
}

template: {
	output: {
		apiVersion: "clickhouse.altinity.com/v1"
		kind:       "ClickHouseInstallation"
		spec: {
			configuration: {
				clusters: [{
					name: context.name
					layout: {
						shardsCount:   1
						replicasCount: 1
					}
				}]
			}
			defaults: {
				replicasUseFQDN: "no"
				distributedDDL: profile: "default"
				templates: {
					serviceTemplate: context.name + "-svc-templ"
					if parameter.storage != _|_ {
						dataVolumeClaimTemplate: context.name + "-vol-templ"
					}
				}
			}
			templates: {
				serviceTemplates: [{
					name: context.name + "-svc-templ"
					metadata: {
						labels: {
							if parameter.labels != _|_ for k, v in parameter.labels {
								"\(k)": v
							}
						}
						annotations: {
							if parameter.annotations != _|_ for k, v in parameter.annotations {
								"\(k)": v
							}
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
						type: parameter.svcPortType
					}
				}]
				if parameter.storage != _|_ {
					volumeClaimTemplates: [{
						name: context.name + "-vol-templ"
						spec: {
							storageClassName: parameter.storage.class
							accessModes: ["ReadWriteOnce"]
							resources: requests: storage: parameter.storage.size
						}
					}]
				}
			}
		}
	}
	parameter: {
		annotations?: [string]: string
		labels?: [string]:      string
		svcPortType: *"ClusterIP" | "NodePort" | "LoadBalancer"
		storage?: {
			size:  string
			class: *"local-path" | string
		}
	}
}
