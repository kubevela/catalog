---
title: trivy-operator
sidebar_label: Overview
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/trivy-operator/versions.json';

<AddonVersion data={versions} current="3.1.2" page="" />

<!-- Generated from the addon's files in kubevela/catalog. Edit them there, not here. -->

<div className="addon-logo">

![trivy-operator logo](./logo.png)

</div>

Kubernetes Operator based on the open-source container vulnerability scanner Trivy.

<dl className="addon-facts">
<dt>Addon version</dt>
<dd>

3.1.2

</dd>
<dt>Released</dt>
<dd>

2023-06-13

</dd>
<dt>KubeVela</dt>
<dd>

`>=v1.7.0-alpha.1`

</dd>
<dt>Upstream</dt>
<dd>

[https://github.com/aquasecurity/trivy-operator](https://github.com/aquasecurity/trivy-operator)

</dd>
<dt>Needs</dt>
<dd>

[fluxcd](/addons/catalog/fluxcd/)

</dd>
<dt>Tags</dt>
<dd>

trivy-operator

</dd>
<dt>Source</dt>
<dd>

[kubevela/catalog: addons/trivy-operator](https://github.com/kubevela/catalog/tree/release/trivy-operator/3.1.2/addons/trivy-operator)

</dd>
</dl>

## Install

### With the CLI

```shell
vela addon enable trivy-operator
```

Set [parameters](./parameters) as `key=value` on the same command.

```shell
vela addon disable trivy-operator
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
    - name: trivy-operator
      type: addon
      properties:
        version: "3.1.2"
        properties:
          namespace: "trivy-system"
```

## Definitions

| Definition | Type | What it does |
| --- | --- | --- |
| [`trivy-check`](./definitions/aqua-trivy) | Workflow-step |  |
## More

- [Parameters](./parameters): everything `vela addon enable` takes.
- [Guide](./guide): how to use the addon, from its README.
- [Versions](/addons/catalog/trivy-operator/versions): 7 releases of the addon and what each needs.
## Feedback

Found something wrong, or missing something you need? Tell us in kubevela/catalog:

- [Report an issue](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+trivy-operator+3.1.2%0A%0A%23%23%23+Describe+the+issue%0A%0A%3C%21--+What+happened%2C+and+what+you+expected+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Fbug&title=%5Btrivy-operator+3.1.2%5D+)
- [Request an enhancement](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+trivy-operator+3.1.2%0A%0A%23%23%23+What+would+help%0A%0A%3C%21--+What+you%27d+like+the+addon+to+do%2C+and+what+it+would+let+you+do+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Ffeature&title=%5Btrivy-operator+3.1.2%5D+)
