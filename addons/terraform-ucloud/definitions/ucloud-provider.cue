import "strings"

"terraform-ucloud": {
	type: "component"
	annotations: {
		"alias.config.oam.dev": "Terraform Provider for Ucloud Cloud"
	}
	labels: {
		"catalog.config.oam.dev":       "velacore-config"
		"type.config.oam.dev":          "terraform-provider"
		"multi-cluster.config.oam.dev": "false"
	}
	description: "Terraform Provider for Ucloud Cloud"
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
			provider: "ucloud"
			region:   parameter.UCLOUD_REGION
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
							"privateKey: " + parameter.UCLOUD_PRIVATE_KEY,

							"publicKey: " + parameter.UCLOUD_PUBLIC_KEY,

							"projectID: " + parameter.UCLOUD_PROJECT_ID,
						], "\n")
		}
	}

	l: {
		"config.oam.dev/catalog":  "velacore-config"
		"config.oam.dev/type":     "terraform-provider"
		"config.oam.dev/provider": "terraform-ucloud"
	}

	parameter: {
		//+usage=The name of Terraform Provider for Ucloud Cloud, default is `default`
		name: *"ucloud" | string
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
