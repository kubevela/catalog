import "strings"

metadata: {
	name:        "terraform-ec"
	alias:       "Terraform Provider for Elastic Cloud"
	description: "Terraform Provider for Elastic Cloud"
	sensitive:   true
	scope:       "system"
}

template: {
	outputs: {
		"provider": {
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
						name:      context.name
						namespace: context.namespace
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
		}
		type: "Opaque"
		stringData: credentials: strings.Join([
						"ecApiKey: " + parameter.EC_API_KEY,
		], "\n")
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
