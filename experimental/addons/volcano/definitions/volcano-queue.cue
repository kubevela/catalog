"volcano-queue": {
        alias: ""
        annotations: {}
        attributes: workload: type: "autodetects.core.oam.dev"
        description: "volcano queue component"
        labels: {}
        type: "component"
}

template: {
        output: {
                kind:       "Queue"
                apiVersion: "scheduling.volcano.sh/v1beta1"
                metadata: {
                        name:      context.name
                }
                spec: {
                    reclaimable:        parameter.reclaimable
                    weight:             parameter.weight
                    capability:         parameter.capability
                }
        }
        parameter: {
                //+usage=weight indicates the relative weight of a queue in cluster resource division. The resource allocated to the queue equals (weight/total-weight) x total-resource. total-weight is the total weight of all queues. total-resource is the total number of cluster resources. weight is a soft constraint.
                weight: *null | int
                //+usage=reclaimable specifies whether to allow other queues to reclaim extra resources occupied by a queue when the queue uses more resources than allocated.
                reclaimable: *null | bool
                //+usage=capability indicates the upper limit of resources the queue can use. It is a hard constraint.
                capability: *null | {...}
        }
}
