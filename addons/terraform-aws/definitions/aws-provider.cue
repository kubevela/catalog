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
		name: *"aws" | string
		//+usage=Get AWS_ACCESS_KEY_ID per https://aws.amazon.com/blogs/security/wheres-my-secret-access-key/
		AWS_ACCESS_KEY_ID: string
		//+usage=Get AWS_SECRET_ACCESS_KEY per https://aws.amazon.com/blogs/security/wheres-my-secret-access-key/
		AWS_SECRET_ACCESS_KEY: string
		//+usage=Get AWS_SESSION_TOKEN per https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_temp_use-resources.html
		AWS_SESSION_TOKEN: *"" | string
		//+usage=Choose one of Code form region list https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-available-regions
		AWS_DEFAULT_REGION: string
	}
}
