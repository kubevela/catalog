// apply with "vela def apply azure-keyvault-csi.cue"

import "strings"

"azure-keyvault-csi": {
    type: "trait"
    annotations: {}
    labels: {}
    description: "Add filesystem-mounted values from Azure KeyVault, using Azure key vault provider for secrets store csi driver which must be installed separately, see https://azure.github.io/secrets-store-csi-driver-provider-azure/docs/getting-started/installation/"
    attributes: {
        appliesToWorkloads: ["deployments.apps"]
        podDisruptive: true
    }
}

template: {
    kvObjects: [
        for v in parameter.keys {
            "  objectName: " + v.name + "\n" + "  objectType: " + v.type
        },
    ]

    kvObjectsString: "array:\n- |\n" + strings.Join(kvObjects,"\n- |\n")

    patch: spec: template: spec: {
        // +patchKey=name
        volumes: [{
          name: "secrets-store",
          csi: {
            driver: "secrets-store.csi.k8s.io",
            readOnly: true,
            volumeAttributes: {
              secretProviderClass: context.name
            }
          }
        },]
        containers: [{
          volumeMounts: [{
            mountPath: "/mnt/secrets-store",
            name: "secrets-store",
            readOnly: true
          },]
        },]
    }

    outputs: {
        "SecretProviderClass": {
            apiVersion: "secrets-store.csi.x-k8s.io/v1"
            kind: "SecretProviderClass"
            metadata: {
              name: context.name
            }
            spec: {
              parameters: {
                subscriptionId: parameter.subscriptionId,
                tenantId: parameter.tenantId,
                userAssignedIdentityID: parameter.userAssignedIdentityID,
                keyvaultName: parameter.keyvaultName,
                usePodIdentity: "false",
                useVMManagedIdentity: "true",
                objects: kvObjectsString
              }
              provider: "azure"
           }
        }
    }

    parameter: {
      // +usage=What to use from the KeyVault.
      keys: [...{
        // +usage=Keyvault key
        name: string
        // +usage="secret" (default).  Or "key" or "cert" if key contains a certificate - see https://azure.github.io/secrets-store-csi-driver-provider-azure/docs/configurations/getting-certs-and-keys/#how-to-obtain-the-certificate
        type: *"secret" | "key" | "cert"
      }]
      // +usage=The Azure KeyVault to connect to
      keyvaultName:           string
      // +usage=The Azure subscriptionId for access to the KeyVault
      subscriptionId:         string
      // +usage=The Azure tenantId for access to the KeyVault
      tenantId:               string
      // +usage=The Azure ClientID of the Managed Identity for access to the KeyVault
      userAssignedIdentityID: string

    }

}
