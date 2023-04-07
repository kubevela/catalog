parameter: {
	//+usage=Deploy to specified clusters. Leave empty to deploy to all clusters.
	clusters?: [...string]
	//+usage=Helm repo URL to find Velero chart. Specify it if you cannot access the default one.
	chartUrl: *"https://vmware-tanzu.github.io/helm-charts" | string
	//+usage=Whether or not to enable volume snapshot feature.
	snapshotsEnabled: *true | bool
	//+usage=Use AWS for backup and snapshots. How to setup: https://github.com/vmware-tanzu/velero-plugin-for-aws#setup .
	aws: {
		//+usage=The name of the bucket to store backups in.
		bucket: string
		//+usage=The prefix within the bucket under which to store backups.
		prefix?: string
		//+usage=The AWS region where the bucket is located. Queried from the AWS S3 API if not provided. Optional if s3ForcePathStyle is false.
		region?: string
		//+usage=Your AWS access key ID.
		accessKeyId: string
		//+usage=Your AWS secret access key.
		secretAccessKey: string
		//+usage=Whether to use path-style addressing instead of virtual hosted bucket addressing. Set to "true" if using a local storage service like MinIO. Defaults to false.
		s3ForcePathStyle?: bool // when using, convert to string "false", "true"
		//+usage=You can specify the AWS S3 URL here for explicitness, but Velero can already generate it from "region" and "bucket". This field is primarily for local storage services like MinIO.
		s3Url?: string
		//+usage=Skip verifing the TLS certificate when connecting to the object store. Not recommended for production.
		insecureSkipTLSVerify?: bool
	}
	// TODO: add more providers other than AWS, like Alibaba, GCP, and Azure.
}
