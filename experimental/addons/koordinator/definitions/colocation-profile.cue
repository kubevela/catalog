"koordinator-colocation-profile": {
        alias: ""
        annotations: {}
        attributes: workload: type: "autodetects.core.oam.dev"
        description: "koordinator colocation profile component"
        labels: {}
        type: "component"
}

template: {
        output: {
                kind:       "ClusterColocationProfile"
                apiVersion: "config.koordinator.sh/v1alpha1"
                metadata: {
                        name:      context.name
                }
                spec: {
                    namespaceSelector:              parameter.namespaceSelector
                    selector:                       parameter.selector
                    qosClass:                       parameter.qosClass
                    priorityClassName:              parameter.priorityClassName
                    koordinatorPriority:            parameter.koordinatorPriority
                    labels:                         parameter.labels
                    annotations:                    parameter.annotations
                    schedulerName:                  parameter.schedulerName
                    patch:                          parameter.patch
                }
        }
        parameter: {
                //+usage=decides whether to mutate/validate Pods if the namespace matches the selector. Default to the empty LabelSelector, which will match everything.
                namespaceSelector: *{} | {...}
                //+usage=decides whether to mutate/validate Pods if the Pod matches the selector. Default to the empty LabelSelector, which will match everything.
                selector: *{} | {...}
                //+usage=describes the type of Koordinator QoS that the Pod is running. The value will be injected into Pod as label koordinator.sh/qosClass. Options are LSE, LSR, LS, BE, and SYSTEM.
                qosClass: *null | string
                //+usage=the priorityClassName and the priority value defined in PriorityClass will be injected into the Pod. Options are koord-prod, koord-mid, koord-batch, and koord-free.
                priorityClassName: *null | string
                //+usage=defines the Pod sub-priority in Koordinator. The priority value will be injected into Pod as label koordinator.sh/priority. Various Koordinator components determine the priority of the Pod in the Koordinator through KoordinatorPriority and the priority value in PriorityClassName. Higher the value, higher the priority.
                koordinatorPriority: *null | int
                //+usage=describes the k/v pair that needs to inject into Pod.Labels.
                labels: *null | {...}
                //+usage=describes the k/v pair that needs to inject into Pod.Annotations.
                annotations: *null | {...}
                //+usage=if specified, the pod will be dispatched by specified scheduler.
                schedulerName: *null | string
                //+usage=indicates Pod Template patching that user would like to inject into the Pod.
                patch: *null | {...}
        }
}
