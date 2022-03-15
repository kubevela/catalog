import "strings"

output: {
	type: "raw"
	properties: {
		apiVersion: "v1"
		kind:       "Secret"
		metadata: {
			name:      "ec-account-creds"
			namespace: "vela-system"
		}
		type: "Opaque"
		stringData: credentials: strings.Join([
							"ecApiKey: " + parameter.EC_API_KEY,
						], "\n")
	}
}

