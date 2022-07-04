output: {
	type: "helm"
	properties: {
		url:      "https://chartmuseum.github.io/charts"
		repoType: "helm"
		chart:    "chartmuseum"
		version:  context.metadata.version
		values: {
			env: {
				open: {
					STORAGE: parameter.storage

					if parameter.storage == "alibaba" && parameter.alibaba != _|_ {
						STORAGE_ALIBABA_BUCKET:   parameter.alibaba.bucket
						STORAGE_ALIBABA_ENDPOINT: parameter.alibaba.endpoint

						if parameter.alibaba.prefix != _|_ {
							STORAGE_ALIBABA_PREFIX: parameter.alibaba.prefix
						}

						if parameter.alibaba.sse != _|_ {
							STORAGE_ALIBABA_SSE: parameter.alibaba.sse
						}
					}

					if parameter.storage == "google" && parameter.google != _|_ {
						STORAGE_GOOGLE_BUCKET: parameter.google.bucket

						if parameter.google.prefix != _|_ {
							STORAGE_GOOGLE_PREFIX: parameter.google.prefix
						}
					}

					if parameter.storage == "microsoft" && parameter.microsoft != _|_ {
						STORAGE_MICROSOFT_CONTAINER: parameter.microsoft.container

						if parameter.microsoft.prefix != _|_ {
							STORAGE_MICROSOFT_PREFIX: parameter.microsoft.prefix
						}
					}

					DEBUG:              parameter.debug
					DISABLE_API:        parameter.disableAPI
					ALLOW_OVERWRITE:    parameter.allowOverwrite
					AUTH_ANONYMOUS_GET: parameter.authAnonymousGet
				}

				secret: {
					if parameter.basicAuth != _|_ && parameter.basicAuth.username != _|_ && parameter.basicAuth.password != _|_ {
						BASIC_AUTH_USER: parameter.basicAuth.username
						BASIC_AUTH_PASS: parameter.basicAuth.password
					}

					if parameter.storage != _|_ {
						if parameter.storage == "alibaba" && parameter.alibaba.accessKeyID != _|_ && parameter.alibaba.accessKeySecret != _|_ {
							ALIBABA_CLOUD_ACCESS_KEY_ID:     parameter.alibaba.accessKeyID
							ALIBABA_CLOUD_ACCESS_KEY_SECRET: parameter.alibaba.accessKeySecret
						}

						if parameter.storage == "amazon" && parameter.amazon.accessKeyID != _|_ && parameter.amazon.accessKeySecret != _|_ {
							AWS_ACCESS_KEY_ID:     parameter.amazon.accessKeyID
							AWS_SECRET_ACCESS_KEY: parameter.amazon.accessKeySecret
						}

						if parameter.storage == "google" && parameter.google.googleCredentialsJSON != _|_ {
							GOOGLE_CREDENTIALS_JSON: parameter.google.googleCredentialsJSON
						}

						if parameter.storage == "microsoft" && parameter.microsoft.account != _|_ && parameter.microsoft.accessKey != _|_ {
							AZURE_STORAGE_ACCOUNT:    parameter.microsoft.account
							AZURE_STORAGE_ACCESS_KEY: parameter.microsoft.accessKey
						}
					}
				}
			}

			service: {
				type: parameter.serviceType

				if parameter.serviceType == "LoadBalancer" && parameter.loadBalancerIP != _|_ {
					loadBalancerIP: parameter.loadBalancerIP
				}

				if parameter.externalPort != _|_ {
					externalPort: parameter.externalPort
				}

				if parameter.nodePort != _|_ {
					nodePort: parameter.nodePort
				}
			}

			serviceMonitor: {
				enabled: parameter.enableServiceMonitor
			}

			persistence: {
				enabled: parameter.enablePersistence
				size:    parameter.persistentSize
			}

			ingress: {
				enabled: parameter.enableIngress
				annotations: {
					for k, v in parameter.ingressAnnotations {
						"\(k)": v
					}
				}
				hosts: [
					if parameter.ingressHosts != _|_ {
						for h in parameter.ingressHosts {
							name: h.name
							path: h.path
							tls:  h.tls
							if h.tlsSecret != _|_ {
								tlsSecret: h.tlsSecret
							}
						}
					}
				]
			}
		}
	}
}
