output: {
	type: "raw"
	properties: {
		apiVersion: "terraform.core.oam.dev/v1beta1"
		kind:       "Provider"
		metadata: {
			name:      "gcp"
			namespace: "default"
		}
		spec: {
			provider: "gcp"
			region:   parameter.GOOGLE_REGION
			credentials: {
				source: "Secret"
				secretRef: {
					namespace: "vela-system"
					name:      "gcp-account-creds"
					key:       "credentials"
				}
			}
		}
	}
}
