---
title: flink-kubernetes-operator
sidebar_label: Overview
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/flink-kubernetes-operator/versions.json';

<AddonVersion data={versions} current="1.3.2" page="" />

<!-- Generated from the addon's files in kubevela/catalog. Edit them there, not here. -->

A Kubernetes operator for Apache Flink.

<dl className="addon-facts">
<dt>Addon version</dt>
<dd>

1.3.2

</dd>
<dt>Released</dt>
<dd>

2023-06-13

</dd>
<dt>KubeVela</dt>
<dd>

`>=1.5.0-beta.3`

</dd>
<dt>Upstream</dt>
<dd>

[https://github.com/apache/flink-kubernetes-operator](https://github.com/apache/flink-kubernetes-operator)

</dd>
<dt>Needs</dt>
<dd>

[fluxcd](/addons/catalog/fluxcd/), [cert-manager](/addons/catalog/cert-manager/)

</dd>
<dt>Tags</dt>
<dd>

apache/flink-kubernetes-operator

</dd>
<dt>Source</dt>
<dd>

[kubevela/catalog: addons/flink-kubernetes-operator](https://github.com/kubevela/catalog/tree/release/flink-kubernetes-operator/1.3.2/addons/flink-kubernetes-operator)

</dd>
</dl>

## Install

### With the CLI

```shell
vela addon enable flink-kubernetes-operator
```

Set [parameters](./parameters) as `key=value` on the same command.

```shell
vela addon disable flink-kubernetes-operator
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
    - name: flink-kubernetes-operator
      type: addon
      properties:
        version: "1.3.2"
        properties:
          namespace: "flink-operator"
```

## Definitions

| Definition | Type | What it does |
| --- | --- | --- |
| [`flink-cluster`](./definitions/flink-cluster) | Component | Flink Component. |
## More

- [Parameters](./parameters): everything `vela addon enable` takes.
- [Guide](./guide): how to use the addon, from its README.
- [Versions](/addons/catalog/flink-kubernetes-operator/versions): 6 releases of the addon and what each needs.
## Feedback

Found something wrong, or missing something you need? Tell us in kubevela/catalog:

- [Report an issue](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+flink-kubernetes-operator+1.3.2%0A%0A%23%23%23+Describe+the+issue%0A%0A%3C%21--+What+happened%2C+and+what+you+expected+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Fbug&title=%5Bflink-kubernetes-operator+1.3.2%5D+)
- [Request an enhancement](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+flink-kubernetes-operator+1.3.2%0A%0A%23%23%23+What+would+help%0A%0A%3C%21--+What+you%27d+like+the+addon+to+do%2C+and+what+it+would+let+you+do+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Ffeature&title=%5Bflink-kubernetes-operator+1.3.2%5D+)
