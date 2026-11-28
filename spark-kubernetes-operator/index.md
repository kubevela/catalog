---
title: spark-kubernetes-operator
sidebar_label: Overview
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/spark-kubernetes-operator/versions.json';

<AddonVersion data={versions} current="1beta2-1.3.8-3.1.1" page="" />

<!-- Generated from the addon's files in kubevela/catalog. Edit them there, not here. -->

<div className="addon-logo">

![spark-kubernetes-operator logo](./logo.png)

</div>

:::caution Experimental
This addon is in the catalog's experimental registry: enable it with `vela addon registry add experimental --type helm --endpoint=https://kubevela.github.io/catalog/experimental/` first.
:::

A kubernetes operator for Apache Spark.

<dl className="addon-facts">
<dt>Addon version</dt>
<dd>

1beta2-1.3.8-3.1.1

</dd>
<dt>Released</dt>
<dd>

2023-03-07

</dd>
<dt>KubeVela</dt>
<dd>

`>=1.5.0-beta.3`

</dd>
<dt>Kubernetes</dt>
<dd>

`>=1.16`

</dd>
<dt>Upstream</dt>
<dd>

[https://github.com/GoogleCloudPlatform/spark-on-k8s-operator](https://github.com/GoogleCloudPlatform/spark-on-k8s-operator)

</dd>
<dt>Needs</dt>
<dd>

[fluxcd](/addons/catalog/fluxcd/)

</dd>
<dt>Tags</dt>
<dd>

GoogleCloudPlatform/spark-on-k8s-operator

</dd>
<dt>Source</dt>
<dd>

[kubevela/catalog: experimental/addons/spark-kubernetes-operator](https://github.com/kubevela/catalog/tree/release/spark-kubernetes-operator/v1beta2-1.3.8-3.1.1/experimental/addons/spark-kubernetes-operator)

</dd>
</dl>

## Install

### With the CLI

```shell
vela addon enable spark-kubernetes-operator
```

Set [parameters](./parameters) as `key=value` on the same command.

```shell
vela addon disable spark-kubernetes-operator
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
    - name: spark-kubernetes-operator
      type: addon
      properties:
        registry: experimental
        version: "1beta2-1.3.8-3.1.1"
        properties:
          namespace: "spark-operator"
```

## Definitions

| Definition | Type | What it does |
| --- | --- | --- |
| [`spark-workload`](./definitions/spark-workload) | Component | Describes a containerized spark application that can specify resource spec. |
## More

- [Parameters](./parameters): everything `vela addon enable` takes.
- [Guide](./guide): how to use the addon, from its README.
- [Versions](/addons/catalog/spark-kubernetes-operator/versions): 1 release of the addon and what each needs.
## Feedback

Found something wrong, or missing something you need? Tell us in kubevela/catalog:

- [Report an issue](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+spark-kubernetes-operator+1beta2-1.3.8-3.1.1%0A%0A%23%23%23+Describe+the+issue%0A%0A%3C%21--+What+happened%2C+and+what+you+expected+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Fbug&title=%5Bspark-kubernetes-operator+1beta2-1.3.8-3.1.1%5D+)
- [Request an enhancement](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+spark-kubernetes-operator+1beta2-1.3.8-3.1.1%0A%0A%23%23%23+What+would+help%0A%0A%3C%21--+What+you%27d+like+the+addon+to+do%2C+and+what+it+would+let+you+do+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Ffeature&title=%5Bspark-kubernetes-operator+1beta2-1.3.8-3.1.1%5D+)
