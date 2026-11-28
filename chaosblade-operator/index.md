---
title: chaosblade-operator
sidebar_label: Overview
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/chaosblade-operator/versions.json';

<AddonVersion data={versions} current="1.7.0" page="" />

<!-- Generated from the addon's files in kubevela/catalog. Edit them there, not here. -->

<div className="addon-logo">

![chaosblade-operator logo](./logo.svg)

</div>

:::caution Experimental
This addon is in the catalog's experimental registry: enable it with `vela addon registry add experimental --type helm --endpoint=https://kubevela.github.io/catalog/experimental/` first.
:::

A Chaos Engineering Tool for Cloud-native.

<dl className="addon-facts">
<dt>Addon version</dt>
<dd>

1.7.0

</dd>
<dt>Released</dt>
<dd>

2022-09-26

</dd>
<dt>KubeVela</dt>
<dd>

`>=1.5.0`

</dd>
<dt>Upstream</dt>
<dd>

[https://github.com/chaosblade-io/chaosblade-operator](https://github.com/chaosblade-io/chaosblade-operator)

</dd>
<dt>Needs</dt>
<dd>

[fluxcd](/addons/catalog/fluxcd/)

</dd>
<dt>Tags</dt>
<dd>

chaosblade operator for kubernetes experiments

</dd>
<dt>Source</dt>
<dd>

[kubevela/catalog: experimental/addons/chaosblade-operator](https://github.com/kubevela/catalog/tree/release/chaosblade-operator/1.7.0/experimental/addons/chaosblade-operator)

</dd>
</dl>

## Install

### With the CLI

```shell
vela addon enable chaosblade-operator
```

Set [parameters](./parameters) as `key=value` on the same command.

```shell
vela addon disable chaosblade-operator
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
    - name: chaosblade-operator
      type: addon
      properties:
        registry: experimental
        version: "1.7.0"
        properties:
          namespace: "blade"
```

## Definitions

| Definition | Type | What it does |
| --- | --- | --- |
| [`delay-pod-network-by-names`](./definitions/delay-pod-network-by-names) | Trait | delay pod network by names |
| [`chaosblade-delete-pod-by-labels`](./definitions/delete-pod-by-labels) | Trait | delete pod by labels |
| [`delete-pod-by-names`](./definitions/delete-pod-by-names) | Trait | delete pod by names |
| [`fail-pod-by-labels`](./definitions/fail-pod-by-labels) |  | Doesn't load: see its page. |
| [`increase-container-cpu-load-by-id`](./definitions/increase-container-cpu-load-by-id) |  | Doesn't load: see its page. |
| [`kill-container-process-by-id`](./definitions/kill-container-process-by-id) |  | Doesn't load: see its page. |
| [`pod-cpu-load-by-names`](./definitions/pod-cpu-load-by-names) | Trait | increase node cpu load by names |
| [`remove-container-by-id`](./definitions/remove-container-by-id) |  | Doesn't load: see its page. |
| [`tamper-container-dns-by-id`](./definitions/tamper-container-dns-by-id) |  | Doesn't load: see its page. |
## More

- [Parameters](./parameters): everything `vela addon enable` takes.
- [Guide](./guide): how to use the addon, from its README.
- [Versions](/addons/catalog/chaosblade-operator/versions): 1 release of the addon and what each needs.
## Feedback

Found something wrong, or missing something you need? Tell us in kubevela/catalog:

- [Report an issue](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+chaosblade-operator+1.7.0%0A%0A%23%23%23+Describe+the+issue%0A%0A%3C%21--+What+happened%2C+and+what+you+expected+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Fbug&title=%5Bchaosblade-operator+1.7.0%5D+)
- [Request an enhancement](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+chaosblade-operator+1.7.0%0A%0A%23%23%23+What+would+help%0A%0A%3C%21--+What+you%27d+like+the+addon+to+do%2C+and+what+it+would+let+you+do+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Ffeature&title=%5Bchaosblade-operator+1.7.0%5D+)
