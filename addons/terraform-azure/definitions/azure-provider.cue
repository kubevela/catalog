import "strings"

"terraform-azure": {
	type: "component"
	annotations: {
		"alias.config.oam.dev": "Terraform Provider for Azure"
	}
	labels: {
		"catalog.config.oam.dev": "velacore-config"
		"type.config.oam.dev": "terraform-provider"
		"multi-cluster.config.oam.dev": "false"
	}
	description: "Terraform Provider for Azure"
	attributes: workload: type: "autodetects.core.oam.dev"
}

template: {
	output: {
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
					namespace: "vela-system"
					name:      parameter.name + "-account-creds"
					key:       "credentials"
				}
			}
		}
	}

	outputs: {
		"credential": {
			apiVersion: "v1"
			kind:       "Secret"
			metadata: {
				name:      parameter.name + "-account-creds"
				namespace: "vela-system"
				labels:    l
			}
			type: "Opaque"
			stringData: credentials: strings.Join([creds1, creds2, creds3, creds4], "\n")
		}
	}

	creds1: "armClientID: " + parameter.ARM_CLIENT_ID
	creds2: "armClientSecret: " + parameter.ARM_CLIENT_SECRET
	creds3: "armSubscriptionID: " + parameter.ARM_SUBSCRIPTION_ID
	creds4: "armTenantID: " + parameter.ARM_TENANT_ID

	l: {
		"config.oam.dev/catalog": "velacore-config"
		"config.oam.dev/type":     "terraform-provider"
		"config.oam.dev/provider": "terraform-azure"
	}

	parameter: {
		//+usage=The name of Terraform Provider for Azure, default is `azure`
		name:                *"azure" | string
		ARM_CLIENT_ID:       string
		ARM_CLIENT_SECRET:   string
		ARM_SUBSCRIPTION_ID: string
		ARM_TENANT_ID:       string
	}
}
