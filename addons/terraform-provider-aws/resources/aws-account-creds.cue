import "strings"

output: {
	type: "raw"
	properties: {
		apiVersion: "v1"
		kind:       "Secret"
		metadata: {
			name:      "aws-account-creds"
			namespace: "vela-system"
		}
		type: "Opaque"
		stringData: credentials: strings.Join([creds1, creds2, creds3], "\n")
	}
}

creds1: "awsAccessKeyID: " + parameter.AWS_ACCESS_KEY_ID
creds2: "awsSecretAccessKey: " + parameter.AWS_SECRET_ACCESS_KEY
creds3: "awsSessionToken: " + parameter.AWS_SESSION_TOKEN
