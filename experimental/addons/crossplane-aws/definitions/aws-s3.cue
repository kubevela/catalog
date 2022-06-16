"aws-s3": {
	type:        "component"
	description: "AWS S3 Bucket"
	attributes: workload: type: "autodetects.core.oam.dev"
}

template: {
	output: {
		apiVersion: "s3.aws.crossplane.io/v1beta1"
		kind:       "Bucket"
		metadata:
			name: parameter.name
		spec: {
			forProvider: {
				acl: parameter.acl
				locationConstraint: parameter.locationConstraint
			}
			if parameter.secretName != _|_ {
				writeConnectionSecretToRef: {
					namespace: context.namespace
					name:      parameter.secretName
				}
			}
			providerConfigRef: {
				name: parameter.providerConfigName
			}
		}
	}
	parameter: {
		// +usage=The bucket name
		name: string
		// +usage=The canned ACL to apply to the bucket.
		acl:  string
		// +usage=LocationConstraint specifies the Region where the bucket will be created.
		locationConstraint: string
		// +usage=Secret name which RDS connection will write to
		secretName?:        string
		// +usage=The ProviderConfig name
		providerConfigName: *"aws" | string
	}
}
