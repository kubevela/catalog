output: {
	type: "raw"
	properties: {
    apiVersion: "terraform.core.oam.dev/v1beta1"
    kind:       "Provider"
    metadata: {
      name:      "ec"
      namespace: "default"
    }
    spec: {
      provider: "ec"
      credentials: {
        source: "Secret"
        secretRef: {
          namespace: "vela-system"
          name:      "ec-account-creds"
          key:       "credentials"
        }
      }
    }
	}
}
