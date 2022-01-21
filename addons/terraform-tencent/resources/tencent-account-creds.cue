import "strings"

output: {
	type: "raw"
	properties: {
		apiVersion: "v1"
		kind:       "Secret"
		metadata: {
			name:      "tencent-account-creds"
			namespace: "vela-system"
		}
		type: "Opaque"
		stringData: credentials: strings.Join([creds1, creds2], "\n")
	}
}

creds1: "secretID: " + parameter.TENCENTCLOUD_SECRET_ID
creds2: "secretKey: " + parameter.TENCENTCLOUD_SECRET_KEY
