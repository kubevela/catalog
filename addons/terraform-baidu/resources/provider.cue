output: {
	type: "raw"
	properties: {
		apiVersion: "terraform.core.oam.dev/v1beta1"
		kind:       "Provider"
		metadata: {
			name:      "baidu"
			namespace: "default"
		}
		spec: {
			provider: "baidu"
			region:   parameter.BAIDUCLOUD_REGION
			credentials: {
				source: "Secret"
				secretRef: {
					namespace: "vela-system"
					name:      "baidu-account-creds"
					key:       "credentials"
				}
			}
		}
	}
}
