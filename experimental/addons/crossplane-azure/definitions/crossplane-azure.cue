import "encoding/json"

"crossplane-azure": {
  type:        "component"
  description: "Azure Provider for Crossplane"
  attributes: workload: type: "autodetects.core.oam.dev"
}

template: {
  output: {
    apiVersion: "azure.crossplane.io/v1beta1"
    kind:       "ProviderConfig"
    metadata: {
      name: parameter.provider_name
    }
    spec: {
      credentials: {
        source: "Secret"
        secretRef: {
          namespace: "vela-system"
          name:      parameter.provider_name + "-account-creds-crossplane"
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
        name:      parameter.provider_name + "-account-creds-crossplane"
        namespace: "vela-system"
      }
      type: "Opaque"
      stringData: {
        creds: json.Marshal({
          clientId:     parameter.AZURE_APP_ID
          clientSecret: parameter.AZURE_PASSWORD
          tenantId:     parameter.AZURE_TENANT_ID
          subscriptionId: parameter.AZURE_SUBSCRIPTION_ID
          activeDirectoryEndpointUrl: parameter.AZURE_AD_ENDPOINT
					resourceManagerEndpointUrl: parameter.AZURE_RESOURCE_MANAGER_ENDPOINT
          activeDirectoryGraphResourceId: parameter.AZURE_AD_GRAPH_RESOURCE
          sqlManagementEndpointUrl: parameter.AZURE_SQL_MANAGEMENT_ENDPOINT
          galleryEndpointUrl: parameter.AZURE_GALLERY_ENDPOINT
          managementEndpointUrl: parameter.AZURE_MANAGEMENT_ENDPOINT
        })
      }
    }
  }

  parameter: {
    //+usage=The name of Crossplane Provider for Azure. Specify a unique name, defaults to `azure-provider`
    provider_name: *"azure-provider" | string

    //+usage=Run the following Azure CLI command to create a service principal and get the required values:
		// az ad sp create-for-rbac --sdk-auth --role Owner --scopes="/subscriptions/<your-subscription-id>" -n "crossplane-sp-rbac" > "creds.json"
		// Use the `clientId`, `clientSecret`, `tenantId`, and `subscriptionId` from the `creds.json` file as parameters for the Crossplane Azure provider.

    AZURE_APP_ID: string

    //+usage=The `password` field from the CLI output corresponds to `AZURE_PASSWORD`.
    AZURE_PASSWORD: string

    //+usage=The `tenant` field from the CLI output corresponds to `AZURE_TENANT_ID`.
    AZURE_TENANT_ID: string

    //+usage= The `subscriptionId` from the CLI output corresponds to `AZURE_SUBSCRIPTION_ID`.
    AZURE_SUBSCRIPTION_ID: string

    //+usage=The `activeDirectoryEndpointUrl` field, defaults to Azure public cloud.
    AZURE_AD_ENDPOINT: *"https://login.microsoftonline.com/" | string

    //+usage=The `resourceManagerEndpointUrl`, defaults to Azure public cloud.
    AZURE_RESOURCE_MANAGER_ENDPOINT: *"https://management.azure.com/" | string

    //+usage=The `activeDirectoryGraphResourceId`, defaults to Azure public cloud.
    AZURE_AD_GRAPH_RESOURCE: *"https://graph.windows.net/" | string

    //+usage=The `sqlManagementEndpointUrl`, defaults to Azure public cloud.
    AZURE_SQL_MANAGEMENT_ENDPOINT: *"https://management.core.windows.net:8443/" | string

    //+usage=The `galleryEndpointUrl`, defaults to Azure public cloud.
    AZURE_GALLERY_ENDPOINT: *"https://gallery.azure.com/" | string

    //+usage=The `managementEndpointUrl`, defaults to Azure public cloud.
    AZURE_MANAGEMENT_ENDPOINT: *"https://management.core.windows.net/" | string
  }
}
