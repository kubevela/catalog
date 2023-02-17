"kafka-topic": {
        alias: ""
        annotations: {}
        attributes: workload: type: "autodetects.core.oam.dev"
        description: "kafka topic component"
        labels: {}
        type: "component"
}

template: {
        output: {
                kind: "KafkaTopic"
                apiVersion: "kafka.strimzi.io/v1beta2"
                metadata: {
                    name: context.name
                    namespace: context.namespace
                }
                spec: {
                    partitions:             parameter.partitions
                    replicas:               parameter.replicas
                    config:                 parameter.config
                    topicName:              parameter.topicName
                }
        }
        parameter: {
                //+usage=The number of partitions the topic should have. This cannot be decreased after topic creation. It can be increased after topic creation, but it is important to understand the consequences that has, especially for topics with semantic partitioning. When absent this will default to the broker configuration for num.partitions.
                partitions: *10 | int
                //+usage=The number of replicas the topic should have. When absent this will default to the broker configuration for default.replication.factor.
                replicas: *3 | int
                //+usage=The topic configuration.
                config: *{
                    "retention.ms": 604800000
                    "segment.bytes": 1073741824
                } | {...}
                //+usage=The name of the topic. When absent this will default to the metadata.name of the topic. It is recommended to not set this unless the topic name is not a valid Kubernetes resource name.
                topicName: *null | string
        }
}
