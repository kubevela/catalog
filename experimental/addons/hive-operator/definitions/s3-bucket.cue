"s3-bucket": {
	alias: ""
	annotations: {}
	attributes: workload: type: "autodetects.core.oam.dev"
	description: "s3 bucket component"
	labels: {}
	type: "component"
}

template: {
	output: {
		kind:       "S3Bucket"
		apiVersion: "s3.stackable.tech/v1alpha1"
		metadata: {
			name: context.name
		}
		spec: {
			bucketName: parameter.bucketName
			connection: parameter.connection
		}
	}
	parameter: {
		//+usage=the name of the Bucket.
		bucketName: *null | string
		//+usage=can either be inline or reference.
		connection: {
			//+usage=the name of the Bucket.
			inline: *null | {...}
			//+usage=the name of the referenced S3Connection resource, which must be in the same namespace as the S3Bucket resource.
			reference: *null | string
		}
	}
}
