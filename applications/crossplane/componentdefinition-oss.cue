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
			name:      context.outputSecretName
		}
		providerConfigRef: {
			name: "default"
		}
		deletionPolicy: "Delete"
	}
}
parameter: {
	name:               string
	acl:                *"private" | string
	storageClass:       *"Standard" | string
	dataRedundancyType: *"LRS" | string
}
