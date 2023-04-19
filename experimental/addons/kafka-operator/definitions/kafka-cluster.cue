"kafka-cluster": {
        alias: ""
        annotations: {}
        attributes: workload: type: "autodetects.core.oam.dev"
        description: "kafka cluster component"
        labels: {}
        type: "component"
}

template: {
        output: {
                kind: "Kafka"
                apiVersion: "kafka.strimzi.io/v1beta2"
                metadata: {
                    name: context.name
                    namespace: context.namespace
                }
                spec: {
                    kafka: parameter.kafka
                    zookeeper: parameter.zookeeper
                    entityOperator: parameter.entityOperator
                    kafkaExporter: parameter.kafkaExporter
                    cruiseControl:  parameter.cruiseControl
                    clusterCa: parameter.clusterCa
                    clientsCa: parameter.clientsCa
                    jmxTrans: parameter.jmxTrans
                    maintenanceTimeWindows: parameter.maintenanceTimeWindows
                }
        }
        parameter: {
                //+usage=configure kafka cluster.
                kafka: {
                    //+usage=The kafka broker version. Defaults to 3.3.2.
                    version: *"3.3.2" | string
                    //+usage=The number of pods in the cluster.
                    replicas: *3 | int
                    //+usage=Configures listeners of Kafka brokers.
                    listeners: *[
                        {
                            //+usage=Name of the listener.
                            name: "plain"
                            //+usage=Port number used by the listener inside Kafka.
                            port: 9092
                            //+usage=Type of the listener. Currently the supported types are internal, route, loadbalancer, nodeport and ingress.
                            type: "internal"
                            //+usage=Enables TLS encryption on the listener. This is a required property.
                            tls: false
                        },
                        {
                            name: "tls"
                            port: 9093
                            type: "internal"
                            tls: true
                        }
                    ] | [...]
                    //+usage=Kafka broker config properties with the some prefixes cannot be set, so for that use config to set. for more https://strimzi.io/docs/operators/latest/configuring.html#type-KafkaClusterSpec-schema-reference
                    config: *{
                        "offsets.topic.replication.factor": 1
                        "transaction.state.log.replication.factor": 1
                        "transaction.state.log.min.isr": 1
                        "default.replication.factor": 1
                        "min.insync.replicas": 1
                        "inter.broker.protocol.version": "3.3"
                    } | {...}
                    //+usage=Storage configuration (disk). Cannot be updated. The type depends on the value of the storage.type property within the given object, which must be one of [ephemeral, persistent-claim, jbod].
                    storage: *{
                        type: "ephemeral"
                    } | {...}
                    //+usage=The docker image for the pods. The default value depends on the configured Kafka.spec.kafka.version.
                    image: *null | string
                    //+usage=Authorization configuration for Kafka brokers. The type depends on the value of the authorization.type property within the given object, which must be one of [simple, opa, keycloak, custom].
                    authorization: *null | {...}
                    //+usage=The image of the init container used for initializing the broker.rack.
                    brokerRackInitImage: *null | string
                    //+usage=Configuration of the broker.rack broker config.
                    rack: *null | {...}
                    //+usage=Pod liveness checking.
                    livenessProbe: *null | {...}
                    //+usage=Pod readiness checking.
                    readinessProbe: *null | {...}
                    //+usage=JVM Options for pods.
                    jvmOptions: *null | {...}
                    //+usage=JMX Options for Kafka brokers.
                    jmxOptions: *null | {...}
                    //+usage=CPU and memory resources to reserve. For more information, see the https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#resourcerequirements-v1-core
                    resources: *null | {...}
                    //+usage=Metrics configuration. The type depends on the value of the metricsConfig.type property within the given object, which must be one of [jmxPrometheusExporter].
                    metricsConfig: *null | {...}
                    //+usage=Logging configuration for Kafka. The type depends on the value of the logging.type property within the given object, which must be one of [inline, external].
                    logging: *null | {...}
                    //+usage=Template for Kafka cluster resources. The template allows users to specify how the StatefulSet, Pods, and Services are generated.
                    template: *null | {...}
                }

                //+usage=configure zookeeper.
                zookeeper: {
                    //+usage=The number of pods in the cluster.
                    replicas: *3 | int
                    //+usage=Storage configuration (disk). Cannot be updated. The type depends on the value of the storage.type property within the given object, which must be one of [ephemeral, persistent-claim].
                    storage: *{
                        type: "ephemeral"
                    } | {...}
                    //+usage=The docker image for the pods.
                    image: *null | string
                    //+usage=The ZooKeeper broker config. Properties with the some prefixes cannot be set, so for that use config to set. for more https://strimzi.io/docs/operators/latest/configuring.html#type-ZookeeperClusterSpec-schema-reference
                    config: *null | {...}
                    //+usage=Pod liveness checking.
                    livenessProbe: *null | {...}
                    //+usage=Pod readiness checking.
                    readinessProbe: *null | {...}
                    //+usage=JVM Options for pods.
                    jvmOptions: *null | {...}
                    //+usage=JMX Options for Zookeeper nodes.
                    jmxOptions: *null | {...}
                    //+usage=CCPU and memory resources to reserve. For more information, see the external documentation for core/v1 resourcerequirements.
                    resources: *null | {...}
                    //+usage=Metrics configuration. The type depends on the value of the metricsConfig.type property within the given object, which must be one of [jmxPrometheusExporter].
                    metricsConfig: *null | {...}
                    //+usage=Logging configuration for ZooKeeper. The type depends on the value of the logging.type property within the given object, which must be one of [inline, external].
                    logging: *null | {...}
                    //+usage=Template for ZooKeeper cluster resources. The template allows users to specify how the StatefulSet, Pods, and Services are generated.
                    template: *null | {...}
                }

                //+usage=configure entity operator.
                entityOperator: {
                    //+usage=Configuration of the Topic Operator.
                    topicOperator: *{} | {...}
                    //+usage=Configuration of the User Operator.
                    userOperator: *{} | {...}
                    //+usage=TLS sidecar configuration.
                    tlsSidecar: *null | {...}
                    //+usage=Template for Entity Operator resources. The template allows users to specify how a Deployment and Pod is generated.
                    template: *null | {...}
                }

                //+usage=configure kafka exporter.
                kafkaExporter: *null | {...}

                //+usage=Configuration of the cluster certificate authority.
                clusterCa: *null | {...}

                //+usage=Configuration of the clients certificate authority.
                clientsCa: *null | {...}

                //+usage=Configuration for Cruise Control deployment. Deploys a Cruise Control instance when specified.
                cruiseControl: *null | {...}

                //+usage=The jmxTrans property has been deprecated. JMXTrans is deprecated and will be removed in Strimzi 0.35.0 Configuration for JmxTrans. When the property is present a JmxTrans deployment is created for gathering JMX metrics from each Kafka broker. For more information see https://github.com/jmxtrans/jmxtrans.
                jmxTrans: *null | {...}

                //+usage=A list of time windows for maintenance tasks (that is, certificates renewal). Each time window is defined by a cron expression.
                maintenanceTimeWindows: *null | [...]
        }
}
