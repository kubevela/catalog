import "strings"

"argocd-repository-credential": {
	annotations: {}
	attributes: workload: {
		type: "autodetects.core.oam.dev"
	}
	description: "Argocd-repository-credential is a definition of git credential."
	labels: {}
	type: "component"
}

template: {
	output: {
		apiVersion: "v1"
		kind:       "Secret"
		metadata: {
			name:      strings.Join(["repo-", context.namespace, "/", context.name], "")
			namespace: "argocd"
			labels: "argocd.argoproj.io/secret-type": "repository"
		}
		type:       "Opaque"
		stringData: {} & parameter.stringData
	}

	parameter: {
		stringData: {
			url:  string
			type: "git" | "helm"

			// while using helm, name is mandatory
			if type == "helm" {
				name: string
			}

			// TLS client cert and key
			tlsClientCertData?: string
			tlsClientCertKey?:  string

			// Basic authentication settings
			username?: string
			password?: string

			// GitHub Application ID for the application you created
			githubAppID?: string
			// the Installation ID of the GitHub app you created and installed
			githubAppInstallationID?: string
			// the base api URL for GitHub Enterprise (e.g. https://ghe.example.com/api/v3)
			githubAppEnterpriseBaseUrl?: string
			// github app private key
			githubAppPrivateKeySecret?: string
			// proxy url
			proxy?: string
		}
	}
}
