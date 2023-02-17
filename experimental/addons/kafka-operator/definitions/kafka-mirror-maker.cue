"kafka-mirror-maker": {
        alias: ""
        annotations: {}
        attributes: workload: type: "autodetects.core.oam.dev"
        description: "kafka mirror maker component"
        labels: {}
        type: "component"
}

template: {
        output: {
                kind: "KafkaMirrorMaker"
                apiVersion: "kafka.strimzi.io/v1beta2"
                metadata: {
                    name: context.name
                    namespace: context.namespace
                }
                spec: {
                    version:                parameter.version
                    replicas:               parameter.replicas
                    image:                  parameter.image
                    consumer:               parameter.consumer
                    producer:               parameter.producer
                    resources:              parameter.resources
                    whitelist:              parameter.whitelist
                    include:                parameter.include
                    jvmOptions:             parameter.jvmOptions
                    logging:                parameter.logging
                    metricsConfig:          parameter.metricsConfig
                    tracing:                parameter.tracing
                    template:               parameter.template
                    livenessProbe:          parameter.livenessProbe
                    readinessProbe:         parameter.readinessProbe
                }
        }
        parameter: {
                //+usage=The Kafka MirrorMaker version. Defaults to 3.3.2. Consult the documentation to understand the process required to upgrade or downgrade the version.
                version: *"3.3.2" | string
                //+usage=The number of pods in the Deployment.
                replicas: *1 | int
                //+usage=List of topics which are included for mirroring. This option allows any regular expression using Java-style regular expressions. Mirroring two topics named A and B is achieved by using the expression A|B. Or, as a special case, you can mirror all topics using the regular expression *. You can also specify multiple regular expressions separated by commas.
                include: *".*" | string
                //+usage=Configuration of source cluster.
                consumer: *null | {...}
                //+usage=Configuration of target cluster.
                producer: *null | {...}
                //+usage=The docker image for the pods.
                image: *null | string
                //+usage=CPU and memory resources to reserve. For more information, see the external documentation for core/v1 resourcerequirements.
                resources: *null | {...}
                //+usage=The whitelist property has been deprecated, and should now be configured using spec.include. List of topics which are included for mirroring. This option allows any regular expression using Java-style regular expressions. Mirroring two topics named A and B is achieved by using the expression A|B. Or, as a special case, you can mirror all topics using the regular expression *. You can also specify multiple regular expressions separated by commas.
                whitelist: *null | string
                //+usage=JVM Options for pods.
                jvmOptions: *null | {...}
                //+usage=Logging configuration for MirrorMaker. The type depends on the value of the logging.type property within the given object, which must be one of [inline, external].
                logging: *null | {...}
                //+usage=Metrics configuration. The type depends on the value of the metricsConfig.type property within the given object, which must be one of [jmxPrometheusExporter].
                metricsConfig: *null | {...}
                //+usage=The configuration of tracing in Kafka MirrorMaker. The type depends on the value of the tracing.type property within the given object, which must be one of [jaeger, opentelemetry].
                tracing: *null | {...}
                //+usage=Template to specify how Kafka MirrorMaker resources, Deployments and Pods, are generated.
                template: *null | {...}
                //+usage=Pod liveness checking.
                livenessProbe: *null | {...}
                //+usage=Pod readiness checking.
                readinessProbe: *null | {...}
        }
}
