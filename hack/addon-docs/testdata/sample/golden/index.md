---
title: sample
sidebar_label: Overview
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/sample/versions.json';

<AddonVersion data={versions} current="1.0.0" page="" />

<!-- Generated from the addon's files in kubevela/catalog. Edit them there, not here. -->

A test addon for the docs generator, covering what its pages show.

The sample addon runs one small app, so its pages show every part of an addon.

<dl className="addon-facts">
<dt>Addon version</dt>
<dd>

1.0.0

</dd>
<dt>Released</dt>
<dd>

2026-11-27

</dd>
<dt>KubeVela</dt>
<dd>

`>=v1.11.0`

</dd>
<dt>Kubernetes</dt>
<dd>

`>=1.30.0`

</dd>
<dt>Upstream</dt>
<dd>

[https://example.com](https://example.com)

</dd>
<dt>Needs</dt>
<dd>

[fluxcd](/addons/catalog/fluxcd/)

</dd>
<dt>Tags</dt>
<dd>

Testing

</dd>
<dt>Source</dt>
<dd>

[kubevela/catalog: addons/sample](https://github.com/kubevela/catalog/tree/release/sample/1.0.0/addons/sample)

</dd>
</dl>

## Install

### With the CLI

```shell
vela addon enable sample
```

Set [parameters](./parameters) as `key=value` on the same command.

```shell
vela addon disable sample
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
    - name: sample
      type: addon
      properties:
        version: "1.0.0"
        properties:
          namespace: "sample"
```

## Definitions

| Definition | Type | What it does |
| --- | --- | --- |
| [`sample-app`](./definitions/sample-app) | Component | Runs the sample app as a Deployment. |
| [`sample-tag`](./definitions/sample-tag) | Trait | Adds a tag label to the component's workload. |
## More

- [Parameters](./parameters): everything `vela addon enable` takes.
- [Guide](./guide): how to use the addon.
- [Versions](/addons/catalog/sample/versions): 1 release of the addon and what each needs.
## Feedback

Found something wrong, or missing something you need? Tell us in kubevela/catalog:

- [Report an issue](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+sample+1.0.0%0A%0A%23%23%23+Describe+the+issue%0A%0A%3C%21--+What+happened%2C+and+what+you+expected+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Fbug&title=%5Bsample+1.0.0%5D+)
- [Request an enhancement](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+sample+1.0.0%0A%0A%23%23%23+What+would+help%0A%0A%3C%21--+What+you%27d+like+the+addon+to+do%2C+and+what+it+would+let+you+do+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Ffeature&title=%5Bsample+1.0.0%5D+)
