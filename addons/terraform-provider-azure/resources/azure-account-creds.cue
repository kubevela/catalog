import "strings"

output: {
	type: "raw"
	properties: {
		apiVersion: "v1"
		kind:       "Secret"
		metadata: {
			name:      "azure-account-creds"
			namespace: "vela-system"
		}
		type: "Opaque"
		stringData: credentials: strings.Join([creds1, creds2, creds3, creds4], "\n")
	}
}

creds1: "armClientID: " + parameter.ARM_CLIENT_ID
creds2: "armClientSecret: " + parameter.ARM_CLIENT_SECRET
creds3: "armSubscriptionID: " + parameter.ARM_SUBSCRIPTION_ID
creds4: "armTenantID: " + parameter.ARM_TENANT_ID
