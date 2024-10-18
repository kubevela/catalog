# Crossplane Azure

[Azure Provider](https://github.com/crossplane-contrib/provider-azure) for Crossplane.

## What is this addon?

The Crossplane Azure addon enables users to manage Azure cloud resources directly from their Kubernetes clusters using Crossplane. By integrating Azure capabilities into your Kubernetes environment, this addon facilitates seamless infrastructure management alongside your application workloads.

## Why use this addon?

This addon allows you to provision and manage various Azure resources using Kubernetes-native tooling. Use cases include:

- **Infrastructure as Code (IaC)**: Define and manage your Azure resources declaratively using YAML files via KubeVela Applications.
- **Unified Management**: Manage Azure resources in conjunction with other cloud providers and services from a single Kubernetes control plane.
- **Enhanced Workflow**: Take advantage of KubeVela's features, such as application delivery, component composition, and resource management, to create an efficient workflow for your Azure cloud infrastructure.

## How to use this addon?

### Step 1: Install Azure CLI
To interact with Azure resources, you need to have the Azure CLI installed. Follow the instructions in the official documentation to install the Azure CLI for your operating system: [Install the Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).

### Step 2: Login to Azure 
Once you have the Azure CLI installed, log in to your Azure account using the following command in the terminal or in the command prompt:
```shell
az login
```
This command will open a web browser where you can enter your Azure credentials.

### Step 3: Enable the addon
To get started, enable the Crossplane Azure addon:

```shell
vela addon enable crossplane-azure
```
### Step 4: Authenticate Azure Provider for Crossplane

Before provisioning Azure resources, you need to authenticate the Azure provider. 
1) To retrieve current subscription ID of the Azure account via Azure CLI, run the following command in the terminal 
```shell
$ az account show --query id --output tsv
```
2) Use the following command to create a [Service Principal](https://devblogs.microsoft.com/devops/demystifying-service-principals-managed-identities/#service-principal) and obtain credentials:

```shell
$ az ad sp create-for-rbac  --json-auth true --role Owner --scopes="/subscriptions/<your-subscription-id>" -n "crossplane-sp-rbac" > "creds.json"
```

This command will generate a JSON file called `creds.json`, which contains the necessary credentials for the Crossplane Azure provider. The file will have the following structure:

```json
{
  "clientId": "1111111-2222-3333-4444-555555555555",
  "clientSecret": "xxxxxxxxxxxxxxxxxxxxyyyyyyyyyyyyyyyyyyyy",
  "tenantId": "33333333-4444-5555-6666-777777777777",
  "subscriptionId": "22222222-3333-4444-5555-666666666666",
  "activeDirectoryEndpointUrl": "https://login.microsoftonline.com/",
  "resourceManagerEndpointUrl": "https://management.azure.com/",
  "activeDirectoryGraphResourceId": "https://graph.windows.net/",
  "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
  "galleryEndpointUrl": "https://gallery.azure.com/",
  "managementEndpointUrl": "https://management.core.windows.net/"
}
```

You will use these values in the application configuration below.

### Step 5: Apply the Azure Provider configuration
Create an application configuration to authenticate your Azure provider. Replace the placeholders with the values obtained from the previous step:

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: crossplane-azure-provider-config-app
  namespace: vela-system
spec:
  components:
    - name: azure
      type: crossplane-azure
      properties:
        AZURE_APP_ID: <appId>
        AZURE_PASSWORD: <password>
        AZURE_TENANT_ID: <tenantId>
        AZURE_SUBSCRIPTION_ID: <subscriptionId>
        provider_name: azure-provider  # Defaults to "azure-provider". If you wish to override with any other name, you can specify it here. This name will be used in other configurations for referencing the Azure Crossplane ProviderConfig in the next steps.
```

### Step 6: Provision Azure Resources
Now that your Azure provider is configured, you can start provisioning Azure resources. Let's create a [Resource Group](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/manage-resource-groups-portal#what-is-a-resource-group), a [Virtual Network (VNet)](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview) and a [Storage Account](https://learn.microsoft.com/en-us/azure/storage/common/storage-account-overview) as examples.

#### a) Create a Resource Group
Apply the KubeVela application below to create a Resource Group:

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: crossplane-azure-rg-app  # This name will be shown on the UI.
spec:
  components:
    - name: resource-group
      type: azure-rg
      properties:
        Name: crossplane-test-rg
        Location: eastus # Refer to the Azure region names reference for a complete list: https://azuretracks.com/2021/04/current-azure-region-names-reference/
        providerConfigName: azure-provider  # Use the name configured for Azure Crossplane provider at step 5.
```

#### b) Create a Virtual Network (VNet)
Next, you can create a Virtual Network (VNet)  by applying the following KubeVela application configuration:

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: crossplane-azure-vnet-app # This name will be shown on the UI.
spec:
  components:
    - name: virtual-network
      type: azure-vnet
      properties:
        Name: crossplane-vnet
        ResourceGroupName: crossplane-test-rg  # Ensure the Resource Group exists already in the Azure account.
        Location: eastus # Refer to the Azure region names reference for a complete list: https://azuretracks.com/2021/04/current-azure-region-names-reference/
        AddressPrefixes: # Specify the CIDR block for the Virtual Network.
          - "10.0.0.0/16"  
          - "192.168.0.0/16"
          - "172.16.0.0/12"
        providerConfigName: azure-provider  # Use the name configured for Azure Crossplane provider at step 5.
```

#### c) Creating a Storage Account 
Next, you can create a Storage Account by applying the following application configuration. Before proceeding, ensure that your Azure subscription has the necessary resource providers registered to avoid potential errors. 

If you are using a new Azure account, you may encounter the following error when attempting to create a Storage Account:

```shell
storage.AccountsClient#CheckNameAvailability: Failure responding to request: StatusCode=404
```
To prevent this error, you need to ensure that the `Microsoft.Storage` resource provider is registered in your Azure subscription. Follow these steps to register the resource provider:

1. Navigate to your Azure Subscription in the Azure portal. 
2. Select **Resource Providers** from the left pane. 
3. Locate `Microsoft.Storage` in the list. 
4. Click **Register**.

![](https://learn-attachment.microsoft.com/api/attachments/f9b053d2-ebee-40cb-a59d-93420d028b7b?platform=QnA)
Once the resource provider is registered, you can create the Storage Account without any issues. Below is the KubeVela application configuration to create the Storage Account:

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: crossplane-azure-storage-acct-app # This name will be shown on the UI.
spec:
  components:
    - name: storage-account
      type: azure-storage-account
      properties:
        Name: crossplanetestacct
        ResourceGroupName: test-rg  # Ensure the Resource Group exists already in the Azure account.
        Location: eastus   # Refer to the Azure region names reference for a complete list: https://azuretracks.com/2021/04/current-azure-region-names-reference/
        SKU_Name: Standard_LRS # Valid SKUs: Standard_LRS, Standard_GRS, etc.
        Kind: Storage
        providerConfigName: azure-provider # Use the name configured at step 5.
        secretName: storageaccount-connection-secret
```

### Step 7: Verify the Provisioned Resources
Once the applications are running, you can check the status of your resources via the Vela CLI command shown below:
```shell
$ vela ls


APP                                     COMPONENT       TYPE                    TRAITS  PHASE   HEALTHY STATUS  CREATED-TIME                                       
crossplane-azure-rg-app                 resource-group  azure-rg                        running healthy         2024-10-17 09:44:51 +0000 UTC
crossplane-azure-vnet-app               virtual-network azure-vnet                      running healthy         2024-10-17 09:45:33 +0000 UTC
crossplane-azure-storage-acct-app       storage-account azure-storage-account           running healthy         2024-10-17 09:45:48 +0000 UTC
```

You can use the [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/reference-docs-index) commands in your terminal to verify the resources:
```shell
$ az group show --name <your-resource-group-name>
$ az network vnet show --resource-group <your-resource-group-name> --name <your-vnet-name>
$ az storage account show --resource-group <your-resource-group-name> --name <your-storage-account-name>
```

You can also verify them in the Azure portal, alongside the Azure CLI commands:

![](https://i.ibb.co/fNCGtcr/image.png)
The image above shows that the Resource Group `crossplane-test-rg` has been successfully created from KubeVela via Crossplane.

![](https://i.ibb.co/FJs5WY4/image.png)
The image above confirms that the Virtual Network `crossplane-vnet` was created in the `eastus` region within the `test-rg` Resource Group, which was already created in the portal.

![](https://i.ibb.co/ry8PKqW/image.png)
The image above confirms that the Virtual Network contains three address spaces, as specified in the application configuration.

![](https://i.ibb.co/nQ1n6VV/image.png)
The image above confirms that the Storage Account `crossplanetestacct` was successfully created in the `test-rg` Resource Group,  which was already created in the portal.

