"s3-connection": {
        alias: ""
        annotations: {}
        attributes: workload: type: "autodetects.core.oam.dev"
        description: "s3 connection component"
        labels: {}
        type: "component"
}

template: {
        output: {
                kind:       "S3Connection"
                apiVersion: "s3.stackable.tech/v1alpha1"
                metadata: {
                        name:      context.name
                }
                spec: {
                    host:                   parameter.host
                    port:                   parameter.port
                    accessStyle:            parameter.accessStyle
                    credentials:            parameter.credentials
                }
        }
        parameter: {
                //+usage=the domain name of the host of the object store, such as s3.west.provider.com.
                host: *null | string
                //+usage=a port such as 80 or 4242.
                port: *null | int
                //+usage=Optional. Can be either "VirtualHosted" (default) or "Path".
                accessStyle: *"VirtualHosted" | string
                //+usage=contains a secretClass.
                credentials: {
                    //+usage=a reference to a SecretClass resource
                    secretClass: *null | string
                }
        }
}
