"kafka-connector": {
        alias: ""
        annotations: {}
        attributes: workload: type: "autodetects.core.oam.dev"
        description: "kafka connect component"
        labels: {}
        type: "component"
}

template: {
        output: {
                kind: "KafkaConnector"
                apiVersion: "kafka.strimzi.io/v1beta2"
                metadata: {
                    name: context.name
                    namespace: context.namespace
                    labels:
                        "strimzi.io/cluster": parameter.connectCluster
                }
                spec: {
                    class:                  parameter.class
                    tasksMax:               parameter.tasksMax
                    autoRestart:            parameter.autoRestart
                    config:                 parameter.config
                    pause:                  parameter.pause
                }
        }
        parameter: {
                //+usage=Type connect cluster name.
                connectCluster: *"kafka-connect" | string
                //+usage=The Class for the Kafka Connector.
                class: *"org.apache.kafka.connect.file.FileStreamSourceConnector" | string
                //+usage=The maximum number of tasks for the Kafka Connector.
                tasksMax: *1 | int
                //+usage=The Kafka Connector configuration. The following properties cannot be set: connector.class, tasks.max.
                config: *{
                    file: "/opt/kafka/LICENSE"
                    topic: "kafka-topic"
                } | {...}
                //+usage=Automatic restart of connector and tasks configuration.
                autoRestart: *null | {...}
                //+usage=Whether the connector should be paused. Defaults to false.
                pause: *null | bool
        }
}
