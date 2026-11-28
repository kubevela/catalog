---
title: dex
sidebar_label: Overview
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/dex/versions.json';

<AddonVersion data={versions} current="0.7.0" page="" />

<!-- Generated from the addon's files in kubevela/catalog. Edit them there, not here. -->

Enable dex for login.

<dl className="addon-facts">
<dt>Addon version</dt>
<dd>

0.7.0

</dd>
<dt>Released</dt>
<dd>

2023-09-01

</dd>
<dt>KubeVela</dt>
<dd>

`>=v1.6.0-alpha.6`

</dd>
<dt>Needs</dt>
<dd>

[velaux](/addons/catalog/velaux/), [fluxcd](/addons/catalog/fluxcd/)

</dd>
<dt>Tags</dt>
<dd>

Official, OAuth

</dd>
<dt>Source</dt>
<dd>

[kubevela/catalog: addons/dex](https://github.com/kubevela/catalog/tree/release/dex/0.7.0/addons/dex)

</dd>
</dl>

## Install

### With the CLI

```shell
vela addon enable dex
```


```shell
vela addon disable dex
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
    - name: dex
      type: addon
      properties:
        version: "0.7.0"
```

## More

- [Guide](./guide): how to use the addon, from its README.
- [Versions](/addons/catalog/dex/versions): 5 releases of the addon and what each needs.
## Feedback

Found something wrong, or missing something you need? Tell us in kubevela/catalog:

- [Report an issue](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+dex+0.7.0%0A%0A%23%23%23+Describe+the+issue%0A%0A%3C%21--+What+happened%2C+and+what+you+expected+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Fbug&title=%5Bdex+0.7.0%5D+)
- [Request an enhancement](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+dex+0.7.0%0A%0A%23%23%23+What+would+help%0A%0A%3C%21--+What+you%27d+like+the+addon+to+do%2C+and+what+it+would+let+you+do+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Ffeature&title=%5Bdex+0.7.0%5D+)
