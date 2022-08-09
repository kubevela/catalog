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
             // +usage=Specify the taskmanager.numberOfTaskSlots, e.g "2"
                                nots: string
             // +usage=Specify the flink cluster version, e.g "v1_14"
                                flinkVersion: string
             // +usage=Specify the image for flink cluster to run, e.g "flink:latest"
                                image: string
             // +usage=Specify the flink cluster name
                                name: string
             // +usage=Specify the namespace for flink cluster to install
                                namespace: string
             // +usage=Specify the uri for the jar of the flink cluster job, e.g "local:///opt/flink/examples/streaming/StateMachineExample.jar"
                                jarURI: string
             // +usage=Specify the parallelism of the flink cluster job, e.g 2
                                parallelism: int
             // +usage=Specify the upgradeMode of the flink cluster job, e.g "stateless"
                                upgradeMode: string
             // +usage=Specify the replicas of the flink cluster jobManager, e.g 1
                                replicas: int
             // +usage=Specify the cpu of the flink cluster jobManager, e.g 1
                                jmcpu: int
             // +usage=Specify the memory of the flink cluster jobManager, e.g "1024m"
                                jmmem: string
             // +usage=Specify the cpu of the flink cluster taskManager, e.g 1
                                tmcpu: int
             // +usage=Specify the memory of the flink cluster taskManager, e.g "1024m"
                                tmmem: string
        }}
