import "strings"

output: {
	type: "raw"
	properties: {
		apiVersion: "v1"
		kind:       "Secret"
		metadata: {
			name:      "ucloud-account-creds"
			namespace: "vela-system"
		}
		type: "Opaque"
		stringData: credentials: strings.Join([
							"privateKey: " + parameter.UCLOUD_PRIVATE_KEY,
						
							"publicKey: " + parameter.UCLOUD_PUBLIC_KEY,
						
							"projectID: " + parameter.UCLOUD_PROJECT_ID,
						], "\n")
	}
}

