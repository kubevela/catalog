"kafka-rebalance": {
        alias: ""
        annotations: {}
        attributes: workload: type: "autodetects.core.oam.dev"
        description: "kafka rebalance component"
        labels: {}
        type: "component"
}

template: {
        output: {
                kind: "KafkaRebalance"
                apiVersion: "kafka.strimzi.io/v1beta2"
                metadata: {
                    name: context.name
                    namespace: context.namespace
                    labels:
                        "strimzi.io/cluster": parameter.cluster
                }
                spec: {
                    mode:                                       parameter.mode
                    brokers:                                    parameter.brokers
                    goals:                                      parameter.goals
                    skipHardGoalCheck:                          parameter.skipHardGoalCheck
                    rebalanceDisk:                               parameter.rebalanceDisk
                    excludedTopics:                             parameter.excludedTopics
                    concurrentPartitionMovementsPerBroker:      parameter.concurrentPartitionMovementsPerBroker
                    concurrentIntraBrokerPartitionMovements:    parameter.concurrentIntraBrokerPartitionMovements
                    concurrentLeaderMovements:                  parameter.concurrentLeaderMovements
                    replicationThrottle:                        parameter.replicationThrottle
                    replicaMovementStrategies:                  parameter.replicaMovementStrategies
                }
        }
        parameter: {
                cluster: *"kafka-cluster" | string
                //+usage=Mode to run the rebalancing. The supported modes are full, add-brokers, remove-brokers. If not specified, the full mode is used by default.
                mode: *null | string
                //+usage=The list of newly added brokers in case of scaling up or the ones to be removed in case of scaling down to use for rebalancing. This list can be used only with rebalancing mode add-brokers and removed-brokers. It is ignored with full mode.
                brokers: *null | [...]
                //+usage=A list of goals, ordered by decreasing priority, to use for generating and executing the rebalance proposal. The supported goals are available at https://github.com/linkedin/cruise-control#goals. If an empty goals list is provided, the goals declared in the default.goals Cruise Control configuration parameter are used.
                goals: *null | [...]
                //+usage=Whether to allow the hard goals specified in the Kafka CR to be skipped in optimization proposal generation. This can be useful when some of those hard goals are preventing a balance solution being found. Default is false.
                skipHardGoalCheck: *null | bool
                //+usage=Enables intra-broker disk balancing, which balances disk space utilization between disks on the same broker. Only applies to Kafka deployments that use JBOD storage with multiple disks. When enabled, inter-broker balancing is disabled. Default is false.
                rebalanceDisk: *null| bool
                //+usage=A regular expression where any matching topics will be excluded from the calculation of optimization proposals. This expression will be parsed by the java.util.regex.Pattern class; for more information on the supported format consult the documentation for that class.
                excludedTopics: *null | string
                //+usage=The upper bound of ongoing partition replica movements going into/out of each broker. Default is 5.
                concurrentPartitionMovementsPerBroker: *null | int
                //+usage=The upper bound of ongoing partition replica movements between disks within each broker. Default is 2.
                concurrentIntraBrokerPartitionMovements: *null | int
                //+usage=The upper bound of ongoing partition leadership movements. Default is 1000.
                concurrentLeaderMovements: *null | int
                //+usage=The upper bound, in bytes per second, on the bandwidth used to move replicas. There is no limit by default.
                replicationThrottle: *null | int
                //+usage=A list of strategy class names used to determine the execution order for the replica movements in the generated optimization proposal. By default
                replicaMovementStrategies: *null | [...]
        }
}
