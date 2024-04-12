import (
	"strconv"
)

#envs: {
	STORAGE:               parameter.storage
	STORAGE_LOCAL_ROOTDIR: "/storage"
	PORT:                  strconv.FormatInt(parameter.externalPort, 10)
	if parameter.alibaba != _|_ {
		STORAGE_ALIBABA_BUCKET:          parameter.alibaba.bucket
		STORAGE_ALIBABA_PREFIX:          parameter.alibaba.prefix
		STORAGE_ALIBABA_ENDPOINT:        parameter.alibaba.endpoint
		STORAGE_ALIBABA_SSE:             parameter.alibaba.sse
		ALIBABA_CLOUD_ACCESS_KEY_ID:     parameter.alibaba.accessKeyID
		ALIBABA_CLOUD_ACCESS_KEY_SECRET: parameter.alibaba.accessKeySecret
	}
	if parameter.amazon != _|_ {
		STORAGE_AMAZON_BUCKET:   parameter.amazon.bucket
		STORAGE_AMAZON_PREFIX:   parameter.amazon.prefix
		STORAGE_AMAZON_REGION:   parameter.amazon.region
		STORAGE_AMAZON_ENDPOINT: parameter.amazon.endpoint
		STORAGE_AMAZON_SSE:      parameter.amazon.sse
		AWS_ACCESS_KEY_ID:       parameter.amazon.accessKeyID
		AWS_SECRET_ACCESS_KEY:   parameter.amazon.accessKeySecret
	}
	if parameter.google != _|_ {
		STORAGE_GOOGLE_BUCKET:          parameter.google.bucket
		STORAGE_GOOGLE_PREFIX:          parameter.google.prefix
		GOOGLE_APPLICATION_CREDENTIALS: "/etc/secrets/google/credentials.json"
	}
	if parameter.microsoft != _|_ {
		STORAGE_MICROSOFT_CONTAINER: parameter.microsoft.container
		STORAGE_MICROSOFT_PREFIX:    parameter.microsoft.prefix
		AZURE_STORAGE_ACCOUNT:       parameter.microsoft.account
		AZURE_STORAGE_ACCESS_KEY:    parameter.microsoft.accessKey
	}
	DEBUG:              strconv.FormatBool(parameter.debug)
	DISABLE_API:        strconv.FormatBool(parameter.disableAPI)
	CACHE_INTERVAL:     parameter.cacheRefresh
	ALLOW_OVERWRITE:    strconv.FormatBool(parameter.allowOverwrite)
	AUTH_ANONYMOUS_GET: strconv.FormatBool(parameter.authAnonymousGet)
	if parameter.basicAuth != _|_ {
		BASIC_AUTH_USER: parameter.basicAuth.username
		BASIC_AUTH_PASS: parameter.basicAuth.password
	}
}

#traitsAll: [
	{
		// NOTE: The `enabled` var is a workaround,
		//       because we need some features (`multiple comprehensions per list` from CUE v0.3.0),
		//       which will make this code much clearer,
		//       but we only have v0.2.2
		// TODO(charlie0129): refactor this using `multiple comprehensions per list` feature from v0.3.0
		enabled: parameter.storage == "local" || parameter.google != _|_
		type:    "storage"
		properties: {
			if !parameter.persistence.enabled {
				emptyDir: [{
					name:      "chartmuseum-local-storage"
					mountPath: "/storage"
				}]
			}
			if parameter.persistence.enabled {
				pvc: [{
					if parameter.persistence.pvcName != _|_ {
						name:      parameter.persistence.pvcName
						mountOnly: true
					}
					if parameter.persistence.pvcName == _|_ {
						name: "chartmuseum-local-storage"
						if parameter.persistence.storageClassName != _|_ {
							storageClassName: parameter.persistence.storageClassName
						}
					}
					mountPath: "/storage"
				}]
			}
			if parameter.google != _|_ {
				secret: [{
					name:      "chartmuseum-gcs-credential"
					mountPath: "/etc/secrets/google"
					items: [{
						key:  "json"
						path: "credentials.json"
					}]
				}]
			}
		}
	},
	{
		enabled: parameter.ingressHost != _|_
		type:    "gateway"
		properties: {
			domain: parameter.ingressHost.name
			if parameter.ingressHost.class != _|_ {
				class: parameter.ingressHost.class
			}
			http: {
				"\(parameter.ingressHost.path)": parameter.externalPort
			}
			if parameter.ingressHost.tls {
				secretName: parameter.ingressHost.tlsSecret
			}
		}
	},
	{
		enabled: true
		type:    "env"
		properties: {
			env: {
				for k, v in #envs if v != _|_ if v != "" {
					"\(k)": v
				}
			}
		}
	},
]

output: {
	type: "webservice"
	properties: {
		image:           parameter.image
		imagePullPolicy: "IfNotPresent"
		ports: [
			{
				name:   "http"
				port:   parameter.externalPort
				expose: true
			},
		]
		exposeType: parameter.serviceType
		livenessProbe: {
			httpGet: {
				path: "/health"
				port: parameter.externalPort
			}
			initialDelaySeconds: 5
		}
		readinessProbe: {
			httpGet: {
				path: "/health"
				port: parameter.externalPort
			}
			initialDelaySeconds: 5
		}
	}
	traits: [
		for t in #traitsAll if t.enabled {
			t
		},
	]
}
