import "encoding/json"
import "strings"

"argocd-cluster-credential": {
	annotations: {}
	attributes: workload: {
		type: "autodetects.core.oam.dev"
	}
	description: "Argocd-cluster-credential is a definition of k8s credential."
	labels: {}
	type: "component"
}

template: {
	output: {
		apiVersion: "v1"
		kind:       "Secret"
		metadata: {
			name:      strings.Join(["cluster-", context.namespace, "/", context.name], "")
			namespace: "argocd"
			labels: "argocd.argoproj.io/secret-type": "cluster"
		}
		type:       "Opaque"
		stringData: {
					name: parameter.stringData.name
					server: parameter.stringData.server
					if parameter.clusterCred.namespaces != _|_ {
							namespaces: parameter.stringData.namespaces
						}
					if parameter.stringData.config != _|_ {
							config: json.Marshal(parameter.stringData.config)
						}
				}
	}
	parameter: {

		#clusterConfig: {
			// Basic authentication settings
			username?: string
			password?: string

			// Bearer authentication settings
			bearerToken?: string

			// IAM authentication configuration
			awsAuthConfig?: {
				clusterName: string
				roleARN:     string
			}

			// Configure external command to supply client credentials
			// See https://godoc.org/k8s.io/client-go/tools/clientcmd/api#ExecConfig
			execProviderConfig?: {
				command?: string
				args?: [...string]
				env?: {...}
				apiVersion?:  string
				installHint?: string
			}

			// Transport layer security configuration settings
			tlsClientConfig?: {
				// Base64 encoded PEM-encoded bytes (typically read from a client certificate file).
				caData?: string
				// Base64 encoded PEM-encoded bytes (typically read from a client certificate file).
				certData?: string
				// Server should be accessed without verifying the TLS certificate
				insecure?: bool
				// Base64 encoded PEM-encoded bytes (typically read from a client certificate key file).
				keyData?: string
				// ServerName is passed to the server for SNI and is used in the client to check server
				// certificates against. If ServerName is empty, the hostname used to contact the
				// server is used.
				serverName?: string
			}

		}

		stringData: {
			name:   string
			server: string
			namespaces?: [...string]
			config: #clusterConfig
		}
	}
}
