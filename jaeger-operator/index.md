---
title: jaeger-operator
sidebar_label: Overview
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/jaeger-operator/versions.json';

<AddonVersion data={versions} current="1.0.0" page="" />

<!-- Generated from the addon's files in kubevela/catalog. Edit them there, not here. -->

<div className="addon-logo">

![jaeger-operator logo](./logo.svg)

</div>

:::caution Experimental
This addon is in the catalog's experimental registry: enable it with `vela addon registry add experimental --type helm --endpoint=https://kubevela.github.io/catalog/experimental/` first.
:::

Jaeger is used for monitoring and troubleshooting microservices-based distributed systems.

<dl className="addon-facts">
<dt>Addon version</dt>
<dd>

1.0.0

</dd>
<dt>Released</dt>
<dd>

2023-06-30

</dd>
<dt>KubeVela</dt>
<dd>

any

</dd>
<dt>Upstream</dt>
<dd>

[https://www.jaegertracing.io/](https://www.jaegertracing.io/)

</dd>
<dt>Needs</dt>
<dd>

[cert-manager](/addons/catalog/cert-manager/), [fluxcd](/addons/catalog/fluxcd/)

</dd>
<dt>Tags</dt>
<dd>

jaeger-operator

</dd>
<dt>Source</dt>
<dd>

[kubevela/catalog: experimental/addons/jaeger-operator](https://github.com/kubevela/catalog/tree/release/jaeger-operator/1.0.0/experimental/addons/jaeger-operator)

</dd>
</dl>

## Install

### With the CLI

```shell
vela addon enable jaeger-operator
```

Set [parameters](./parameters) as `key=value` on the same command.

```shell
vela addon disable jaeger-operator
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
    - name: jaeger-operator
      type: addon
      properties:
        registry: experimental
        version: "1.0.0"
        properties:
          namespace: "jaeger-operator"
```

## Definitions

| Definition | Type | What it does |
| --- | --- | --- |
| [`jaeger`](./definitions/jaeger) | Component | jaeger component |
## More

- [Parameters](./parameters): everything `vela addon enable` takes.
- [Guide](./guide): how to use the addon, from its README.
- [Versions](/addons/catalog/jaeger-operator/versions): 1 release of the addon and what each needs.
## Feedback

Found something wrong, or missing something you need? Tell us in kubevela/catalog:

- [Report an issue](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+jaeger-operator+1.0.0%0A%0A%23%23%23+Describe+the+issue%0A%0A%3C%21--+What+happened%2C+and+what+you+expected+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Fbug&title=%5Bjaeger-operator+1.0.0%5D+)
- [Request an enhancement](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+jaeger-operator+1.0.0%0A%0A%23%23%23+What+would+help%0A%0A%3C%21--+What+you%27d+like+the+addon+to+do%2C+and+what+it+would+let+you+do+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Ffeature&title=%5Bjaeger-operator+1.0.0%5D+)
