"mongodb-standalone": {
        alias: ""
        annotations: {}
				attributes: workload: type: "autodetects.core.oam.dev"
        description: "mongodb standalone component"
        labels: {}
        type: "component"
}

template: {
        output: {
                apiVersion: "v1"
                kind:       "Secret"
                metadata: {
                        name:      context.name//"mongodb-secret"
                        namespace: context.namespace//"default"
                }
                stringData: password: parameter.password//"abc123456"
                type: "Opaque"
        }
        outputs: mongodb: {
                apiVersion: "opstreelabs.in/v1alpha1"
                kind:       "MongoDB"
                metadata: {
                        name:      context.name//"mongodb"
                        namespace: context.namespace//"default"
                }
                spec: {
                        kubernetesConfig: {
                                image:           parameter.image//"quay.io/opstree/mongo:v5.0.6"
                                imagePullPolicy: parameter.imagePullPolicy//"IfNotPresent"
                                securityContext: fsGroup: 1001
                        }
                        mongoDBSecurity: {
                                mongoDBAdminUser: parameter.mongoDBAdminUser//"admin"
                                secretRef: {
                                        name: context.name//"mongodb-secret"
                                        key:  "password"
                                }
                        }
                        storage: {
                                accessModes: ["ReadWriteOnce"]
                                storageClass: parameter.storageClass//"nfs-client"
                                storageSize:  parameter.storageSize//"1Gi"
                        }
                }
        }
        parameter: {
        	//+usage=the password for accessing the mongodb standalone.
        	password: string
        	//+usage=the image of the mongodb.
        	image: *"quay.io/opstree/mongo:v5.0.6" | string
        	//+usage=the image pull policy to pull the image.
        	imagePullPolicy:  *"IfNotPresent" | string
        	//+usage=the admin user for accessing the mongodb standalone.
        	mongoDBAdminUser: string
        	//+usage=the storageClass name for the mongodb standalone.
        	storageClass: string
        	//+usage=the storageSize for the mongodb standalone.
        	storageSize: string
        }
}
