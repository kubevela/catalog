output: {
	type: "raw"
	properties: {
    apiVersion: "terraform.core.oam.dev/v1beta1"
    kind:       "Provider"
    metadata: {
      name:      "vsphere"
      namespace: "default"
    }
    spec: {
      provider: "vsphere"
      credentials: {
        source: "Secret"
        secretRef: {
          namespace: "vela-system"
          name:      "vsphere-account-creds"
          key:       "credentials"
        }
      }
    }
	}
}
