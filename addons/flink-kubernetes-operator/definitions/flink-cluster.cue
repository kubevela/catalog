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
                apiVersion: "flink.apache.org/v1beta1"
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
             // +usage=Specify the taskmanager.numberOfTaskSlots
                                nots: *"2"|string
             // +usage=Specify the flink cluster version
                                flinkVersion: *"v1_14"|string
             // +usage=Specify the image for flink cluster to run
                                image: *"flink:latest"|string
             // +usage=Specify the flink cluster name
                                name: string
             // +usage=Specify the namespace for flink cluster to install
                                namespace: string
             // +usage=Specify the uri for the jar of the flink cluster job
                                jarURI: *"local:///opt/flink/examples/streaming/StateMachineExample.jar"|string
             // +usage=Specify the parallelism of the flink cluster job
                                parallelism: *2|int
             // +usage=Specify the upgradeMode of the flink cluster job
                                upgradeMode: *"stateless"| string
             // +usage=Specify the replicas of the flink cluster jobManager
                                replicas: *1|int
             // +usage=Specify the cpu of the flink cluster jobManager
                                jmcpu: *1|int
             // +usage=Specify the memory of the flink cluster jobManager
                                jmmem: *"1024m"|string
             // +usage=Specify the cpu of the flink cluster taskManager
                                tmcpu: *1|int
             // +usage=Specify the memory of the flink cluster taskManager
                                tmmem: *"1024m"|string
        }}
