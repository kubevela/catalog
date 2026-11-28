---
title: pyroscope
sidebar_label: Overview
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/pyroscope/versions.json';

<AddonVersion data={versions} current="0.17.1" page="" />

<!-- Generated from the addon's files in kubevela/catalog. Edit them there, not here. -->

<div className="addon-logo">

![pyroscope logo](./logo.jpg)

</div>

:::caution Experimental
This addon is in the catalog's experimental registry: enable it with `vela addon registry add experimental --type helm --endpoint=https://kubevela.github.io/catalog/experimental/` first.
:::

Pyroscope is an open source platform, consisting of server and agent. It allows the user to collect, store, and query the profiling data in a CPU and disk efficient way.

<dl className="addon-facts">
<dt>Addon version</dt>
<dd>

0.17.1

</dd>
<dt>Released</dt>
<dd>

2022-06-06

</dd>
<dt>KubeVela</dt>
<dd>

any

</dd>
<dt>Upstream</dt>
<dd>

[https://github.com/pyroscope-io/pyroscope](https://github.com/pyroscope-io/pyroscope)

</dd>
<dt>Needs</dt>
<dd>

[fluxcd](/addons/catalog/fluxcd/)

</dd>
<dt>Tags</dt>
<dd>

profiling tool

</dd>
<dt>Source</dt>
<dd>

[kubevela/catalog: experimental/addons/pyroscope](https://github.com/kubevela/catalog/tree/release/pyroscope/0.17.1/experimental/addons/pyroscope)

</dd>
</dl>

## Install

### With the CLI

```shell
vela addon enable pyroscope
```


```shell
vela addon disable pyroscope
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
    - name: pyroscope
      type: addon
      properties:
        registry: experimental
        version: "0.17.1"
```

## Definitions

| Definition | Type | What it does |
| --- | --- | --- |
| [`pyroscope`](./definitions/pyroscope) | Trait |  |
## More

- [Guide](./guide): how to use the addon, from its README.
- [Versions](/addons/catalog/pyroscope/versions): 1 release of the addon and what each needs.
## Feedback

Found something wrong, or missing something you need? Tell us in kubevela/catalog:

- [Report an issue](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+pyroscope+0.17.1%0A%0A%23%23%23+Describe+the+issue%0A%0A%3C%21--+What+happened%2C+and+what+you+expected+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Fbug&title=%5Bpyroscope+0.17.1%5D+)
- [Request an enhancement](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+pyroscope+0.17.1%0A%0A%23%23%23+What+would+help%0A%0A%3C%21--+What+you%27d+like+the+addon+to+do%2C+and+what+it+would+let+you+do+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Ffeature&title=%5Bpyroscope+0.17.1%5D+)
