output: {
	type: "raw"
	properties: {
		apiVersion: "terraform.core.oam.dev/v1beta1"
		kind:       "Provider"
		metadata: {
			name:      "elastic"
			namespace: "default"
		}
		spec: {
			provider: "elastic"
			credentials: {
				source: "Secret"
				secretRef: {
					namespace: "vela-system"
					name:      "elastic-account-creds"
					key:       "credentials"
				}
			}
		}
	}
}
