import "strings"

"terraform-gcp": {
	type: "component"
	annotations: {
		"alias.config.oam.dev": "Terraform Provider for GCP"
	}
	labels: {
		"catalog.config.oam.dev":       "velacore-config"
		"type.config.oam.dev":          "terraform-provider"
		"multi-cluster.config.oam.dev": "false"
	}
	description: "Terraform Provider for GCP"
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
			provider: "gcp"
			region:   parameter.GOOGLE_REGION
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
							"gcpCredentialsJSON: " + parameter.GOOGLE_CREDENTIALS,

				"gcpProject: " + parameter.GOOGLE_PROJECT,
			], "\n")
		}
	}

	l: {
		"config.oam.dev/catalog":  "velacore-config"
		"config.oam.dev/type":     "terraform-provider"
		"config.oam.dev/provider": "terraform-gcp"
	}

	parameter: {
		//+usage=The name of Terraform Provider for GCP, default is `default`
		name: *"gcp" | string
		//+usage=Get gcpCredentialsJSON per this guide https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/getting_started#adding-credentials
		GOOGLE_CREDENTIALS: string
		//+usage=Get GOOGLE_REGION by picking one RegionId from Google Cloud region list https://cloud.google.com/compute/docs/regions-zones
		GOOGLE_REGION: string
		//+usage=Set gcpProject per this guide https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/getting_started#configuring-the-provider
		GOOGLE_PROJECT: string
	}
}
