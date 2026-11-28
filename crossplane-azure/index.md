---
title: crossplane-azure
sidebar_label: Overview
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/crossplane-azure/versions.json';

<AddonVersion data={versions} current="0.0.1" page="" />

<!-- Generated from the addon's files in kubevela/catalog. Edit them there, not here. -->

<div className="addon-logo">

![crossplane-azure logo](./logo.svg)

</div>

:::caution Experimental
This addon is in the catalog's experimental registry: enable it with `vela addon registry add experimental --type helm --endpoint=https://kubevela.github.io/catalog/experimental/` first.
:::

Azure Provider for Crossplane, enabling Azure resource management directly from KubeVela.

<dl className="addon-facts">
<dt>Addon version</dt>
<dd>

0.0.1

</dd>
<dt>Released</dt>
<dd>

2024-10-18

</dd>
<dt>KubeVela</dt>
<dd>

any

</dd>
<dt>Upstream</dt>
<dd>

[https://crossplane.io/](https://crossplane.io/)

</dd>
<dt>Needs</dt>
<dd>

[crossplane](/addons/catalog/crossplane/)

</dd>
<dt>Tags</dt>
<dd>

Crossplane provider, Azure

</dd>
<dt>Source</dt>
<dd>

[kubevela/catalog: experimental/addons/crossplane-azure](https://github.com/kubevela/catalog/tree/release/crossplane-azure/0.0.1/experimental/addons/crossplane-azure)

</dd>
</dl>

## Install

### With the CLI

```shell
vela addon enable crossplane-azure
```


```shell
vela addon disable crossplane-azure
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
    - name: crossplane-azure
      type: addon
      properties:
        registry: experimental
        version: "0.0.1"
```

## Definitions

| Definition | Type | What it does |
| --- | --- | --- |
| [`azure-rg`](./definitions/azure-rg) | Component | Azure Resource Group |
| [`azure-storage-account`](./definitions/azure-storage-account) | Component | Azure Storage Account |
| [`azure-vnet`](./definitions/azure-vnet) | Component | Azure Virtual Network |
| [`crossplane-azure`](./definitions/crossplane-azure) | Component | Azure Provider for Crossplane |
## More

- [Guide](./guide): how to use the addon, from its README.
- [Versions](/addons/catalog/crossplane-azure/versions): 1 release of the addon and what each needs.
## Feedback

Found something wrong, or missing something you need? Tell us in kubevela/catalog:

- [Report an issue](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+crossplane-azure+0.0.1%0A%0A%23%23%23+Describe+the+issue%0A%0A%3C%21--+What+happened%2C+and+what+you+expected+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Fbug&title=%5Bcrossplane-azure+0.0.1%5D+)
- [Request an enhancement](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+crossplane-azure+0.0.1%0A%0A%23%23%23+What+would+help%0A%0A%3C%21--+What+you%27d+like+the+addon+to+do%2C+and+what+it+would+let+you+do+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Ffeature&title=%5Bcrossplane-azure+0.0.1%5D+)
