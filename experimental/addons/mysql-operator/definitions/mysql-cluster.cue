"mysql-cluster": {
        annotations: {}
        attributes: workload: definition: {
                apiVersion: "apps/v1"
                kind:       "Deployment"
        }
        description: ""
        labels: {}
        type: "component"
}

template: {
        output: {
                apiVersion: "storage.k8s.io/v1"
                kind:       "StorageClass"
                metadata: name: parameter.scname
                provisioner:       parameter.provisioner
                volumeBindingMode: "WaitForFirstConsumer"
        }
        outputs: {
                "mysql-cluster-demo": {
                        apiVersion: "mysql.presslabs.org/v1alpha1"
                        kind:       "MysqlCluster"
                        metadata: {
                                name:      parameter.mysqlname
                                namespace: parameter.namespace
                        }
                        spec: {
                                podSpec: initContainers: [{
                                        name: "volume-permissions"
                                        command: ["sh", "-c", "chmod 750 /data/mysql; chown 999:999 /data/mysql"]
                                        image: "busybox"
                                        securityContext: runAsUser: 0
                                        volumeMounts: [{
                                                name:      "data"
                                                mountPath: "/data/mysql"
                                        }]
                                }]
                                secretName: parameter.mysqlname
                                volumeSpec: persistentVolumeClaim: {
                                        accessModes: ["ReadWriteOnce"]
                                        storageClassName: parameter.scname
                                        resources: requests: storage: parameter.storage
                                }
                        }
                }
                "mysql-pv": {
                        apiVersion: "v1"
                        kind:       "PersistentVolume"
                        metadata: name: parameter.pvname
                        spec: {
                                accessModes: ["ReadWriteOnce"]
                                capacity: storage: parameter.storage
                                hostPath: path:    "/data/mysql"
                                storageClassName: parameter.scname
                        }
                }
                "mysql-secret": {
                        apiVersion: "v1"
                        kind:       "Secret"
                        metadata: {
                                name:      parameter.mysqlname
                                namespace: parameter.namespace
                        }
                        data: {
                                DATABASE:      parameter.db
                                PASSWORD:      parameter.passwd
                                ROOT_PASSWORD: parameter.rootpasswd
                                USER:          parameter.user
                        }
                        type: "Opaque"
                }
        }
        parameter: {

            scname:*"mysql-sc"|string
            provisioner:*"kubernetes.io/no-provisioner"|string
            storage:*"2Gi"|string
            pvname:*"mysql-pv"|string

            mysqlname:string
            namespace:string

            db:*"dXNlcmRi"|string
            passwd:*"dXNlcnBhc3Nz"|string
            rootpasswd:*"bm90LXNvLXNlY3VyZQ=="|string
            user:*"dXNlcm5hbWU="|string
        }
}

