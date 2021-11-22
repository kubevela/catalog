output: {
	type: "raw"
	properties: {
		apiVersion: "terraform.core.oam.dev/v1beta1"
		kind:       "Provider"
		metadata: {
			name:      "aws"
			namespace: "default"
		}
		spec: {
			provider: "aws"
			region:   parameter.AWS_DEFAULT_REGION
			credentials: {
				source: "Secret"
				secretRef: {
					namespace: "vela-system"
					name:      "aws-account-creds"
					key:       "credentials"
				}
			}
		}
	}
}
