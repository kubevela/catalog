---
title: rabbitmq-operator
sidebar_label: Overview
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/rabbitmq-operator/versions.json';

<AddonVersion data={versions} current="1.0.0" page="" />

<!-- Generated from the addon's files in kubevela/catalog. Edit them there, not here. -->

<div className="addon-logo">

![rabbitmq-operator logo](./logo.png)

</div>

:::caution Experimental
This addon is in the catalog's experimental registry: enable it with `vela addon registry add experimental --type helm --endpoint=https://kubevela.github.io/catalog/experimental/` first.
:::

This addon adds rabbitmq-operator to the kubevela to be used across the application installed in kubevela.

<dl className="addon-facts">
<dt>Addon version</dt>
<dd>

1.0.0

</dd>
<dt>Released</dt>
<dd>

2023-03-10

</dd>
<dt>KubeVela</dt>
<dd>

any

</dd>
<dt>Upstream</dt>
<dd>

[https://www.rabbitmq.com/kubernetes/operator/](https://www.rabbitmq.com/kubernetes/operator/)

</dd>
<dt>Needs</dt>
<dd>

[fluxcd](/addons/catalog/fluxcd/)

</dd>
<dt>Tags</dt>
<dd>

Middleware, Message Broker

</dd>
<dt>Source</dt>
<dd>

[kubevela/catalog: experimental/addons/rabbitmq-operator](https://github.com/kubevela/catalog/tree/release/rabbitmq-operator/1.0.0/experimental/addons/rabbitmq-operator)

</dd>
</dl>

## Install

### With the CLI

```shell
vela addon enable rabbitmq-operator
```

Set [parameters](./parameters) as `key=value` on the same command.

```shell
vela addon disable rabbitmq-operator
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
    - name: rabbitmq-operator
      type: addon
      properties:
        registry: experimental
        version: "1.0.0"
        properties:
          namespace: "rabbitmq-operator"
```

## Definitions

| Definition | Type | What it does |
| --- | --- | --- |
| [`rabbitmq-operator`](./definitions/rabbitmq-cluster) | Component | rabbitmq operator component |
## More

- [Parameters](./parameters): everything `vela addon enable` takes.
- [Guide](./guide): how to use the addon, from its README.
- [Versions](/addons/catalog/rabbitmq-operator/versions): 1 release of the addon and what each needs.
## Feedback

Found something wrong, or missing something you need? Tell us in kubevela/catalog:

- [Report an issue](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+rabbitmq-operator+1.0.0%0A%0A%23%23%23+Describe+the+issue%0A%0A%3C%21--+What+happened%2C+and+what+you+expected+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Fbug&title=%5Brabbitmq-operator+1.0.0%5D+)
- [Request an enhancement](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+rabbitmq-operator+1.0.0%0A%0A%23%23%23+What+would+help%0A%0A%3C%21--+What+you%27d+like+the+addon+to+do%2C+and+what+it+would+let+you+do+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Ffeature&title=%5Brabbitmq-operator+1.0.0%5D+)
