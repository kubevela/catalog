---
title: backstage
sidebar_label: Overview
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/backstage/versions.json';

<AddonVersion data={versions} current="1.2.0" page="" />

<!-- Generated from the addon's files in kubevela/catalog. Edit them there, not here. -->

<div className="addon-logo">

![backstage logo](./logo.svg)

</div>

:::caution Experimental
This addon is in the catalog's experimental registry: enable it with `vela addon registry add experimental --type helm --endpoint=https://kubevela.github.io/catalog/experimental/` first.
:::

Backstage addon for KubeVela.

<dl className="addon-facts">
<dt>Addon version</dt>
<dd>

1.2.0

</dd>
<dt>Released</dt>
<dd>

2025-06-10

</dd>
<dt>KubeVela</dt>
<dd>

any

</dd>
<dt>Tags</dt>
<dd>

Backstage

</dd>
<dt>Source</dt>
<dd>

[kubevela/catalog: experimental/addons/backstage](https://github.com/kubevela/catalog/tree/release/backstage/1.2.0/experimental/addons/backstage)

</dd>
</dl>

## Install

### With the CLI

```shell
vela addon enable backstage
```

Set [parameters](./parameters) as `key=value` on the same command.

```shell
vela addon disable backstage
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
    - name: backstage
      type: addon
      properties:
        registry: experimental
        version: "1.2.0"
        properties:
          image: "oamdev/backstage@sha256:e42e7de7c1007f456751a17fb3eb11794e6d80fb99eda0c03f7a4e34e91e6bec"
```

## Definitions

| Definition | Type | What it does |
| --- | --- | --- |
| [`backstage-location`](./definitions/backstage-location) | Trait | Mark backstage location entity to help better integration. |
| [`backstage`](./definitions/backstage) | Trait | Mark backstage component information to help better integration. |
## More

- [Parameters](./parameters): everything `vela addon enable` takes.
- [Guide](./guide): how to use the addon, from its README.
- [Versions](/addons/catalog/backstage/versions): 5 releases of the addon and what each needs.
## Feedback

Found something wrong, or missing something you need? Tell us in kubevela/catalog:

- [Report an issue](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+backstage+1.2.0%0A%0A%23%23%23+Describe+the+issue%0A%0A%3C%21--+What+happened%2C+and+what+you+expected+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Fbug&title=%5Bbackstage+1.2.0%5D+)
- [Request an enhancement](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+backstage+1.2.0%0A%0A%23%23%23+What+would+help%0A%0A%3C%21--+What+you%27d+like+the+addon+to+do%2C+and+what+it+would+let+you+do+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Ffeature&title=%5Bbackstage+1.2.0%5D+)
