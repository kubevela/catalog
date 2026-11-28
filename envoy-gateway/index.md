---
title: envoy-gateway
sidebar_label: Overview
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/envoy-gateway/versions.json';

<AddonVersion data={versions} current="0.1.0" page="" />

<!-- Generated from the addon's files in kubevela/catalog. Edit them there, not here. -->

<div className="addon-logo">

![envoy-gateway logo](./logo.svg)

</div>

:::caution Experimental
This addon is in the catalog's experimental registry: enable it with `vela addon registry add experimental --type helm --endpoint=https://kubevela.github.io/catalog/experimental/` first.
:::

Manages Envoy Proxy as a standalone or Kubernetes-based application gateway.

<dl className="addon-facts">
<dt>Addon version</dt>
<dd>

0.1.0

</dd>
<dt>Released</dt>
<dd>

2023-01-11

</dd>
<dt>KubeVela</dt>
<dd>

`>=v1.5.0`

</dd>
<dt>Kubernetes</dt>
<dd>

`>=v1.24`

</dd>
<dt>Upstream</dt>
<dd>

[https://gateway.envoyproxy.io/](https://gateway.envoyproxy.io/)

</dd>
<dt>Tags</dt>
<dd>

Gateway

</dd>
<dt>Source</dt>
<dd>

[kubevela/catalog: experimental/addons/envoy-gateway](https://github.com/kubevela/catalog/tree/release/envoy-gateway/v0.1.0/experimental/addons/envoy-gateway)

</dd>
</dl>

## Install

### With the CLI

```shell
vela addon enable envoy-gateway
```


```shell
vela addon disable envoy-gateway
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
    - name: envoy-gateway
      type: addon
      properties:
        registry: experimental
        version: "0.1.0"
```

## More

- [Guide](./guide): how to use the addon, from its README.
- [Versions](/addons/catalog/envoy-gateway/versions): 1 release of the addon and what each needs.
## Feedback

Found something wrong, or missing something you need? Tell us in kubevela/catalog:

- [Report an issue](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+envoy-gateway+0.1.0%0A%0A%23%23%23+Describe+the+issue%0A%0A%3C%21--+What+happened%2C+and+what+you+expected+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Fbug&title=%5Benvoy-gateway+0.1.0%5D+)
- [Request an enhancement](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+envoy-gateway+0.1.0%0A%0A%23%23%23+What+would+help%0A%0A%3C%21--+What+you%27d+like+the+addon+to+do%2C+and+what+it+would+let+you+do+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Ffeature&title=%5Benvoy-gateway+0.1.0%5D+)
