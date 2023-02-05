"zookeeper-cluster": {
        alias: ""
        annotations: {}
        attributes: workload: type: "autodetects.core.oam.dev"
        description: "zookeeper cluster component"
        labels: {}
        type: "component"
}

template: {
        output: {
                kind:       "ZookeeperCluster"
                apiVersion: "zookeeper.pravega.io/v1beta1"
                metadata: {
                        name:      context.name
                }
                spec: {
                    replicas:                   parameter.replicas
                    maxUnavailableReplicas:     parameter.maxUnavailableReplicas
                    triggerRollingRestart:      parameter.triggerRollingRestart
                    image:                      parameter.image
                    domainName:                 parameter.domainName
                    kubernetesClusterDomain:    parameter.kubernetesClusterDomain
                    probes:                     parameter.probes
                    labels:                     parameter.labels
                    ports:                      parameter.ports
                    pod:                        parameter.pod
                    clientService:              parameter.clientService
                    headlessService:            parameter.headlessService
                    adminServerService:         parameter.adminServerService
                    config:                     parameter.config
                    storageType:                parameter.storageType
                    persistence:                parameter.persistence
                    ephemeral:                  parameter.ephemeral
                    containers:                 parameter.containers
                    initContainers:             parameter.initContainers
                    volumes:                    parameter.volumes
                    volumeMounts:               parameter.volumeMounts
                }
        }
        parameter: {
                //+usage=the size of the zookeeper cluster.
                replicas: *3 | int
                //+usage=Max unavailable replicas in pdb
                maxUnavailableReplicas: *1 | int
                //+usage=If true, the zookeeper cluster is restarted. After the restart is triggered, this value is auto-reverted to false.
                triggerRollingRestart: *false | bool
                //+usage=Image configuration
                image: {
                        //+usage=Image repository
                        repository: *"pravega/zookeeper" | string
                        //+usage=Image tag
                        tag: *"0.2.14" | string
                        //+usage=Image pull policy
                        pullPolicy: *"IfNotPresent" | string
                }
                //+usage=External host name appended for dns annotation
                domainName: *"" | string
                //+usage=Domain of the kubernetes cluster
                kubernetesClusterDomain: *"cluster.local" | string
                //+usage=Probes configuration
                probes: {
                        //+usage=readiness
                        readiness: {
                            //+usage=Number of seconds after the container has started before readiness probe is initiated.
                            initialDelaySeconds: *10 | int
                            //+usage=Number of seconds in which readiness probe will be performed.
                            periodSeconds: *10 | int
                            //+usage=Number of seconds after which the readiness probe times out.
                            failureThreshold: *3 | int
                            //+usage=Minimum number of consecutive successes for the readiness probe to be considered successful after having failed.
                            successThreshold: *1 | int
                            //+usage=Number of times Kubernetes will retry after a readiness probe failure before restarting the container.
                            timeoutSeconds: *10 | int
                        }
                        //+usage=liveness
                        liveness: {
                            //+usage=Number of seconds after the container has started before liveness probe is initiated.
                            initialDelaySeconds: *10 | int
                            //+usage=Number of seconds in which liveness probe will be performed.
                            periodSeconds: *10 | int
                            //+usage=Number of seconds after which the liveness probe times out.
                            failureThreshold: *3 | int
                            //+usage=Number of seconds after which the liveness probe times out.
                            timeoutSeconds: *10 | int
                        }
                }
                //+usage=Specifies the labels to be attached.
                labels: *{} | {...}
                //+usage=Groups the ports for a zookeeper cluster node for easy access.
                ports: *[] | [...]
                //+usage=Defines the policy to create new pods for the zookeeper cluster.
                pod: *{} | {
                    //+usage=Labels to attach to the pods.
                    labels: *{} | {...}
                    //+usage=Map of key-value pairs to be present as labels in the node in which the pod should run.
                    nodeSelector: *{} | {...}
                    //+usage=Specifies scheduling constraints on pods.
                    affinity: *{} | {...}
                    //+usage=Specifies resource requirements for the container.
                    resources: *{} | {...}
                    //+usage=Specifies the pod's tolerations.
                    tolerations: *[] | [...]
                    //+usage=List of environment variables to set in the container.
                    env: *[] | [...]
                    //+usage=Specifies the annotations to attach to pods.
                    annotations: *{} | {...}
                    //+usage=Specifies the security context for the entire pod.
                    securityContext: *{} | {...}
                    //+usage=Amount of time given to the pod to shutdown normally.
                    terminationGracePeriodSeconds: *30 | int
                    //+usage=Name for the service account.
                    serviceAccountName: *"zookeeper" | string
                    //+usage=ImagePullSecrets is a list of references to secrets in the same namespace to use for pulling any images.
                    imagePullSecrets: *[] | [...]
                }
                //+usage=Defines the policy to create client Service for the zookeeper cluster.
                clientService: *{} | {
                    //+usage=Specifies the annotations to attach to client Service the operator creates.
                    annotations: *{} | {...}
                }
                //+usage=Defines the policy to create headless Service for the zookeeper cluster.
                headlessService: *{} | {
                    //+usage=Specifies the annotations to attach to headless Service the operator creates.
                    annotations: *{} | {...}
                }
                //+usage=Defines the policy to create AdminServer Service for the zookeeper cluster.
                adminServerService: *{} | {
                    //+usage=Specifies the annotations to attach to AdminServer Service the operator creates..
                    annotations: *{} | {...}
                    //+usage=Specifies if LoadBalancer should be created for the AdminServer. True means LoadBalancer will be created, false - only ClusterIP will be used.
                    external: *false | bool
                }
                config: {
                    //+usage=Amount of time (in ticks) to allow followers to connect and sync to a leader.
                    initLimit: *10 | int
                    //+usage=Length of a single tick which is the basic time unit used by Zookeeper (measured in milliseconds).
                    tickTime: *2000 | int
                    //+usage=Amount of time (in ticks) to allow followers to sync with Zookeeper.
                    syncLimit: *2 | int
                    //+usage=Max limit for outstanding requests.
                    globalOutstandingLimit: *1000 | int
                    //+usage=PreAllocSize in kilobytes.
                    preAllocSize: *65536 | int
                    //+usage=The number of transactions recorded in the transaction log before a snapshot can be taken.
                    snapCount: *100000 | int
                    //+usage=The number of committed requests in memory.
                    commitLogCount: *500 | int
                    //+usage=SnapSizeLimitInKb.
                    snapSizeLimitInKb: *4194304 | int
                    //+usage=The total number of concurrent connections that can be made to a zookeeper server.
                    maxCnxns: *0 | int
                    //+usage=The number of concurrent connections that a single client.
                    maxClientCnxns: *60 | int
                    //+usage=The minimum session timeout in milliseconds that the server will allow the client to negotiate.
                    minSessionTimeout: *4000 | int
                    //+usage=The maximum session timeout in milliseconds that the server will allow the client to negotiate.
                    maxSessionTimeout: *40000 | int
                    //+usage=The number of snapshots to be retained.
                    autoPurgeSnapRetainCount: *3 | int
                    //+usage=The time interval in hours for which the purge task has to be triggered.
                    autoPurgePurgeInterval: *1 | int
                    //+usage=Whether Zookeeper server will listen for connections from its peers on all available IP addresses.
                    quorumListenOnAllIPs: *false | bool
                    //+usage=Additional zookeeper coniguration parameters that should be defined in generated zoo.cfg file.
                    additionalConfig: *{} | {...}
                }
                //+usage=Type of storage that can be used it can take either ephemeral or persistence as value.
                storageType: *"storageType" | string
                //+usage=Persistant storage type configuration.
                persistence: {
                    //+usage=Specifies the annotations to attach to pvcs.
                    annotations: *{} | {...}
                    //+usage=Reclaim policy for persistent volumes.
                    reclaimPolicy: *"Delete" | string
                    //+usage=Storage class for persistent volumes.
                    storageClassName: *"" | string
                    //+usage=Size of the volume requested for persistent volumes.
                    volumeSize: *"20Gi" | string
                }
                //+usage=Ephemeral storage type configuration.
                ephemeral: {
                    emptydirvolumesource: {
                        //+usage=What type of storage medium should back the directory.
                        medium: *"" | string
                        //+usage=Total amount of local storage required for the EmptyDir volume.
                        sizeLimit: *"20Gi" | string
                    }
                }
                //+usage=Application containers run with the zookeeper pod.
                containers: [] | [...]
                //+usage=Init Containers to add to the zookeeper pods.
                initContainers: [] | [...]
                //+usage=Named volumes that may be accessed by any container in the pod.
                volumes: [] | [...]
                //+usage=Customized volumeMounts for zookeeper container that can be configured to mount volumes to zookeeper container.
                volumeMounts: [] | [...]
        }
}