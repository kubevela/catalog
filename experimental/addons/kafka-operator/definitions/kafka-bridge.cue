"kafka-bridge": {
        alias: ""
        annotations: {}
        attributes: workload: type: "autodetects.core.oam.dev"
        description: "kafka bridge component"
        labels: {}
        type: "component"
}

template: {
        output: {
                kind: "KafkaBridge"
                apiVersion: "kafka.strimzi.io/v1beta2"
                metadata: {
                    name: context.name
                    namespace: context.namespace
                }
                spec: {
                    replicas:               parameter.replicas
                    image:                  parameter.image
                    bootstrapServers:       parameter.bootstrapServers
                    tls:                    parameter.tls
                    authentication:         parameter.authentication
                    http:                   parameter.http
                    adminClient:            parameter.adminClient
                    consumer:               parameter.consumer
                    producer:               parameter.producer
                    resources:              parameter.resources
                    jvmOptions:             parameter.jvmOptions
                    logging:                parameter.logging
                    clientRackInitImage:    parameter.clientRackInitImage
                    rack:                   parameter.rack
                    enableMetrics:          parameter.enableMetrics
                    livenessProbe:          parameter.livenessProbe
                    readinessProbe:         parameter.readinessProbe
                    template:               parameter.template
                    tracing:                parameter.tracing
                }
        }
        parameter: {
                //+usage=The number of pods in the Deployment.
                replicas: *1 | int
                //+usage=The docker image for the pods.
                image: *null | string
                //+usage=A list of host:port pairs for establishing the initial connection to the Kafka cluster.
                bootstrapServers: *"kafka-cluster-kafka-bootstrap:9092" | string
                //+usage=The HTTP related configuration.
                http: *{
                    port: 8080
                } | {...}
                //+usage=TLS configuration for connecting Kafka Bridge to the cluster.
                tls: *null | {...}
                //+usage=Authentication configuration for connecting to the cluster. The type depends on the value of the authentication.type property within the given object, which must be one of [tls, scram-sha-256, scram-sha-512, plain, oauth].
                authentication: *null | {...}
                //+usage=Kafka AdminClient related configuration.
                adminClient: *null | {...}
                //+usage=Kafka consumer related configuration.
                consumer: *null | {...}
                //+usage=Kafka producer related configuration.
                producer: *null | {...}
                //+usage=CPU and memory resources to reserve. For more information, see the external documentation for core/v1 resourcerequirements.
                resources: *null | {...}
                //+usage=Currently not supported JVM Options for pods.
                jvmOptions: *null | {...}
                //+usage=Logging configuration for Kafka Bridge. The type depends on the value of the logging.type property within the given object, which must be one of [inline, external].
                logging: *null | {...}
                //+usage=The image of the init container used for initializing the client.rack.
                clientRackInitImage: *null | string
                //+usage=Configuration of the node label which will be used as the client.rack consumer configuration.
                rack: *null | string
                //+usage=Enable the metrics for the Kafka Bridge. Default is false.
                enableMetrics: *false | bool
                //+usage=Pod liveness checking.
                livenessProbe: *null | {...}
                //+usage=Pod readiness checking.
                readinessProbe: *null | {...}
                //+usage=Template for Kafka Bridge resources. The template allows users to specify how a Deployment and Pod is generated.
                template: *null | {...}
                //+usage=The configuration of tracing in Kafka Bridge. The type depends on the value of the tracing.type property within the given object, which must be one of [jaeger, opentelemetry].
                tracing: *null | {...}
        }
}
