import "strings"

metadata: {
	name:        "terraform-baidu"
	alias:       "Terraform Provider for Baidu Cloud"
	description: "Terraform Provider for Baidu Cloud"
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
				provider: "baidu"
				region:   parameter.BAIDUCLOUD_REGION
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
						"accessKey: " + parameter.BAIDUCLOUD_ACCESS_KEY,
						"secretKey: " + parameter.BAIDUCLOUD_SECRET_KEY,
		], "\n")
	}

	l: {
		"config.oam.dev/catalog":  "velacore-config"
		"config.oam.dev/type":     "terraform-provider"
		"config.oam.dev/provider": "terraform-baidu"
	}

	parameter: {
		//+usage=The name of Terraform Provider for Baidu Cloud
		name: string
		//+usage=Get BAIDUCLOUD_ACCESS_KEY per this guide https://cloud.baidu.com/doc/Reference/s/9jwvz2egb
		BAIDUCLOUD_ACCESS_KEY: string
		//+usage=Get BAIDUCLOUD_SECRET_KEY per this guide https://cloud.baidu.com/doc/Reference/s/9jwvz2egb
		BAIDUCLOUD_SECRET_KEY: string
		//+usage=Get BAIDUCLOUD_REGION by picking one RegionId from Baidu Cloud region list https://cloud.baidu.com/doc/Reference/s/2jwvz23xx
		BAIDUCLOUD_REGION: string
	}
}
