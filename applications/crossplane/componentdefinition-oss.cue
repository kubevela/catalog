output: {
	apiVersion: "oss.alibaba.crossplane.io/v1alpha1"
	kind:       "Bucket"
	spec: {
		name:               parameter.name
		acl:                parameter.acl
		storageClass:       parameter.storageClass
		dataRedundancyType: parameter.dataRedundancyType
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
	// +usage=OSS bucket name
	name: string
	// +usage=The access control list of the OSS bucket
	acl: *"private" | string
	// +usage=The storage type of OSS bucket
	storageClass: *"Standard" | string
	// +usage=The data Redundancy type of OSS bucket
	dataRedundancyType: *"LRS" | string
	// +usage=Secret name which RDS connection will write to
	secretName: string
}
