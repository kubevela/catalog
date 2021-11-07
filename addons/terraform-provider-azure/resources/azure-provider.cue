output: {
	type: "raw"
	properties: {
		apiVersion: "terraform.core.oam.dev/v1beta1"
		kind:       "Provider"
		metadata: {
			name:      "azure"
			namespace: "default"
		}
		spec: {
			provider: "azure"
			credentials: {
				source: "Secret"
				secretRef: {
					namespace: "vela-system"
					name:      "azure-account-creds"
					key:       "credentials"
				}
			}
		}
	}
}
