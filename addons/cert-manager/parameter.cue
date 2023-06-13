parameter: {
	// +usage=Specify if install the CRDs before installing cert-manager or not
	installCRDs: *true | bool
	// +usage=Specify if upgrade the CRDs when upgrading cert-manager or not
	upgradeCRD: *false | bool
	//+usage=Deploy to specified clusters. Leave empty to deploy to all clusters.
	clusters?: [...string]
	//+usage=Namespace to deploy to, defaults to cert-manager
	namespace: *"cert-manager" | string
	//+usage=Number of replicas
	replicas: *1 | int
	//+usage=Use Let's Encrypt staging API. Enabling this is highly recommended BEFORE you get your application working.
	staging: *false | bool
	//+usage=DNS01 Challenge config. Wildcard TLS certificates will be obtained from Let's Encrypt.
	dns01?: {
		//+usage=Certificate namespace. This needs to be the same namespace as your service and ingress.
		namespace: string
		//+usage=Cloudflare-specific DNS01 config
		cloudflare?: {
			//+usage=The email associated with your domain, and also your Cloudflare account.
			email: string
			//+usage=Cloudflare API token. API token should have RW access to your domain. be sure you are generating an API token and not a global API key https://cert-manager.io/docs/configuration/acme/dns01/cloudflare/#api-tokens
			token: string
			//+usage=Cloudflare DNS zone. Sometime it is the same as your domain.
			zone: string
			//+usage=Your domain apex, e.g. "example.com"
			domain: string
		}
	}
}
