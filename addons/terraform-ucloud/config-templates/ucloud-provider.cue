import "strings"

metadata: {
	name:        "terraform-ucloud"
	alias:       "Terraform Provider for Ucloud Cloud"
	description: "Terraform Provider for Ucloud Cloud"
	scope:       "system"
	sensitive:   true
}

template: {
	outputs: {
		provider: {
			apiVersion: "terraform.core.oam.dev/v1beta1"
			kind:       "Provider"
			metadata: {
				name:      parameter.name
				namespace: "default"
				labels:    l
			}
			spec: {
				provider: "ucloud"
				region:   parameter.UCLOUD_REGION
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
			labels:    l
		}
		type: "Opaque"
		stringData: credentials: strings.Join([
						"privateKey: " + parameter.UCLOUD_PRIVATE_KEY,
						"publicKey: " + parameter.UCLOUD_PUBLIC_KEY,
						"projectID: " + parameter.UCLOUD_PROJECT_ID,
		], "\n")
	}

	l: {
		"config.oam.dev/catalog":  "velacore-config"
		"config.oam.dev/type":     "terraform-provider"
		"config.oam.dev/provider": "terraform-ucloud"
	}

	parameter: {
		//+usage=The name of Terraform Provider for Ucloud Cloud
		name: string
		//+usage=Get UCLOUD_PRIVATE_KEY per this guide https://docs.ucloud.cn/terraform/quickstart
		UCLOUD_PRIVATE_KEY: string
		//+usage=Get UCLOUD_PUBLIC_KEY per this guide https://docs.ucloud.cn/terraform/quickstart
		UCLOUD_PUBLIC_KEY: string
		//+usage=Get UCLOUD_PROJECT_ID per this guide https://docs.ucloud.cn/terraform/quickstart
		UCLOUD_PROJECT_ID: string
		//+usage=Get UCLOUD_REGION by picking one RegionId from UCloud region list https://docs.ucloud.cn/api/summary/regionlist
		UCLOUD_REGION: string
	}
}
