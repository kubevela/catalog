---
title: node-exporter
sidebar_label: Overview
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/node-exporter/versions.json';

<AddonVersion data={versions} current="0.3.0" page="" />

<!-- Generated from the addon's files in kubevela/catalog. Edit them there, not here. -->

<div className="addon-logo">

![node-exporter logo](./logo.svg)

</div>

Prometheus exporter for hardware and OS metrics exposed by *NIX kernels, written in Go with pluggable metric collectors.

<dl className="addon-facts">
<dt>Addon version</dt>
<dd>

0.3.0

</dd>
<dt>Released</dt>
<dd>

2023-02-02

</dd>
<dt>KubeVela</dt>
<dd>

`>=v1.7.0`

</dd>
<dt>Upstream</dt>
<dd>

[https://github.com/prometheus/node_exporter](https://github.com/prometheus/node_exporter)

</dd>
<dt>Tags</dt>
<dd>

Observability, Kubernetes, Metrics, Prometheus

</dd>
<dt>Source</dt>
<dd>

[kubevela/catalog: addons/node-exporter](https://github.com/kubevela/catalog/tree/release/node-exporter/v0.3.0/addons/node-exporter)

</dd>
</dl>

## Install

### With the CLI

```shell
vela addon enable node-exporter
```

Set [parameters](./parameters) as `key=value` on the same command.

```shell
vela addon disable node-exporter
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
    - name: node-exporter
      type: addon
      properties:
        version: "0.3.0"
        properties:
          namespace: "o11y-system"
```

## More

- [Parameters](./parameters): everything `vela addon enable` takes.
- [Guide](./guide): how to use the addon, from its README.
- [Versions](/addons/catalog/node-exporter/versions): 3 releases of the addon and what each needs.
## Feedback

Found something wrong, or missing something you need? Tell us in kubevela/catalog:

- [Report an issue](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+node-exporter+0.3.0%0A%0A%23%23%23+Describe+the+issue%0A%0A%3C%21--+What+happened%2C+and+what+you+expected+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Fbug&title=%5Bnode-exporter+0.3.0%5D+)
- [Request an enhancement](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+node-exporter+0.3.0%0A%0A%23%23%23+What+would+help%0A%0A%3C%21--+What+you%27d+like+the+addon+to+do%2C+and+what+it+would+let+you+do+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Ffeature&title=%5Bnode-exporter+0.3.0%5D+)
