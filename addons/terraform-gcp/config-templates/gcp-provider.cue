import "strings"

metadata: {
	name:        "terraform-gcp"
	alias:       "Terraform Provider for GCP"
	description: "Terraform Provider for GCP"
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
				provider: "gcp"
				region:   parameter.GOOGLE_REGION
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
						"gcpCredentialsJSON: " + parameter.GOOGLE_CREDENTIALS,

			"gcpProject: " + parameter.GOOGLE_PROJECT,
		], "\n")
	}

	l: {
		"config.oam.dev/catalog":  "velacore-config"
		"config.oam.dev/type":     "terraform-provider"
		"config.oam.dev/provider": "terraform-gcp"
	}

	parameter: {
		//+usage=The name of Terraform Provider for GCP
		name: string
		//+usage=Get gcpCredentialsJSON per this guide https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/getting_started#adding-credentials
		GOOGLE_CREDENTIALS: string
		//+usage=Get GOOGLE_REGION by picking one RegionId from Google Cloud region list https://cloud.google.com/compute/docs/regions-zones
		GOOGLE_REGION: string
		//+usage=Set gcpProject per this guide https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/getting_started#configuring-the-provider
		GOOGLE_PROJECT: string
	}
}
