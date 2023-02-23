"koordinator-node-metric": {
        alias: ""
        annotations: {}
        attributes: workload: type: "autodetects.core.oam.dev"
        description: "koordinator node metric component"
        labels: {}
        type: "component"
}

template: {
        output: {
                kind:       "NodeMetric"
                apiVersion: "slo.koordinator.sh/v1alpha1"
                metadata: {
                        name:      context.name
                }
                spec: {
                    metricCollectPolicy:       parameter.metricCollectPolicy
                }
        }
        parameter: {
                //+usage=defines the desired state of NodeMetric.
                metricCollectPolicy: *null | {...}
        }
}
