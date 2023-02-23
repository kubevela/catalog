"koordinator-device": {
        alias: ""
        annotations: {}
        attributes: workload: type: "autodetects.core.oam.dev"
        description: "koordinator device component"
        labels: {}
        type: "component"
}

template: {
        output: {
                kind:       "Device"
                apiVersion: "scheduling.koordinator.sh/v1alpha1"
                metadata: {
                        name:      context.name
                }
                spec: {
                    devices:       parameter.devices
                }
        }
        parameter: {
                devices: *null | [...]
        }
}
