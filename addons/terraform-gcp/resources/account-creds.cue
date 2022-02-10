import "strings"

output: {
	type: "raw"
	properties: {
		apiVersion: "v1"
		kind:       "Secret"
		metadata: {
			name:      "gcp-account-creds"
			namespace: "vela-system"
		}
		type: "Opaque"
		stringData: credentials: strings.Join([
							"gcpCredentialsJSON: " + parameter.GOOGLE_CREDENTIALS,
						
							"gcpProject: " + parameter.GOOGLE_PROJECT,
						], "\n")
	}
}

