---
title: azure-keyvault-csi
sidebar_label: Overview
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/azure-keyvault-csi/versions.json';

<AddonVersion data={versions} current="0.0.3" page="" />

<!-- Generated from the addon's files in kubevela/catalog. Edit them there, not here. -->

:::caution Experimental
This addon is in the catalog's experimental registry: enable it with `vela addon registry add experimental --type helm --endpoint=https://kubevela.github.io/catalog/experimental/` first.
:::

Trait providing access to Azure Keyvault values via csi driver.

<dl className="addon-facts">
<dt>Addon version</dt>
<dd>

0.0.3

</dd>
<dt>Released</dt>
<dd>

2022-11-10

</dd>
<dt>KubeVela</dt>
<dd>

`>=v1.6.0`

</dd>
<dt>Upstream</dt>
<dd>

[https://github.com/Azure/secrets-store-csi-driver-provider-azure](https://github.com/Azure/secrets-store-csi-driver-provider-azure)

</dd>
<dt>Tags</dt>
<dd>

alpha, azure, keyvault, secret, csi

</dd>
<dt>Source</dt>
<dd>

[kubevela/catalog: experimental/addons/azure-keyvault-csi](https://github.com/kubevela/catalog/tree/release/azure-keyvault-csi/0.0.3/experimental/addons/azure-keyvault-csi)

</dd>
</dl>

## Install

### With the CLI

```shell
vela addon enable azure-keyvault-csi
```


```shell
vela addon disable azure-keyvault-csi
```

### As a component (KubeVela Next)

Install it from an Application with the [`addon` component](/docs/next/end-user/components/references#addon), so the addon is declared, versioned and reviewed with the rest of your platform; deleting the Application uninstalls it. Needs the `EnableAddonComponent` feature gate (alpha, off by default): install or upgrade vela-core with `--set featureGates.enableAddonComponent=true`.

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: platform
  namespace: vela-system
spec:
  components:
    - name: azure-keyvault-csi
      type: addon
      properties:
        registry: experimental
        version: "0.0.3"
```

## Definitions

| Definition | Type | What it does |
| --- | --- | --- |
| [`azure-keyvault-csi`](./definitions/azure-keyvault-csi) | Trait | Add filesystem-mounted values from Azure KeyVault, using Azure key vault provider for secrets store csi driver which must be installed separately, see https://azure.github.io/secrets-store-csi-driver-provider-azure/docs/getting-started/installation/ |
## More

- [Guide](./guide): how to use the addon, from its README.
- [Versions](/addons/catalog/azure-keyvault-csi/versions): 7 releases of the addon and what each needs.
## Feedback

Found something wrong, or missing something you need? Tell us in kubevela/catalog:

- [Report an issue](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+azure-keyvault-csi+0.0.3%0A%0A%23%23%23+Describe+the+issue%0A%0A%3C%21--+What+happened%2C+and+what+you+expected+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Fbug&title=%5Bazure-keyvault-csi+0.0.3%5D+)
- [Request an enhancement](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+azure-keyvault-csi+0.0.3%0A%0A%23%23%23+What+would+help%0A%0A%3C%21--+What+you%27d+like+the+addon+to+do%2C+and+what+it+would+let+you+do+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Ffeature&title=%5Bazure-keyvault-csi+0.0.3%5D+)
