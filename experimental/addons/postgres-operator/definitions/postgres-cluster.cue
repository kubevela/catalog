"postgres-cluster": {
        alias: ""
        annotations: {}
        attributes: workload: type: "autodetects.core.oam.dev"
        description: "postgres cluster component"
        labels: {}
        type: "component"
}

template: {
        output: {
                kind:       "postgresql"
                apiVersion: "acid.zalan.do/v1"
                metadata: {
                        name:      context.name
                        // default namespace will be prod
                }
                spec: {
                        dockerImage: parameter.image //ghcr.io/zalando/spilo-15:2.1-p9
                        numberOfInstances: parameter.replicas //By default it's 2
                        teamId: parameter.teamId
                        postgresql: parameter.postgresql
                        databases: {
                            foo: "zalando"      // dbname: owner
                        }
                        preparedDatabases: {
                                bar: {
                                        defaultUsers: true
                                        extensions: {
                                                pg_partman: "public"
                                                pgcrypto: "public"
                                        }
                                        schemas: {
                                                data: {}
                                                history: {
                                                        defaultRoles: true
                                                        defaultUsers: false
                                                }
                                        }
                                }
                        }
                        users: { // Application/Robot users
                            zalando: ["superuser", "createdb"]     // database owner
                            foo_user: []        // role for application foo
                        }
                        enableMasterLoadBalancer: parameter.enableMasterLoadBalancer
                        enableReplicaLoadBalancer: parameter.enableReplicaLoadBalancer
                        enableConnectionPooler: parameter.enableConnectionPooler
                        enableReplicaConnectionPooler: parameter.enableReplicaConnectionPooler
                        enableMasterPoolerLoadBalancer: parameter.enableReplicaConnectionPooler
                        enableReplicaPoolerLoadBalancer: parameter.enableReplicaPoolerLoadBalancer
                        allowedSourceRanges:  [       // load balancers' source ranges for both master and replica services
                            "127.0.0.1/32"
                        ]
                        volume: parameter.volume
                        additionalVolumes: [
                                {
                                        name: "empty"
                                        mountPath: "/opt/empty"
                                        targetContainers: [
                                                "all"
                                        ]
                                        volumeSource: {
                                                emptyDir: {}
                                        }
                                }
                        ]
                        enableShmVolume: parameter.enableShmVolume
                        resources: parameter.resources
                        patroni: parameter.patroni
                        ttl: parameter.ttl
                        loop_wait: parameter.loopWait
                        retry_timeout: parameter.retryTimeout
                        synchronous_mode: parameter.synchronousMode
                        synchronous_mode_strict: parameter.synchronousModeStrict
                        synchronous_node_count: parameter.synchronousNodeCount
                        maximum_lag_on_failover: 33554432
                        initContainers: [
                                {
                                        name: "date"
                                        image: "busybox"
                                        command: [ "/bin/date" ]
                                }
                        ]
                        // Custom TLS certificate. Disabled unless tls.secretName has a value.
                        tls: parameter.tls
                }
        }
        parameter: {
                //+usage=configure postgresql.
                postgresql: {
                        //+usage=the version of the postgresql to be used.
                        version: *"15" | string
                        parameters: {
                                // Expert section
                                shared_buffers: *"32MB" | string
                                max_connections: *"10" | string
                                log_statement: *"all" | string
                        }
                }
        	//+usage=the size of the postgres cluster.
        	replicas: *2 | int
                //+usage=set team Id.
                teamId: *"acid" | string
        	//+usage=the image of the spilo.
        	image: *"ghcr.io/zalando/spilo-15:2.1-p9" | string
                //+usage=configure volume.
                volume: {
                        //+usage=the size of the volume used of postgres.
                        size: *"1Gi" | string
                }
                //+usage=configure patroni.
                patroni: {
                        failsafe_mode: *false | bool
                        initdb: {
                                encoding: *"UTF8" | string
                                locale: *"en_US.UTF-8" | string
                                "data-checksums": *"true" | string
                        }
                }
                //+usage=enable SHM volume if set true.                
                enableShmVolume: *true | bool
                //+usage=enable master as load balancer if set true.
                enableMasterLoadBalancer: *false | bool
                //+usage=enable replica as load balancer if set true.
                enableReplicaLoadBalancer: *false | bool
                //+usage=enable/disable connection pooler deployment.
                enableConnectionPooler: *false | bool
                //+usage=set to enable connection pooler for replica service.
                enableReplicaConnectionPooler: *false | bool
                //+usage=set to enable master pooler as load balancer.
                enableMasterPoolerLoadBalancer: *false | bool
                //+usage=set to enable replica pooler as load balancer.
                enableReplicaPoolerLoadBalancer: *false | bool
                //+usage=set ttl(Time to live) by dedault it's 30 days.
                ttl: *30 | int
                //+usage=set loop wait time by dedault it's 10.
                loopWait: *10 | int
                //+usage=set retry timeout by dedault it's 10.
                retryTimeout: *10 | int
                //+usage=set to enable synchronous mode.
                synchronousMode: *false | bool
                //+usage=set to enable synchronous mode strictly.
                synchronousModeStrict: *false | bool
                //+usage=set how many nodes to be synchronized.
                synchronousNodeCount: *1 | int
                //+usage=configure resources.
                resources: {
                        requests: {
                                cpu: *"10m" | string
                                memory: *"100Mi" | string
                        }
                        limits: {
                                cpu: *"500m" | string
                                memory: *"500Mi" | string
                        }
                }
                //+usage=configure custom TLS.
                tls: {
                        //+usage=sets custom TLS secret name, It should correspond to a Kubernetes Secret resource to load.
                        secretName: *"" | string
                        //+usage=sets custom TLS certificate file.
                        certificateFile: *"tls.crt" | string
                        //+usage=sets custom TLS private key file.
                        privateKeyFile: *"tls.key" | string
                        //+usage=optionally configure Postgres with a CA certificate.
                        caFile: *"" | string
                        //+usage=optionally the ca.crt can come from this secret instead.
                        caSecretName: *"" | string
                }
        }
}
