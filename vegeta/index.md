---
title: vegeta
sidebar_label: Overview
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/vegeta/versions.json';

<AddonVersion data={versions} current="12.8.4" page="" />

<!-- Generated from the addon's files in kubevela/catalog. Edit them there, not here. -->

Vegeta is a versatile HTTP load testing tool built out of a need to drill HTTP services with a constant request rate. It can be used both as a command line utility and a library.

<dl className="addon-facts">
<dt>Addon version</dt>
<dd>

12.8.4

</dd>
<dt>Released</dt>
<dd>

2022-06-02

</dd>
<dt>KubeVela</dt>
<dd>

any

</dd>
<dt>Upstream</dt>
<dd>

[https://github.com/tsenart/vegeta](https://github.com/tsenart/vegeta)

</dd>
<dt>Tags</dt>
<dd>

extended_trait

</dd>
<dt>Source</dt>
<dd>

[kubevela/catalog: addons/vegeta](https://github.com/kubevela/catalog/tree/release/vegeta/12.8.4/addons/vegeta)

</dd>
</dl>

## Install

### With the CLI

```shell
vela addon enable vegeta
```


```shell
vela addon disable vegeta
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
    - name: vegeta
      type: addon
      properties:
        version: "12.8.4"
```

## Definitions

| Definition | Type | What it does |
| --- | --- | --- |
| [`vegeta`](./definitions/vegeta) | Trait |  |
## More

- [Guide](./guide): how to use the addon, from its README.
- [Versions](/addons/catalog/vegeta/versions): 1 release of the addon and what each needs.
## Feedback

Found something wrong, or missing something you need? Tell us in kubevela/catalog:

- [Report an issue](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+vegeta+12.8.4%0A%0A%23%23%23+Describe+the+issue%0A%0A%3C%21--+What+happened%2C+and+what+you+expected+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Fbug&title=%5Bvegeta+12.8.4%5D+)
- [Request an enhancement](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+vegeta+12.8.4%0A%0A%23%23%23+What+would+help%0A%0A%3C%21--+What+you%27d+like+the+addon+to+do%2C+and+what+it+would+let+you+do+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Ffeature&title=%5Bvegeta+12.8.4%5D+)
