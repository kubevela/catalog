output: {
	type: "raw"
	properties: {
		apiVersion: "terraform.core.oam.dev/v1beta1"
		kind:       "Provider"
		metadata: {
			name:      "tencent"
			namespace: "default"
		}
		spec: {
			provider: "tencent"
			region:   parameter.TENCENTCLOUD_REGION
			credentials: {
				source: "Secret"
				secretRef: {
					namespace: "vela-system"
					name:      "tencent-account-creds"
					key:       "credentials"
				}
			}
		}
	}
}
