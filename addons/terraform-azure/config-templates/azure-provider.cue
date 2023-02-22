import "strings"

metadata: {
	name:        "terraform-azure"
	alias:       "Terraform Provider for Azure"
	description: "Terraform Provider for Azure"
	sensitive:   true
	scope:       "system"
}

template: {
	outputs: {"provider": {
		apiVersion: "terraform.core.oam.dev/v1beta1"
		kind:       "Provider"
		metadata: {
			name:      parameter.name
			namespace: "default"
			labels:    l
		}
		spec: {
			provider: "azure"
			credentials: {
				source: "Secret"
				secretRef: {
					namespace: context.namespace
					name:      context.name
					key:       "credentials"
				}
			}
		}
	}}

	output: {
		apiVersion: "v1"
		kind:       "Secret"
		metadata: {
			name:      context.name
			namespace: context.namespace
			labels:    l
		}
		type: "Opaque"
		stringData: credentials: strings.Join([creds1, creds2, creds3, creds4], "\n")
	}

	creds1: "armClientID: " + parameter.ARM_CLIENT_ID
	creds2: "armClientSecret: " + parameter.ARM_CLIENT_SECRET
	creds3: "armSubscriptionID: " + parameter.ARM_SUBSCRIPTION_ID
	creds4: "armTenantID: " + parameter.ARM_TENANT_ID

	l: {
		"config.oam.dev/catalog":  "velacore-config"
		"config.oam.dev/type":     "terraform-provider"
		"config.oam.dev/provider": "terraform-azure"
	}

	parameter: {
		//+usage=The name of Terraform Provider for Azure
		name:                string
		ARM_CLIENT_ID:       string
		ARM_CLIENT_SECRET:   string
		ARM_SUBSCRIPTION_ID: string
		ARM_TENANT_ID:       string
	}
}
