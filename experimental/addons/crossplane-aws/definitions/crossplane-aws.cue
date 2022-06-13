import "strings"

"crossplane-aws": {
	type:        "component"
	description: "AWS Provider for Crossplane"
	attributes: workload: type: "autodetects.core.oam.dev"
}

template: {
	output: {
		apiVersion: "aws.crossplane.io/v1beta1"
		kind:       "ProviderConfig"
		metadata:
			name: parameter.name
		spec: {
			credentials: {
				source: "Secret"
				secretRef: {
					namespace: "vela-system"
					name:      parameter.name + "-account-creds-crossplane"
					key:       "creds"
				}
			}
		}
	}

	outputs: {
		"credential": {
			apiVersion: "v1"
			kind:       "Secret"
			metadata: {
				name:      parameter.name + "-account-creds-crossplane"
				namespace: "vela-system"
			}
			type: "Opaque"
			stringData: creds: strings.Join([creds1, creds2], "\n")
		}
	}

	creds1: "awsAccessKeyID: " + parameter.AWS_ACCESS_KEY_ID
	creds2: "awsSecretAccessKey: " + parameter.AWS_SECRET_ACCESS_KEY

	parameter: {
		//+usage=The name of Crossplane Provider AWS, default to `default`
		name: *"default" | string
		//+usage=Get AWS_ACCESS_KEY_ID per https://aws.amazon.com/blogs/security/wheres-my-secret-access-key/
		AWS_ACCESS_KEY_ID: string
		//+usage=Get AWS_SECRET_ACCESS_KEY per https://aws.amazon.com/blogs/security/wheres-my-secret-access-key/
		AWS_SECRET_ACCESS_KEY: string
	}
}
