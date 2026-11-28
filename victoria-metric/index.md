---
title: victoria-metric
sidebar_label: Overview
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/victoria-metric/versions.json';

<AddonVersion data={versions} current="0.10.1" page="" />

<!-- Generated from the addon's files in kubevela/catalog. Edit them there, not here. -->

<div className="addon-logo">

![victoria-metric logo](./logo.jpg)

</div>

VictoriaMetrics addon for KubeVela.

<dl className="addon-facts">
<dt>Addon version</dt>
<dd>

0.10.1

</dd>
<dt>Released</dt>
<dd>

2026-09-10

</dd>
<dt>KubeVela</dt>
<dd>

any

</dd>
<dt>Needs</dt>
<dd>

[o11y-definitions](/addons/catalog/o11y-definitions/), [fluxcd](/addons/catalog/fluxcd/)

</dd>
<dt>Tags</dt>
<dd>

Prometheus, Observability, VictoriaMetrics

</dd>
<dt>Source</dt>
<dd>

[kubevela/catalog: addons/victoria-metric](https://github.com/kubevela/catalog/tree/release/victoria-metric/0.10.1/addons/victoria-metric)

</dd>
</dl>

## Install

### With the CLI

```shell
vela addon enable victoria-metric
```

Set [parameters](./parameters) as `key=value` on the same command.

```shell
vela addon disable victoria-metric
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
    - name: victoria-metric
      type: addon
      properties:
        version: "0.10.1"
        properties:
          namespace: "vm-system"
```

## More

- [Parameters](./parameters): everything `vela addon enable` takes.
- [Guide](./guide): how to use the addon, from its README.
- [Versions](/addons/catalog/victoria-metric/versions): 2 releases of the addon and what each needs.
## Feedback

Found something wrong, or missing something you need? Tell us in kubevela/catalog:

- [Report an issue](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+victoria-metric+0.10.1%0A%0A%23%23%23+Describe+the+issue%0A%0A%3C%21--+What+happened%2C+and+what+you+expected+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Fbug&title=%5Bvictoria-metric+0.10.1%5D+)
- [Request an enhancement](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+victoria-metric+0.10.1%0A%0A%23%23%23+What+would+help%0A%0A%3C%21--+What+you%27d+like+the+addon+to+do%2C+and+what+it+would+let+you+do+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Ffeature&title=%5Bvictoria-metric+0.10.1%5D+)
