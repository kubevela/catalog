"rabbitmq-operator": {
        alias: ""
        annotations: {}
        attributes: workload: type: "autodetects.core.oam.dev"
        description: "rabbitmq operator component"
        labels: {}
        type: "component"
}

template: {
        output: {
                kind:       "RabbitmqCluster"
                apiVersion: "rabbitmq.com/v1beta1"
                metadata: {
                        name:      context.name
                }
                spec: {
                    image:                              parameter.image
                    replicas:                           parameter.replicas
                    imagePullSecrets:                   parameter.imagePullSecrets
                    service:                            parameter.service
                    persistence:                        parameter.persistence
                    resources:                          parameter.resources
                    affinity:                           parameter.affinity
                    tolerations:                        parameter.tolerations
                    tls:                                parameter.tls
                    rabbitmq:                           parameter.rabbitmq
                    override:                           parameter.override
                    skipPostDeploySteps:                parameter.skipPostDeploySteps
                    terminationGracePeriodSeconds:      parameter.terminationGracePeriodSeconds
                }
        }
        parameter: {
            //+usage=The number of replicas of RabbitMQ nodes. Even numbers are highly discouraged and it is strongly recommended to use odd numbers.
            replicas: *1 | int
            //+usage=The RabbitMQ image reference.
            image: *"" | string
            //+usage=An array of names of Kubernetes secrets, used to access the registry which contains the RabbitMQ image. This is only required for private registries.
            imagePullSecrets: [...]
            //+usage=configure service.
            service: {
                //+usage=The Kubernetes Service type for the RabbitmqCluster Service. This must be ClusterIP, NodePort, or LoadBalancer.
                type: *"ClusterIP" | string
                //+usage=These are annotations on the service. Note that annotations containing kubernetes.io and k8s.io are not filtered at this level.
                annotations: {...}
            }
            //+usage=configure respurces.
            persistence: {
                //+usage=The capacity of the persistent volume, expressed as a Kubernetes resource quantity. Set to `0` to deactivate persistence altogether (this may be convenient in CI/CD and test deloyments that should always start fresh).
                storage: *"10Gi" | string
                //+usage=The name of the Kubernetes StorageClass that will be used to request Persistent Volumes.
                storageClassName: *"standard" | string
            }
            //+usage=configure respurces.
            resources: {
                limits: {
                    //+usage=The CPU units used to calculate the share of CPU time available to the RabbitMQ container per 100 ms.
                    cpu: *"2000m" | string
                    //+usage=The memory limit allowed to be used by RabbitMQ container. The container won't be allowed to use more than this limit.
                    memory: *"2Gi" | string
                }
                requests: {
                    //+usage=The CPU units required by the Kubernetes scheduler for the container running RabbitMQ.
                    cpu: *"1000m" | string
                    //+usage=The memory units required by the Kubernetes scheduler for the container running RabbitMQ.
                    memory: *"2Gi" | string
                }
            }
            //+usage=The Pod affinity and anti-affinity rules.
            affinity: {...}
            //+usage=Pod tolerations that will be applied to RabbitMQ Pods.
            tolerations: [...]
            //+usage=If unset, or set to false, operator will run rabbitmq-queues rebalance all whenever the cluster is updated. When set to true, operator will skip running rabbitmq-queues rebalance all. For more information, see rabbitmq-queues.
            skipPostDeploySteps: *false | bool
            //+usage=TerminationGracePeriodSeconds is the timeout that each rabbitmqcluster pod will have to run the container preStop lifecycle hook to ensure graceful termination. The lifecycle hook checks quorum status of existing quorum queues and synchronization of mirror queues, before safely terminates pods.
            terminationGracePeriodSeconds: *604800 | int
            //+usage=configure tls.
            tls: {
                //+usage=The Secret name used to configure RabbitMQ TLS. The Secret must exist and contain keys `tls.key` and `tls.crt`.
                secretName: *"" | string
                //+usage=The Secret name used to configure RabbitMQ mTLS (used to verify clients' certificates). The Secret must exist and contain key `ca.crt`.
                caSecretName: *"" | string
                //+usage=When set to `true`, only TLS connections are allowed (non-TLS listeners are disabled).
                disableNonTLSListeners: *false | bool
            }
            //+usage=Additional configuration to append to the Cluster Generated configuration. Check Additional Config section for the list of always generated configuration.
            rabbitmq: {
                //+usage=List of plugins to enabled in RabbitMQ. By default, RabbitMQ Cluster Kubernetes Operator enables Prometheus, K8s Peer Discovery and Management plugins.
                additionalPlugins: [...]
                //+usage=Additional configuration to append to the Cluster Generated configuration. Check Additional Config section for the list of always generated configuration.
                additionalConfig: *"" | string
                //+usage=RabbitMQ advanced.config. See https://www.rabbitmq.com/kubernetes/operator/using-operator.html#advanced-config for an example.
                advancedConfig: *"" | string
                //+usage=RabbitMQ uses rabbitmq-env.conf to override the defaults built-in into the RabbitMQ scripts and CLI tools. The value of spec.rabbitmq.envConfig will be written to /etc/rabbitmq/rabbitmq-env.conf.
                envConfig: *"" | string
            }
            //+usage=Arbitrary overrides to the resources created by RabbitMQ Cluster Kubernetes Operator. This feature should be used with great care as overriding essential properties can render a RabbitMQ cluster unusable to applications or unreachable to the Operator. See the Override section to learn more.
            override: {...}
        }
}
