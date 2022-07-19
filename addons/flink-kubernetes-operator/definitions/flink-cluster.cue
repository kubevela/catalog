"flink-cluster": {
        annotations: {}
        attributes: workload: type: "autodetects.core.oam.dev"
        description: "Flink Component."
        labels: {}
        type: "component"
}

template: {
        output: {
                kind:       "ClusterRoleBinding"
                apiVersion: "rbac.authorization.k8s.io/v1"
                metadata: name: parameter.name
                roleRef: {
                        name:     "edit"
                        apiGroup: "rbac.authorization.k8s.io"
                        kind:     "ClusterRole"
                }
                subjects: [{
                        name:      "default"
                        kind:      "ServiceAccount"
                        namespace: parameter.namespace
                }]
        }
        outputs:
                "flink": {
                kind:       "FlinkDeployment"
                apiVersion: "flink.apache.org/v1alpha1"
                metadata: {
                        name:      parameter.name
                        namespace: parameter.namespace
                }
                 spec: {
                        flinkConfiguration: "taskmanager.numberOfTaskSlots": parameter.nots
                        flinkVersion: parameter.flinkVersion
                        image:        parameter.image
                        job: {
                                jarURI:      parameter.jarURI
                                parallelism: parameter.parallelism
                                upgradeMode: parameter.upgradeMode
                        }
                        jobManager: {
                                replicas: parameter.replicas
                                resource: {
                                        cpu:    parameter.jmcpu
                                        memory: parameter.jmmem
                                }
                        }
                        serviceAccount: "default"
                        taskManager: resource: {
                                cpu:    parameter.tmcpu
                                memory: parameter.tmmem
                        }
                }
        }
        parameter: {
                                nots: *"2"|string
                                flinkVersion: *"v1_14"|string
                                image: *"flink:latest"|string
                                name: string
                                namespace: string

                                jarURI: *"local:///opt/flink/examples/streaming/StateMachineExample.jar"|string
                                parallelism: *2|int
                                upgradeMode: *"stateless"| string
                                replicas: *1|int
                                jmcpu: *1|int
                                jmmem: *"1024m"|string

                                tmcpu: *1|int
                                tmmem: *"1024m"|string
        }}
