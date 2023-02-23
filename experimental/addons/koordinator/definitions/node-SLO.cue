"koordinator-node-slo": {
        alias: ""
        annotations: {}
        attributes: workload: type: "autodetects.core.oam.dev"
        description: "koordinator node metric component"
        labels: {}
        type: "component"
}

template: {
        output: {
                kind:       "NodeSLO"
                apiVersion: "slo.koordinator.sh/v1alpha1"
                metadata: {
                        name:      context.name
                }
                spec: {
                    resourceUsedThresholdWithBE:        parameter.resourceUsedThresholdWithBE
                    resourceQOSStrategy:                parameter.resourceQOSStrategy
                    cpuBurstStrategy:                   parameter.cpuBurstStrategy
                    systemStrategy:                     parameter.systemStrategy
                    extensions:                         parameter:extensions
                }
        }
        parameter: {
                //+usage=BE pods will be limited if node resource usage overload.
                resourceUsedThresholdWithBE: *null | {...}
                //+usage=QoS config strategy for pods of different qos-class.
                resourceQOSStrategy: *null | {...}
                //+usage=CPU Burst Strategy.
                cpuBurstStrategy: *null | {...}
                //+usage=node global system config.
                systemStrategy: *null | {...}
                //+usage=Third party extensions for NodeSLO.
                extensions: *null | {...}
        }
}
