"azure-vnet": {
    type:        "component"
    description: "Azure Virtual Network"
    attributes: workload: type: "autodetects.core.oam.dev"
}

template: {
    output: {
        apiVersion: "network.azure.crossplane.io/v1alpha3"
        kind:       "VirtualNetwork"
        metadata: {
            name: parameter.Name
        }
        spec: {
            resourceGroupName:  parameter.ResourceGroupName
            location: parameter.Location

            properties: {
                addressSpace: {
                    addressPrefixes: parameter.AddressPrefixes
                }
            }

            providerConfigRef: {
                name: parameter.providerConfigName
            }
        }
    }

    parameter: {
        // +usage=Specify the name of the Virtual Network.
        Name: string

        // +usage=Specify the name of the Resource Group. Ensure that it exists already in the Azure Account.
        ResourceGroupName: string

        // +usage=Specify the location/region where you want your Virtual Network to be created. Examples: "eastus", "centralindia", etc. Refer: https://azuretracks.com/2021/04/current-azure-region-names-reference/ for the Azure region names reference.
        Location: string

        // +usage=Specify the address space for the Virtual Network. This defines the range of IP addresses your network can use. You can provide more than one address space if needed. Example: ["10.0.0.0/16", "10.1.0.0/16"].
        AddressPrefixes: [...string]

				// +usage=The name of the Azure ProviderConfig to use. This should match the provider you configured for Azure, defaults to `azure-provider`
        providerConfigName: *"azure-provider" | string
    }
}
