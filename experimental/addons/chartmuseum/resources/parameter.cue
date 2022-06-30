parameter: {
	// +usage=Storage backend, can be one of: local(default), alibaba, amazon, google, microsoft
	storge?: *"local" | "alibaba" | "amazon" | "google" | "microsoft"
	// +usage=Alibaba Cloud storage backend settings
	alibaba?: {
        // +usage=OSS bucket to store charts for alibaba storage backend
        bucket: string
        // +usage=Prefix to store charts for alibaba storage backend
        prefix?: string
        // +usage=OSS endpoint to store charts for alibaba storage backend
        endpoint?: string
        // +usage=Server side encryption algorithm for alibaba storage backend, can be one of: AES256 or KMS
        sse?: "AES256" | "KMS"
    }
    // +usage=AWS storage backend settings
	amazon?: {
        // +usage=S3 bucket to store charts for amazon storage backend
        bucket: string
        // +usage=Prefix to store charts for amazon storage backend
        prefix?: string
        // +usage=Region of s3 bucket to store charts
        region?: string
        // +usage=Alternative s3 endpoint
        endpoint?: string
        // +usage=Server side encryption algorithm
        sse?: string
    }
    // +usage=GCP storage backend settings
	google?: {
        // +usage=GCS bucket to store charts for google storage backend
        bucket: string
        // +usage=Prefix to store charts for google storage backend
        prefix?: string
    }
    // +usage=Microsoft Azure storage backend settings
	google?: {
        // +usage=Container to store charts for microsoft storage backend
        container: string
        // +usage=Prefix to store charts for microsoft storage backend
        prefix?: string
    }
    // +usage=Show debug messages
    debug?: *false | true
}
