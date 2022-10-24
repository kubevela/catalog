metadata: {
	name:        "nacos-server"
	alias:       "Nacos Server"
	description: "Config the Nacos server connectors"
	sensitive:   false
	scope:       "system"
}

template: {
	parameter: {
		// +usage=Directly configure the Nacos server address
		servers?: [...{
			// +usage=the nacos server address
			ipAddr: string
			// +usage=nacos server port
			port: *8849 | int
			// +usage=nacos server grpc port, default=server port + 1000, this is not required
			grpcPort?: int
		}]
		// +usage=Discover the Nacos servers by the client.
		client?: {
			// +usage=the endpoint for get Nacos server addresses
			endpoint: string
			// +usage=the AccessKey for kms
			accessKey?: string
			// +usage=the SecretKey for kms
			secretKey?: string
			// +usage=the regionId for kms
			regionId?: string
			// +usage=the username for nacos auth
			username?: string
			// +usage=the password for nacos auth
			password?: string
			// +usage=it's to open kms,default is false. https://help.aliyun.com/product/28933.html
			openKMS?: bool
		}
	}
}
