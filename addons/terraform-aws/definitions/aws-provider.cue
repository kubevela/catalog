import "strings"

"terraform-aws": {
	type: "component"
	annotations: {
		"alias.config.oam.dev": "Terraform Provider for AWS"
	}
	labels: {
		"catalog.config.oam.dev":       "velacore-config"
		"type.config.oam.dev":          "terraform-provider"
		"multi-cluster.config.oam.dev": "false"
	}
	description: "Terraform Provider for AWS"
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
			provider: "aws"
			region:   parameter.AWS_DEFAULT_REGION
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
			stringData: credentials: strings.Join([creds1, creds2, creds3], "\n")
		}
	}

	creds1: "awsAccessKeyID: " + parameter.AWS_ACCESS_KEY_ID
	creds2: "awsSecretAccessKey: " + parameter.AWS_SECRET_ACCESS_KEY
	creds3: "awsSessionToken: " + parameter.AWS_SESSION_TOKEN

	l: {
		"config.oam.dev/catalog":  "velacore-config"
		"config.oam.dev/type":     "terraform-provider"
		"config.oam.dev/provider": "terraform-aws"
	}

	parameter: {
		//+usage=The name of Terraform Provider for AWS, default is `default`
		name:                  *"aws" | string
		AWS_ACCESS_KEY_ID:     string
		AWS_SECRET_ACCESS_KEY: string
		AWS_SESSION_TOKEN:     *"" | string
		AWS_DEFAULT_REGION:    string
	}
}
