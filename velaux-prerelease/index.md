---
title: velaux-prerelease
sidebar_label: Overview
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/velaux-prerelease/versions.json';

<AddonVersion data={versions} current="1.12.0-alpha.1" page="" />

<!-- Generated from the addon's files in kubevela/catalog. Edit them there, not here. -->

<div className="addon-logo">

![velaux-prerelease logo](./logo.svg)

</div>

:::caution Experimental
This addon is in the catalog's experimental registry: enable it with `vela addon registry add experimental --type helm --endpoint=https://kubevela.github.io/catalog/experimental/` first.
:::

Prerelease of VelaUX, the KubeVela User Experience (UX). Replaces the velaux addon: disable velaux before enabling this one.

<dl className="addon-facts">
<dt>Addon version</dt>
<dd>

1.12.0-alpha.1

</dd>
<dt>Released</dt>
<dd>

2026-11-05

</dd>
<dt>KubeVela</dt>
<dd>

`>=v1.11.0`

</dd>
<dt>Upstream</dt>
<dd>

[https://kubevela.io](https://kubevela.io)

</dd>
<dt>Tags</dt>
<dd>

experimental, prerelease, Dashboard

</dd>
<dt>Source</dt>
<dd>

[kubevela/catalog: experimental/addons/velaux-prerelease](https://github.com/kubevela/catalog/tree/release/velaux-prerelease/v1.12.0-alpha.1/experimental/addons/velaux-prerelease)

</dd>
</dl>

## Install

### With the CLI

```shell
vela addon enable velaux-prerelease
```

Set [parameters](./parameters) as `key=value` on the same command.

```shell
vela addon disable velaux-prerelease
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
    - name: velaux-prerelease
      type: addon
      properties:
        registry: experimental
        version: "1.12.0-alpha.1"
        properties:
          serviceAccountName: "kubevela-ux"
```

## More

- [Parameters](./parameters): everything `vela addon enable` takes.
- [Guide](./guide): how to use the addon, from its README.
- [Versions](/addons/catalog/velaux-prerelease/versions): 1 release of the addon and what each needs.
## Feedback

Found something wrong, or missing something you need? Tell us in kubevela/catalog:

- [Report an issue](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+velaux-prerelease+1.12.0-alpha.1%0A%0A%23%23%23+Describe+the+issue%0A%0A%3C%21--+What+happened%2C+and+what+you+expected+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Fbug&title=%5Bvelaux-prerelease+1.12.0-alpha.1%5D+)
- [Request an enhancement](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+velaux-prerelease+1.12.0-alpha.1%0A%0A%23%23%23+What+would+help%0A%0A%3C%21--+What+you%27d+like+the+addon+to+do%2C+and+what+it+would+let+you+do+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Ffeature&title=%5Bvelaux-prerelease+1.12.0-alpha.1%5D+)
