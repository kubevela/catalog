import "strings"

"terraform-vsphere": {
	type: "component"
	annotations: {
		"alias.config.oam.dev": "Terraform Provider for VMware vSphere"
	}
	labels: {
		"catalog.config.oam.dev":       "velacore-config"
		"type.config.oam.dev":          "terraform-provider"
		"multi-cluster.config.oam.dev": "false"
	}
	description: "Terraform Provider for VMware vSphere"
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
			provider: "vsphere"
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
							"vSphereUser: " + parameter.VSPHERE_USER,

							"vSpherePassword: " + parameter.VSPHERE_PASSWORD,

							"vSphereServer: " + parameter.VSPHERE_SERVER,

							"vSphereAllowUnverifiedSSL: " + parameter.VSPHERE_ALLOW_UNVERIFIED_SSL,

			], "\n")
		}
	}

	l: {
		"config.oam.dev/catalog":  "velacore-config"
		"config.oam.dev/type":     "terraform-provider"
		"config.oam.dev/provider": "terraform-vsphere"
	}

	parameter: {
    //+usage=The name of Terraform Provider for VMware vSphere
		name: *"vsphere" | string
		//+usage=Get VSPHERE_USER per this guide https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs
		VSPHERE_USER: *"" | string
		//+usage=Get VSPHERE_PASSWORD per this guide https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs
		VSPHERE_PASSWORD: *"" | string
		//+usage=Get VSPHERE_SERVER per this guide https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs
		VSPHERE_SERVER: *"" | string
		//+usage=Get VSPHERE_ALLOW_UNVERIFIED_SSL per this guide https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs
		VSPHERE_ALLOW_UNVERIFIED_SSL: *"" | string
	}
}
