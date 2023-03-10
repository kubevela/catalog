"koordinator-reservation": {
        alias: ""
        annotations: {}
        attributes: workload: type: "autodetects.core.oam.dev"
        description: "koordinator reservation component"
        labels: {}
        type: "component"
}

template: {
        output: {
                kind:       "Reservation"
                apiVersion: "scheduling.koordinator.sh/v1alpha1"
                metadata: {
                        name:      context.name
                }
                spec: {
                    template:                       parameter.template
                    owners:                         parameter.owners
                    ttl:                            parameter.ttl
                    expires:                        parameter.expires
                    preAllocation:                  parameter.preAllocation
                    allocateOnce:                   parameter.allocateOnce
                }
        }
        parameter: {
                //+usage=Template defines the scheduling requirements (resources, affinities, images, ...) processed by the scheduler just like a normal pod. If the template.spec.nodeName is specified, the scheduler will not choose another node but reserve resources on the specified node.
                template: *null | {...}
                //+usage=Specify the owners who can allocate the reserved resources. Multiple owner selectors and ORed.
                owners: *null | [...]
                //+usage=Time-to-Live period for the reservation. expires and ttl are mutually exclusive. Defaults to 24h. Set 0 to disable expiration.
                ttl: *"24h" | string
                //+usage=Expired timestamp when the reservation is expected to expire. If both `expires` and `ttl` are set, `expires` is checked first. expires and ttl are mutually exclusive. Defaults to being set dynamically at runtime based on the `ttl`.
                expires: *null | string
                //+usage=By default, the resources requirements of reservation (specified in `template.spec`) is filtered by whether the node has sufficient free resources (i.e. Reservation Request <  Node Free). When `preAllocation` is set, the scheduler will skip this validation and allow overcommitment. The scheduled reservation would be waiting to be available until free resources are sufficient.
                preAllocation: *null | bool
                //+usage=By default, reserved resources are always allocatable as long as the reservation phase is Available. When `AllocateOnce` is set, the reserved resources are only available for the first owner who allocates successfully and are not allocatable to other owners anymore.
                allocateOnce: *null | bool
        }
}
