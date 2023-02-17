"kafka-user": {
        alias: ""
        annotations: {}
        attributes: workload: type: "autodetects.core.oam.dev"
        description: "kafka user component"
        labels: {}
        type: "component"
}

template: {
        output: {
                kind: "KafkaUser"
                apiVersion: "kafka.strimzi.io/v1beta2"
                metadata: {
                    name: context.name
                    namespace: context.namespace
                }
                spec: {
                    authentication:         parameter.authentication
                    authorization:          parameter.authorization
                    quotas:                 parameter.quotas
                    template:               parameter.template
                }
        }
        parameter: {
                //+usage=Authentication mechanism enabled for this Kafka user. The supported authentication mechanisms are scram-sha-512, tls, and tls-external.
                authentication: *{
                    type: "tls"
                } | {...}
                //+usage=Authorization rules for this Kafka user. The type depends on the value of the authorization.type property within the given object, which must be one of [simple].
                authorization: *{
                    type: "simple"
                    acls: [
                        {
                            resource: {
                                type: "topic"
                                name: "kafka-topic"
                                patternType: "literal"
                            }
                            operation: "Read"
                            host: "*"
                        },
                        {
                            resource: {
                                type: "topic"
                                name: "kafka-topic"
                                patternType: "literal"
                            }
                            operation: "Describe"
                            host: "*"
                        },
                        {
                            resource: {
                                type: "topic"
                                name: "kafka-topic"
                                patternType: "literal"
                            }
                            operation: "Write"
                            host: "*"
                        },
                        {
                            resource: {
                                type: "topic"
                                name: "kafka-topic"
                                patternType: "literal"
                            }
                            operation: "Create"
                            host: "*"
                        },
                        {
                            resource: {
                                type: "group"
                                name: "kafka-group"
                                patternType: "literal"
                            }
                            operation: "Read"
                            host: "*"
                        },
                    ]
                } | {...}
                //+usage=Quotas on requests to control the broker resources used by clients. Network bandwidth and request rate quotas can be enforced.Kafka documentation for Kafka User quotas can be found at http://kafka.apache.org/documentation/#design_quotas.
                quotas: *null | {...}
                //+usage=Template to specify how Kafka User Secrets are generated.
                template: *null| string
        }
}
