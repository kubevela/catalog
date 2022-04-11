import "strings"

"terraform-alibaba": {
	type: "component"
	annotations: {
		"alias.config.oam.dev": "Terraform Provider for Alibaba Cloud"
	}
	labels: {
		"catalog.config.oam.dev":       "velacore-config"
		"type.config.oam.dev":          "terraform-provider"
		"multi-cluster.config.oam.dev": "false"
	}
	description: "Terraform Provider for Alibaba Cloud"
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
			provider: "alibaba"
			region:   parameter.ALICLOUD_REGION
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

	creds1: "accessKeyID: " + parameter.ALICLOUD_ACCESS_KEY
	creds2: "accessKeySecret: " + parameter.ALICLOUD_SECRET_KEY

	l: {
		"config.oam.dev/catalog":  "velacore-config"
		"config.oam.dev/type":     "terraform-provider"
		"config.oam.dev/provider": "terraform-alibaba"
	}

	parameter: {
		//+usage=The name of Terraform Provider for Alibaba Cloud, default is `default`
		name: *"default" | string
		//+usage=Get ALICLOUD_ACCESS_KEY per this guide https://help.aliyun.com/knowledge_detail/38738.html
		ALICLOUD_ACCESS_KEY: string
		//+usage=Get ALICLOUD_SECRET_KEY per this guide https://help.aliyun.com/knowledge_detail/38738.html
		ALICLOUD_SECRET_KEY: string
		//+usage=Get ALICLOUD_REGION by picking one RegionId from Alibaba Cloud region list https://www.alibabacloud.com/help/doc-detail/72379.htm
		ALICLOUD_REGION: string
	}
}
