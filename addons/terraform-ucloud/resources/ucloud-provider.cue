output: {
	type: "raw"
	properties: {
		apiVersion: "terraform.core.oam.dev/v1beta1"
		kind:       "Provider"
		metadata: {
			name:      "ucloud"
			namespace: "default"
		}
		spec: {
			provider: "ucloud"
			region:   parameter.UCLOUD_REGION
			credentials: {
				source: "Secret"
				secretRef: {
					namespace: "vela-system"
					name:      "ucloud-account-creds"
					key:       "credentials"
				}
			}
		}
	}
}
