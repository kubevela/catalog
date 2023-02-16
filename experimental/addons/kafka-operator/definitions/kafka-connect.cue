"kafka-connect": {
        alias: ""
        annotations: {}
        attributes: workload: type: "autodetects.core.oam.dev"
        description: "kafka connect component"
        labels: {}
        type: "component"
}

template: {
        output: {
                kind: "KafkaConnect"
                apiVersion: "kafka.strimzi.io/v1beta2"
                metadata: {
                    name: context.name
                    namespace: context.namespace
                }
                spec: {
                    version:                parameter.version
                    replicas:               parameter.replicas
                    image:                  parameter.image
                    bootstrapServers:       parameter.bootstrapServers
                    tls:                    parameter.tls
                    authentication:         parameter.authentication
                    config:                 parameter.config
                    resources:              parameter.resources
                    livenessProbe:          parameter.livenessProbe
                    readinessProbe:         parameter.readinessProbe
                    jvmOptions:             parameter.jvmOptions
                    jmxOptions:             parameter.jmxOptions
                    logging:                parameter.logging
                    clientRackInitImage:    parameter.clientRackInitImage
                    rack:                   parameter.rack
                    tracing:                parameter.tracing
                    template:               parameter.template
                    externalConfiguration:  parameter.externalConfiguration
                    build:                  parameter.build
                    metricsConfig:          parameter.metricsConfig
                }
        }
        parameter: {
                //+usage=The Kafka Connect version. Defaults to 3.3.2. Consult the user documentation to understand the process required to upgrade or downgrade the version.
                version: *"3.3.2" | string
                //+usage=The number of pods in the Kafka Connect group.
                replicas: *1 | int
                //+usage=Bootstrap servers to connect to. This should be given as a comma separated list of <hostname>:_<port>_ pairs.
                bootstrapServers: *"kafka-cluster-kafka-bootstrap:9093" | string
                //+usage=TLS configuration.
                tls: *{
                    trustedCertificates: [
                        {
                            secretName: "kafka-cluster-cluster-ca-cert"
                            certificate: "ca.crt"
                        }
                    ]
                } | {...}
                //+usage=The Kafka Connect configuration. Properties with the following prefixes cannot be set: ssl., sasl., security., listeners, plugin.path, rest., bootstrap.servers, consumer.interceptor.classes, producer.interceptor.classes (with the exception of: ssl.endpoint.identification.algorithm, ssl.cipher.suites, ssl.protocol, ssl.enabled.protocols).
                config: *{
                    "group.id": "connect-cluster"
                    "offset.storage.topic": "connect-cluster-offsets"
                    "config.storage.topic": "connect-cluster-configs"
                    "status.storage.topic": "connect-cluster-status"
                    "config.storage.replication.factor": -1
                    "offset.storage.replication.factor": -1
                    "status.storage.replication.factor": -1
                } | {...}
                //+usage=Configures how the Connect container image should be built. Optional.
                build: *null | {...}
                //+usage=Metrics configuration. The type depends on the value of the metricsConfig.type property within the given object, which must be one of [jmxPrometheusExporter].
                metricsConfig: *null | {...}
                //+usage=The docker image for the pods.
                image: *null | string
                //+usage=Authentication configuration for Kafka Connect. The type depends on the value of the authentication.type property within the given object, which must be one of [tls, scram-sha-256, scram-sha-512, plain, oauth].
                authentication: *null | {...}
                //+usage=Pod liveness checking.
                livenessProbe: *null | {...}
                //+usage=Pod readiness checking.
                readinessProbe: *null | {...}
                //+usage=JVM Options for pods.
                jvmOptions: *null | {...}
                //+usage=JMX Options for Kafka brokers.
                jmxOptions: *null | {...}
                //+usage=The maximum limits for CPU and memory resources and the requested initial resources. For more information, see the external documentation for core/v1 resourcerequirements.
                resources: *null | {...}
                //+usage=Logging configuration for Kafka. The type depends on the value of the logging.type property within the given object, which must be one of [inline, external].
                logging: *null | {...}
                //+usage=The image of the init container used for initializing the client.rack.
                clientRackInitImage: *null | string
                //+usage=Configuration of the node label which will be used as the client.rack consumer configuration.
                rack: *null | {...}
                //+usage=The configuration of tracing in Kafka Connect. The type depends on the value of the tracing.type property within the given object, which must be one of [jaeger, opentelemetry].
                tracing: *null | {...}
                //+usage=Template for Kafka Connect and Kafka Mirror Maker 2 resources. The template allows users to specify how the Deployment, Pods and Service are generated.
                template: *null | {...}
                //+usage=Pass data from Secrets or ConfigMaps to the Kafka Connect pods and use them to configure connectors.
                externalConfiguration: *null | {...}
        }
}
