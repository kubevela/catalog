---
title: datadog
sidebar_label: Overview
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/datadog/versions.json';

<AddonVersion data={versions} current="0.0.4" page="" />

<!-- Generated from the addon's files in kubevela/catalog. Edit them there, not here. -->

:::caution Experimental
This addon is in the catalog's experimental registry: enable it with `vela addon registry add experimental --type helm --endpoint=https://kubevela.github.io/catalog/experimental/` first.
:::

Sets up the annotations and environment variables to assist a webservice or cron-task component to have correct collection of logs and apm stats by a datadog agent installed on the host nodes.

<dl className="addon-facts">
<dt>Addon version</dt>
<dd>

0.0.4

</dd>
<dt>Released</dt>
<dd>

2024-05-23

</dd>
<dt>KubeVela</dt>
<dd>

`>=v1.9.0`

</dd>
<dt>Tags</dt>
<dd>

alpha, datadog

</dd>
<dt>Source</dt>
<dd>

[kubevela/catalog: experimental/addons/datadog](https://github.com/kubevela/catalog/tree/release/datadog/0.0.4/experimental/addons/datadog)

</dd>
</dl>

## Install

### With the CLI

```shell
vela addon enable datadog
```


```shell
vela addon disable datadog
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
    - name: datadog
      type: addon
      properties:
        registry: experimental
        version: "0.0.4"
```

## Definitions

| Definition | Type | What it does |
| --- | --- | --- |
| [`datadog`](./definitions/datadog) | Trait | Add required env vars, annotations and host volume mount for datadog instrumentation |
## More

- [Guide](./guide): how to use the addon, from its README.
- [Versions](/addons/catalog/datadog/versions): 6 releases of the addon and what each needs.
## Feedback

Found something wrong, or missing something you need? Tell us in kubevela/catalog:

- [Report an issue](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+datadog+0.0.4%0A%0A%23%23%23+Describe+the+issue%0A%0A%3C%21--+What+happened%2C+and+what+you+expected+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Fbug&title=%5Bdatadog+0.0.4%5D+)
- [Request an enhancement](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+datadog+0.0.4%0A%0A%23%23%23+What+would+help%0A%0A%3C%21--+What+you%27d+like+the+addon+to+do%2C+and+what+it+would+let+you+do+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Ffeature&title=%5Bdatadog+0.0.4%5D+)
