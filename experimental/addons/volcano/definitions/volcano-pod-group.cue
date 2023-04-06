"volcano-pod-group": {
        alias: ""
        annotations: {}
        attributes: workload: type: "autodetects.core.oam.dev"
        description: "volcano pod group component"
        labels: {}
        type: "component"
}

template: {
        output: {
                kind:       "PodGroup"
                apiVersion: "scheduling.volcano.sh/v1beta1"
                metadata: {
                        name:      context.name
                }
                spec: {
                    queue:                parameter.queue
                    minMember:            parameter.minMember
                    minResources:         parameter.minResources
                    priorityClassName:    parameter.priorityClassName

                }
        }
        parameter: {
                //+usage=queue indicates the queue to which the PodGroup belongs. The queue must be in the Open state.
                queue: *null | string
                //+usage=priorityClassName represents the priority of the PodGroup and is used by the scheduler to sort all the PodGroups in the queue during scheduling. Note that system-node-critical and system-cluster-critical are reserved values, which mean the highest priority. If priorityClassName is not specified, the default priority is used.
                priorityClassName: *null | string
                //+usage=minResources indicates the minimum resources for running the PodGroup. If available resources in the cluster cannot satisfy the requirement, no pod or task in the PodGroup will be scheduled.
                minResources: *null| {...}
                //+usage=minMember indicates the minimum number of pods or tasks running under the PodGroup. If the cluster resource cannot meet the demand of running the minimum number of pods or tasks, no pod or task in the PodGroup will be scheduled.
                minMember: *null| int
        }
}
