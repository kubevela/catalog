---
title: defkit
sidebar_label: Overview
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/defkit/versions.json';

<AddonVersion data={versions} current="0.1.1" page="" />

<!-- Generated from the addon's files in kubevela/catalog. Edit them there, not here. -->

<div className="addon-logo">

![defkit logo](./logo.svg)

</div>

:::caution Experimental
This addon is in the catalog's experimental registry: enable it with `vela addon registry add experimental --type helm --endpoint=https://kubevela.github.io/catalog/experimental/` first.
:::

Experimental: install DefKit definition modules as Applications. Each module renders in a Job and its definitions are applied, tracked and garbage collected by its Application.

<dl className="addon-facts">
<dt>Addon version</dt>
<dd>

0.1.1

</dd>
<dt>Released</dt>
<dd>

2026-11-26

</dd>
<dt>KubeVela</dt>
<dd>

any

</dd>
<dt>Upstream</dt>
<dd>

[https://github.com/kubevela/kubevela/tree/master/pkg/definition/defkit](https://github.com/kubevela/kubevela/tree/master/pkg/definition/defkit)

</dd>
<dt>Tags</dt>
<dd>

experimental, definitions

</dd>
<dt>Source</dt>
<dd>

[kubevela/catalog: experimental/addons/defkit](https://github.com/kubevela/catalog/tree/release/defkit/0.1.1/experimental/addons/defkit)

</dd>
</dl>

## Install

### With the CLI

```shell
vela addon enable defkit
```

Set [parameters](./parameters) as `key=value` on the same command.

```shell
vela addon disable defkit
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
    - name: defkit
      type: addon
      properties:
        registry: experimental
        version: "0.1.1"
        properties:
          image: "ghcr.io/kubevela/defkit-render:v0.1.0"
```

## Definitions

| Definition | Type | What it does |
| --- | --- | --- |
| [`defkit-apply`](./definitions/defkit-apply) | Workflow-step | Apply the definitions a defkit-render step produced, as this Application's resources (experimental) |
| [`defkit-render`](./definitions/defkit-render) | Workflow-step | Render a DefKit module in a Job into a ConfigMap of definitions (experimental) |
## More

- [Parameters](./parameters): everything `vela addon enable` takes.
- [Guide](./guide): how to use the addon, from its README.
- [Versions](/addons/catalog/defkit/versions): 2 releases of the addon and what each needs.
## Feedback

Found something wrong, or missing something you need? Tell us in kubevela/catalog:

- [Report an issue](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+defkit+0.1.1%0A%0A%23%23%23+Describe+the+issue%0A%0A%3C%21--+What+happened%2C+and+what+you+expected+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Fbug&title=%5Bdefkit+0.1.1%5D+)
- [Request an enhancement](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+defkit+0.1.1%0A%0A%23%23%23+What+would+help%0A%0A%3C%21--+What+you%27d+like+the+addon+to+do%2C+and+what+it+would+let+you+do+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Ffeature&title=%5Bdefkit+0.1.1%5D+)
