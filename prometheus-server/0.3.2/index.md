---
title: prometheus-server
sidebar_label: Overview
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/prometheus-server/versions.json';

<AddonVersion data={versions} current="0.3.2" page="" />

<!-- Generated from the addon's files in kubevela/catalog. Edit them there, not here. -->

An open-source monitoring system with a dimensional data model, flexible query language, efficient time series database and modern alerting approach.

<dl className="addon-facts">
<dt>Addon version</dt>
<dd>

0.3.2

</dd>
<dt>Released</dt>
<dd>

2023-03-23

</dd>
<dt>KubeVela</dt>
<dd>

`>=v1.7.0`

</dd>
<dt>Upstream</dt>
<dd>

[https://prometheus.io/](https://prometheus.io/)

</dd>
<dt>Needs</dt>
<dd>

[o11y-definitions](/addons/catalog/o11y-definitions/)

</dd>
<dt>Tags</dt>
<dd>

Official, Observability, Kubernetes, Prometheus, Metrics

</dd>
<dt>Source</dt>
<dd>

[kubevela/catalog: addons/prometheus-server](https://github.com/kubevela/catalog/tree/release/prometheus-server/v0.3.2/addons/prometheus-server)

</dd>
</dl>

## Install

### With the CLI

```shell
vela addon enable prometheus-server
```

Set [parameters](./parameters) as `key=value` on the same command.

```shell
vela addon disable prometheus-server
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
    - name: prometheus-server
      type: addon
      properties:
        version: "0.3.2"
        properties:
          namespace: "o11y-system"
```

## Definitions

| Definition | Type | What it does |
| --- | --- | --- |
| [`prometheus-scrape`](./definitions/prometheus-scrape) | Trait | Expose port and allow prometheus to scrape the service. |
## More

- [Parameters](./parameters): everything `vela addon enable` takes.
- [Guide](./guide): how to use the addon, from its README.
- [Versions](/addons/catalog/prometheus-server/versions): 9 releases of the addon and what each needs.
## Feedback

Found something wrong, or missing something you need? Tell us in kubevela/catalog:

- [Report an issue](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+prometheus-server+0.3.2%0A%0A%23%23%23+Describe+the+issue%0A%0A%3C%21--+What+happened%2C+and+what+you+expected+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Fbug&title=%5Bprometheus-server+0.3.2%5D+)
- [Request an enhancement](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+prometheus-server+0.3.2%0A%0A%23%23%23+What+would+help%0A%0A%3C%21--+What+you%27d+like+the+addon+to+do%2C+and+what+it+would+let+you+do+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Ffeature&title=%5Bprometheus-server+0.3.2%5D+)
