---
title: mysql-exporter
sidebar_label: Overview
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/mysql-exporter/versions.json';

<AddonVersion data={versions} current="0.0.1" page="" />

<!-- Generated from the addon's files in kubevela/catalog. Edit them there, not here. -->

<div className="addon-logo">

![mysql-exporter logo](./logo.svg)

</div>

Prometheus exporter for MySQL server metrics.

<dl className="addon-facts">
<dt>Addon version</dt>
<dd>

0.0.1

</dd>
<dt>Released</dt>
<dd>

2022-07-13

</dd>
<dt>KubeVela</dt>
<dd>

any

</dd>
<dt>Upstream</dt>
<dd>

[https://github.com/prometheus/mysqld_exporter](https://github.com/prometheus/mysqld_exporter)

</dd>
<dt>Tags</dt>
<dd>

Observability

</dd>
<dt>Source</dt>
<dd>

[kubevela/catalog: addons/mysql-exporter](https://github.com/kubevela/catalog/tree/release/mysql-exporter/0.0.1/addons/mysql-exporter)

</dd>
</dl>

## Install

### With the CLI

```shell
vela addon enable mysql-exporter
```


```shell
vela addon disable mysql-exporter
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
    - name: mysql-exporter
      type: addon
      properties:
        version: "0.0.1"
```

## Definitions

| Definition | Type | What it does |
| --- | --- | --- |
| [`mysql-exporter-server`](./definitions/mysql-exporter-component) | Component |  |
| [`mysql-exporter`](./definitions/mysql-exporter-trait) | Trait |  |
## More

- [Guide](./guide): how to use the addon, from its README.
- [Versions](/addons/catalog/mysql-exporter/versions): 1 release of the addon and what each needs.
## Feedback

Found something wrong, or missing something you need? Tell us in kubevela/catalog:

- [Report an issue](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+mysql-exporter+0.0.1%0A%0A%23%23%23+Describe+the+issue%0A%0A%3C%21--+What+happened%2C+and+what+you+expected+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Fbug&title=%5Bmysql-exporter+0.0.1%5D+)
- [Request an enhancement](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+mysql-exporter+0.0.1%0A%0A%23%23%23+What+would+help%0A%0A%3C%21--+What+you%27d+like+the+addon+to+do%2C+and+what+it+would+let+you+do+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Ffeature&title=%5Bmysql-exporter+0.0.1%5D+)
