import "strings"

"terraform-tencent": {
	type: "component"
	annotations: {
		"alias.config.oam.dev": "Terraform Provider for Tencent Cloud"
	}
	labels: {
		"catalog.config.oam.dev":       "velacore-config"
		"type.config.oam.dev":          "terraform-provider"
		"multi-cluster.config.oam.dev": "false"
	}
	description: "Terraform Provider for Tencent Cloud"
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
			provider: "tencent"
			region:   parameter.TENCENTCLOUD_REGION
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
			stringData: credentials: strings.Join([creds1, creds2], "\n")
		}
	}

	creds1: "secretID: " + parameter.TENCENTCLOUD_SECRET_ID
	creds2: "secretKey: " + parameter.TENCENTCLOUD_SECRET_KEY

	l: {
		"config.oam.dev/catalog":  "velacore-config"
		"config.oam.dev/type":     "terraform-provider"
		"config.oam.dev/provider": "terraform-tencent"
	}

	parameter: {
		//+usage=The name of Terraform Provider for Tencent Cloud, default is `default`
		name: *"default" | string
		//+usage=Get TENCENTCLOUD_SECRET_ID per this guide https://cloud.tencent.com/document/product/1213/67093
		TENCENTCLOUD_SECRET_ID: string
		//+usage=Get TENCENTCLOUD_SECRET_KEY per this guide https://cloud.tencent.com/document/product/1213/67093
		TENCENTCLOUD_SECRET_KEY: string
		//+usage=Get TENCENTCLOUD_REGION by picking one RegionId from Tencent Cloud region list https://cloud.tencent.com/document/api/1140/40509#.E5.9C.B0.E5.9F.9F.E5.88.97.E8.A1.A8
		TENCENTCLOUD_REGION: string
	}
}
