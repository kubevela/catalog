---
title: kruise-rollout
sidebar_label: Overview
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/kruise-rollout/versions.json';

<AddonVersion data={versions} current="1.5.2" page="" />

<!-- Generated from the addon's files in kubevela/catalog. Edit them there, not here. -->

<div className="addon-logo">

![kruise-rollout logo](./logo.svg)

</div>

Rollout workload by kruise controller.

<dl className="addon-facts">
<dt>Addon version</dt>
<dd>

1.5.2

</dd>
<dt>Released</dt>
<dd>

2023-06-13

</dd>
<dt>KubeVela</dt>
<dd>

`>=1.8.0-alpha.3`

</dd>
<dt>Kubernetes</dt>
<dd>

`>=1.19.0-0`

</dd>
<dt>Upstream</dt>
<dd>

[https://github.com/openkruise/rollouts](https://github.com/openkruise/rollouts)

</dd>
<dt>Needs</dt>
<dd>

[fluxcd](/addons/catalog/fluxcd/)

</dd>
<dt>Tags</dt>
<dd>

Official, Rollout

</dd>
<dt>Source</dt>
<dd>

[kubevela/catalog: addons/kruise-rollout](https://github.com/kubevela/catalog/tree/release/kruise-rollout/1.5.2/addons/kruise-rollout)

</dd>
</dl>

## Install

### With the CLI

```shell
vela addon enable kruise-rollout
```

Set [parameters](./parameters) as `key=value` on the same command.

```shell
vela addon disable kruise-rollout
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
    - name: kruise-rollout
      type: addon
      properties:
        version: "1.5.2"
        properties:
          upgradeCRD: false
```

## Definitions

| Definition | Type | What it does |
| --- | --- | --- |
| [`canary-deploy`](./definitions/canary-deploy) | Workflow-step | A canary rollout step for components multi-cluster delivery with policies. |
| [`kruise-rollout`](./definitions/kruise-rollout) | Trait | Rollout workload by kruise controller. |
| [`rolling-release`](./definitions/rolling-release) | Trait | Rolling workload with specified weight via kruise rollout. It's advisable not to use this trait directly. Instead, if you use the canary-deploy step, this trait will be added implicitly |
## More

- [Parameters](./parameters): everything `vela addon enable` takes.
- [Guide](./guide): how to use the addon, from its README.
- [Versions](/addons/catalog/kruise-rollout/versions): 11 releases of the addon and what each needs.
## Feedback

Found something wrong, or missing something you need? Tell us in kubevela/catalog:

- [Report an issue](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+kruise-rollout+1.5.2%0A%0A%23%23%23+Describe+the+issue%0A%0A%3C%21--+What+happened%2C+and+what+you+expected+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Fbug&title=%5Bkruise-rollout+1.5.2%5D+)
- [Request an enhancement](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+kruise-rollout+1.5.2%0A%0A%23%23%23+What+would+help%0A%0A%3C%21--+What+you%27d+like+the+addon+to+do%2C+and+what+it+would+let+you+do+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Ffeature&title=%5Bkruise-rollout+1.5.2%5D+)
