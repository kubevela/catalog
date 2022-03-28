import "strings"

"terraform-baidu": {
	type: "component"
		annotations: {
		"alias.config.oam.dev": "Terraform Provider for Baidu Cloud"
	}
	labels: {
		"catalog.config.oam.dev": "velacore-config"
		"type.config.oam.dev": "terraform-provider"
		"multi-cluster.config.oam.dev": "false"
	}
	description: "Terraform Provider for Baidu Cloud"
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
			provider: "baidu"
			region:   parameter.BAIDUCLOUD_REGION
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
							"accessKey: " + parameter.BAIDUCLOUD_ACCESS_KEY,
							"secretKey: " + parameter.BAIDUCLOUD_SECRET_KEY,
			], "\n")
		}
	}

	l: {
		"config.oam.dev/type":     "terraform-provider"
		"config.oam.dev/provider": "terraform-baidu"
	}

	parameter: {
		//+usage=The name of Terraform Provider for Baidu Cloud, default is `baidu`
		name: *"baidu" | string
		//+usage=Get BAIDUCLOUD_ACCESS_KEY per this guide https://cloud.baidu.com/doc/Reference/s/9jwvz2egb
		BAIDUCLOUD_ACCESS_KEY: string
		//+usage=Get BAIDUCLOUD_SECRET_KEY per this guide https://cloud.baidu.com/doc/Reference/s/9jwvz2egb
		BAIDUCLOUD_SECRET_KEY: string
		//+usage=Get BAIDUCLOUD_REGION by picking one RegionId from Baidu Cloud region list https://cloud.baidu.com/doc/Reference/s/2jwvz23xx
		BAIDUCLOUD_REGION: string
	}
}
