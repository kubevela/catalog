---
title: cloudshell
sidebar_label: Overview
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/cloudshell/versions.json';

<AddonVersion data={versions} current="0.2.0" page="" />

<!-- Generated from the addon's files in kubevela/catalog. Edit them there, not here. -->

<div className="addon-logo">

![cloudshell logo](./logo.svg)

</div>

A Friendly Kubernetes CloudShell (Web Terminal).

<dl className="addon-facts">
<dt>Addon version</dt>
<dd>

0.2.0

</dd>
<dt>Released</dt>
<dd>

2022-07-01

</dd>
<dt>KubeVela</dt>
<dd>

any

</dd>
<dt>Upstream</dt>
<dd>

[https://github.com/cloudtty/cloudtty](https://github.com/cloudtty/cloudtty)

</dd>
<dt>Needs</dt>
<dd>

[fluxcd](/addons/catalog/fluxcd/)

</dd>
<dt>Tags</dt>
<dd>

Official

</dd>
<dt>Source</dt>
<dd>

[kubevela/catalog: addons/cloudshell](https://github.com/kubevela/catalog/tree/release/cloudshell/0.2.0/addons/cloudshell)

</dd>
</dl>

## Install

### With the CLI

```shell
vela addon enable cloudshell
```


```shell
vela addon disable cloudshell
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
    - name: cloudshell
      type: addon
      properties:
        version: "0.2.0"
```

## More

- [Guide](./guide): how to use the addon, from its README.
- [Versions](/addons/catalog/cloudshell/versions): 13 releases of the addon and what each needs.
## Feedback

Found something wrong, or missing something you need? Tell us in kubevela/catalog:

- [Report an issue](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+cloudshell+0.2.0%0A%0A%23%23%23+Describe+the+issue%0A%0A%3C%21--+What+happened%2C+and+what+you+expected+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Fbug&title=%5Bcloudshell+0.2.0%5D+)
- [Request an enhancement](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+cloudshell+0.2.0%0A%0A%23%23%23+What+would+help%0A%0A%3C%21--+What+you%27d+like+the+addon+to+do%2C+and+what+it+would+let+you+do+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Ffeature&title=%5Bcloudshell+0.2.0%5D+)
