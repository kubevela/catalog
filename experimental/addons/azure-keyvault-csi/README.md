
# Azure Keyvault CSI Trait

Uses the [Azure Key Vault Provider for Secrets Store CSI Driver](https://github.com/Azure/secrets-store-csi-driver-provider-azure)
to provide secrets/keys/certs from an Azure Keyvault to the component using
a CSI inline volume mounted at `/mnt/secrets-store`.

The Azure Key Vault Provider and Secrets Store CSI Driver must already be 
installed in the cluster - see [installation instructions](https://azure.github.io/secrets-store-csi-driver-provider-azure/docs/getting-started/installation/)

## Use case example

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: myapp
spec:
  components:
  - name: myapp
    type: webservice
    properties:
      image: me/myapp:latest
    traits:
      - type: azure-keyvault-csi
        properties:
          keyvaultName:           #{KEY_VAULT_NAME}#
          subscriptionId:         #{SUBSCRIPTION_ID}#
          tenantId:               #{TENANT_ID}#
          userAssignedIdentityID: #{USER_ASSIGNED_IDENTITY_ID}#
          keys:
          - name: my-secret            # get a secret value
          - name: my-cert              # get a certificate
            type: cert
          - name: my-other-cert        # get a public key of a certificate
            type: key
```


## Further reading

### Secrets as mounted files

For details about the access of secrets as mounted files see [Consuming Secret values from volumes](https://kubernetes.io/docs/concepts/configuration/secret/#consuming-secret-values-from-volumes).

### Retrieving certificates

For details on types when retrieving certificates, see
[Getting Certificates and Keys using Azure Key Vault Provider](https://azure.github.io/secrets-store-csi-driver-provider-azure/docs/configurations/getting-certs-and-keys/#how-to-obtain-the-certificate)

### Dotnet core

For the dotnet core builtin config provider that supports this, see [key-per-file-configuration provider](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/configuration/?view=aspnetcore-6.0#key-per-file-configuration-provider).

For how to ensure that secrets mounted as file override `appsettings.json` values, see [Application configuration providers](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/configuration/?view=aspnetcore-6.0#application-configuration-providers)

