parameter: {
	// +usage=ChartMuseum image
	image: *"ghcr.io/helm/chartmuseum:v0.15.0" | string
	// +usage=Storage backend, can be one of: local(default), alibaba, amazon, google, microsoft
	storage: *"local" | "alibaba" | "amazon" | "google" | "microsoft"
	// +usage=Alibaba Cloud storage backend settings
	alibaba?: {
		// +usage=OSS bucket to store charts for alibaba storage backend, e.g. my-oss-bucket
		bucket: string
		// +usage=Prefix to store charts for alibaba storage backend
		prefix?: string
		// +usage=OSS endpoint to store charts for alibaba storage backend, e.g. oss-cn-beijing.aliyuncs.com
		endpoint: string
		// +usage=Server side encryption algorithm for alibaba storage backend, can be one of: AES256 or KMS
		sse?: "AES256" | "KMS"
		// +usage=Alibaba OSS access key id
		accessKeyID: string
		// +usage=Alibaba OSS access key secret
		accessKeySecret: string
	}
	// +usage=AWS storage backend settings
	amazon?: {
		// +usage=S3 bucket to store charts for amazon storage backend, e.g. my-s3-bucket
		bucket: string
		// +usage=Prefix to store charts for amazon storage backend
		prefix?: string
		// +usage=Region of s3 bucket to store charts, e.g. us-east-1
		region: string
		// +usage=Alternative s3 endpoint
		endpoint?: string
		// +usage=Server side encryption algorithm
		sse?: string
		// +usage=AWS access key id
		accessKeyID: string
		// +usage=AWS access key secret
		accessKeySecret: string
	}
	// +usage=GCP storage backend settings
	google?: {
		// +usage=GCS bucket to store charts for google storage backend, e.g. my-gcs-bucket
		bucket: string
		// +usage=Prefix to store charts for google storage backend
		prefix?: string
		// +usage=GCP service account json string
		googleCredentialsJSON: string
	}
	// +usage=Microsoft Azure storage backend settings
	microsoft?: {
		// +usage=Container to store charts for microsoft storage backend
		container: string
		// +usage=Prefix to store charts for microsoft storage backend
		prefix?: string
		// +usage=Azure storage account
		account: string
		// +usage=Azure storage account access key
		accessKey: string
	}
	// +usage=Show debug messages
	debug: *false | bool
	// +usage=Disable all routes prefixed with /api
	disableAPI: *false | bool
	// +usage=Allow chart versions to be re-uploaded
	allowOverwrite: *true | bool
	// +usage=Allow anonymous GET operations when auth is used
	authAnonymousGet: *false | bool
	// +usage=Basic auth settings
	basicAuth?: {
		// +usage=Username for basic http authentication
		username: string
		// +usage=Password for basic http authentication
		password: string
	}
	// +usage=Service type
	serviceType: *"ClusterIP" | "NodePort" | "LoadBalancer"
	// +usage=Access ChartMuseum from this port
	externalPort: *8080 | int
	// +usage=Persist ChartMuseum data to PV. PVC will be created automatically. Specify a pvcName to prevent that.
	enablePersistence: *false | bool
	// +usage=Use an existing PVC. If you specify this, PVC will NOT be created automatically.
	pcvName?: string
	// +usage=Hosts for Ingress
	ingressHost?: {
		// +usage=Domain name, e.g. cm.domain.com
		name: string
		path: *"/" | string
		// +usage=Enable TLS on the ingress record
		tls: *false | bool
		// +usage=If TLS is set to true, you must declare what secret will store the key/certificate for TLS. Secrets must be added manually to the vela-system.
		tlsSecret?: string
	}
}
