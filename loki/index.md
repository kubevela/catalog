---
title: loki
sidebar_label: Overview
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/loki/versions.json';

<AddonVersion data={versions} current="0.3.2" page="" />

<!-- Generated from the addon's files in kubevela/catalog. Edit them there, not here. -->

<div className="addon-logo">

![loki logo](./logo.jpg)

</div>

Loki is a log aggregation system designed to store and query logs from all your applications and infrastructure.

<dl className="addon-facts">
<dt>Addon version</dt>
<dd>

0.3.2

</dd>
<dt>Released</dt>
<dd>

2026-11-22

</dd>
<dt>KubeVela</dt>
<dd>

`>=v1.7.0`

</dd>
<dt>Upstream</dt>
<dd>

[https://grafana.com/oss/loki/](https://grafana.com/oss/loki/)

</dd>
<dt>Needs</dt>
<dd>

[o11y-definitions](/addons/catalog/o11y-definitions/)

</dd>
<dt>Tags</dt>
<dd>

Official, Observability, Kubernetes, Logging

</dd>
<dt>Source</dt>
<dd>

[kubevela/catalog: addons/loki](https://github.com/kubevela/catalog/tree/release/loki/v0.3.2/addons/loki)

</dd>
</dl>

## Install

### With the CLI

```shell
vela addon enable loki
```

Set [parameters](./parameters) as `key=value` on the same command.

```shell
vela addon disable loki
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
    - name: loki
      type: addon
      properties:
        version: "0.3.2"
        properties:
          namespace: "o11y-system"
```

## Definitions

| Definition | Type | What it does |
| --- | --- | --- |
| [`file-logs`](./definitions/file-logs) | Trait | Collect log from file or stdout using vector |
| [`stdout-logs`](./definitions/stdout-logs) | Trait | ETL transformer for application log |
## More

- [Parameters](./parameters): everything `vela addon enable` takes.
- [Guide](./guide): how to use the addon, from its README.
- [Versions](/addons/catalog/loki/versions): 15 releases of the addon and what each needs.
## Feedback

Found something wrong, or missing something you need? Tell us in kubevela/catalog:

- [Report an issue](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+loki+0.3.2%0A%0A%23%23%23+Describe+the+issue%0A%0A%3C%21--+What+happened%2C+and+what+you+expected+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Fbug&title=%5Bloki+0.3.2%5D+)
- [Request an enhancement](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+loki+0.3.2%0A%0A%23%23%23+What+would+help%0A%0A%3C%21--+What+you%27d+like+the+addon+to+do%2C+and+what+it+would+let+you+do+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Ffeature&title=%5Bloki+0.3.2%5D+)
