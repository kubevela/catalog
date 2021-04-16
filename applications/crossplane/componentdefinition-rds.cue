output: {
	apiVersion: "database.alibaba.crossplane.io/v1alpha1"
	kind:       "RDSInstance"
	spec: {
		forProvider: {
			engine:                parameter.engine
			engineVersion:         parameter.engineVersion
			dbInstanceClass:       parameter.instanceClass
			dbInstanceStorageInGB: 20
			securityIPList:        "0.0.0.0/0"
			masterUsername:        parameter.username
		}
		writeConnectionSecretToRef: {
			namespace: context.namespace
			name:      parameter.secretName
		}
		providerConfigRef: {
			name: "default"
		}
		deletionPolicy: "Delete"
	}
}
parameter: {
	// +usage=RDS engine
	engine: *"mysql" | string
	// +usage=The version of RDS engine
	engineVersion: *"8.0" | string
	// +usage=The instance class for the RDS
	instanceClass: *"rds.mysql.c1.large" | string
	// +usage=RDS username
	username: string
	// +usage=Secret name which RDS connection will write to
	secretName: string
}
