"azure-rg": {
	type:        "component"
	description: "Azure Resource Group"
	attributes: workload: type: "autodetects.core.oam.dev"
}

template: {
	output: {
		apiVersion: "azure.crossplane.io/v1alpha3"
		kind:       "ResourceGroup"
		metadata:
			name: parameter.Name

		spec: {
			location: parameter.Location

			providerConfigRef: {
				name: parameter.providerConfigName
			}
		}
	}

	parameter: {
		// +usage=Specify the Resource Group name
		Name: string

		// +usage=Specify the location where the Resource Group will be created. Examples: "eastus", "centralindia", etc. Refer: https://azuretracks.com/2021/04/current-azure-region-names-reference/ for the Azure region names reference.
		Location: string

		// +usage=The name of the Azure ProviderConfig to use. This should match the provider you configured for Azure, defaults to `azure-provider`
		providerConfigName: *"azure-provider" | string
	}
}
