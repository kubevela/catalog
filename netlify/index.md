---
title: netlify
sidebar_label: Overview
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/netlify/versions.json';

<AddonVersion data={versions} current="10.5.2" page="" />

<!-- Generated from the addon's files in kubevela/catalog. Edit them there, not here. -->

<div className="addon-logo">

![netlify logo](./logo.png)

</div>

Interact with Netlify from the comfort of your CLI.

<dl className="addon-facts">
<dt>Addon version</dt>
<dd>

10.5.2

</dd>
<dt>Released</dt>
<dd>

2023-04-27

</dd>
<dt>KubeVela</dt>
<dd>

any

</dd>
<dt>Upstream</dt>
<dd>

[https://github.com/netlify/cli](https://github.com/netlify/cli)

</dd>
<dt>Tags</dt>
<dd>

extended_workload

</dd>
<dt>Source</dt>
<dd>

[kubevela/catalog: addons/netlify](https://github.com/kubevela/catalog/tree/release/netlify/10.5.2/addons/netlify)

</dd>
</dl>

## Install

### With the CLI

```shell
vela addon enable netlify
```


```shell
vela addon disable netlify
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
    - name: netlify
      type: addon
      properties:
        version: "10.5.2"
```

## Definitions

| Definition | Type | What it does |
| --- | --- | --- |
| [`netlify`](./definitions/netlify) | Component | Netlify component. |
## More

- [Guide](./guide): how to use the addon, from its README.
- [Versions](/addons/catalog/netlify/versions): 2 releases of the addon and what each needs.
## Feedback

Found something wrong, or missing something you need? Tell us in kubevela/catalog:

- [Report an issue](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+netlify+10.5.2%0A%0A%23%23%23+Describe+the+issue%0A%0A%3C%21--+What+happened%2C+and+what+you+expected+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Fbug&title=%5Bnetlify+10.5.2%5D+)
- [Request an enhancement](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+netlify+10.5.2%0A%0A%23%23%23+What+would+help%0A%0A%3C%21--+What+you%27d+like+the+addon+to+do%2C+and+what+it+would+let+you+do+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Ffeature&title=%5Bnetlify+10.5.2%5D+)
