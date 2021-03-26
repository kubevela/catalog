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
			name:      context.outputSecretName
		}
		providerConfigRef: {
			name: "default"
		}
		deletionPolicy: "Delete"
	}
}
parameter: {
	engine:          *"mysql" | string
	engineVersion:   *"8.0" | string
	instanceClass:   *"rds.mysql.c1.large" | string
	username:        string
}
