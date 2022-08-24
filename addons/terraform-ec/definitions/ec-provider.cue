import "strings"

"terraform-ec": {
	type: "component"
	annotations: {
		"alias.config.oam.dev": "Terraform Provider for Elastic Cloud"
	}
	labels: {
		"catalog.config.oam.dev":       "velacore-config"
		"type.config.oam.dev":          "terraform-provider"
		"multi-cluster.config.oam.dev": "false"
	}
	description: "Terraform Provider for Elastic Cloud"
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
			provider: "ec"
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
			stringData: credentials: strings.Join([
							"ecApiKey: " + parameter.EC_API_KEY,
			], "\n")
		}
	}

	l: {
		"config.oam.dev/catalog":  "velacore-config"
		"config.oam.dev/type":     "terraform-provider"
		"config.oam.dev/provider": "terraform-ec"
	}

	parameter: {
    //+usage=The name of Terraform Provider for Elastic Cloud
		name: *"ec" | string
		//+usage=Get EC_API_KEY per this guide https://registry.terraform.io/providers/elastic/ec/latest/docs
		EC_API_KEY: *"" | string
	}
}
