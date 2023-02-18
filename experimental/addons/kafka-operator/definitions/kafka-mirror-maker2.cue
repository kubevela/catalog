"kafka-mirror-maker2": {
        alias: ""
        annotations: {}
        attributes: workload: type: "autodetects.core.oam.dev"
        description: "kafka mirror maker 2 component"
        labels: {}
        type: "component"
}

template: {
        output: {
                kind: "KafkaMirrorMaker2"
                apiVersion: "kafka.strimzi.io/v1beta2"
                metadata: {
                    name: context.name
                    namespace: context.namespace
                }
                spec: {
                    version:                parameter.version
                    replicas:               parameter.replicas
                    image:                  parameter.image
                    connectCluster:         parameter.connectCluster
                    clusters                parameter.clusters
                    mirrors:                parameter.mirrors
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
                    metricsConfig:          parameter.metricsConfig
                }
        }
        parameter: {
                //+usage=The Kafka Connect version. Defaults to 3.3.2. Consult the user documentation to understand the process required to upgrade or downgrade the version.
                version: *"3.3.2" | string
                //+usage=The number of pods in the Kafka Connect group.
                replicas: *1 | int
                //+usage=The docker image for the pods.
                image: *null | string
                //+usage=The cluster alias used for Kafka Connect. The alias must match a cluster in the list at spec.clusters.
                connectCluster: *"kafka-connect" | string
                //+usage=Kafka clusters for mirroring.
                clusters: *null| [...]
                //+usage=Configuration of the MirrorMaker 2.0 connectors.
                mirrors: *null | [...]
                //+usage=The maximum limits for CPU and memory resources and the requested initial resources. For more information, see the external documentation for core/v1 resourcerequirements.
                resources: *null | {...}
                //+usage=Pod liveness checking.
                livenessProbe: *null | {...}
                //+usage=Pod readiness checking.
                readinessProbe: *null | {...}
                //+usage=JVM Options for pods.
                jvmOptions: *null | {...}
                //+usage=JMX Options.
                jmxOptions: *null | {...}
                //+usage=Logging configuration for Kafka Connect. The type depends on the value of the logging.type property within the given object, which must be one of [inline, external].
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
                //+usage=Metrics configuration. The type depends on the value of the metricsConfig.type property within the given object, which must be one of [jmxPrometheusExporter].
                metricsConfig: *null | {...}
        }
}
