"azure-storage-account": {
	type:        "component"
	description: "Azure Storage Account"
	attributes: workload: type: "autodetects.core.oam.dev"
}

template: {
	output: {
		apiVersion: "storage.azure.crossplane.io/v1alpha3"
		kind:       "Account"
		metadata:
			name: parameter.Name
		spec: {
			resourceGroupName: parameter.ResourceGroupName

			storageAccountSpec: {
				kind: parameter.Kind
				location: parameter.Location

				sku: {
					name: parameter.SKU_Name
				}
			}

			if parameter.secretName != _|_ {
				writeConnectionSecretToRef: {
					namespace: context.namespace
					name:      parameter.secretName
				}
			}

			providerConfigRef: {
				name: parameter.providerConfigName
			}
		}
	}

	parameter: {
		// +usage=Specify the name of the Storage Account. Ensure it's less than 24 characters.
		Name:  string

		// +usage=The name of the Resource Group where the Storage Account will be created.
		ResourceGroupName: string

		// +usage=The kind of Storage Account to create. Possible values: "Storage", "BlobStorage".
		Kind: *"Storage" | "BlobStorage" | string

		// +usage=Location where the Storage Account will be created (e.g., "East US", "West US").
		Location: string

		// +usage=The SKU of the Storage Account. Valid values: "Standard_LRS", "Standard_GRS", "Standard_RAGRS", "Standard_ZRS", "Premium_LRS".
		SKU_Name: *"Standard_LRS" | "Standard_GRS" | "Standard_RAGRS" | "Standard_ZRS" | "Premium_LRS" | string

		// +usage=The name of the Azure ProviderConfig to use. This should match the provider you configured for Azure, defaults to `azure-provider`
		providerConfigName: *"azure-provider" | string

		// +usage=Optional secret name to store the connection details of the Storage Account.
		secretName?: string
	}
}
