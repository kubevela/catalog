---
title: vela-workflow
sidebar_label: Overview
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/vela-workflow/versions.json';

<AddonVersion data={versions} current="0.6.0" page="" />

<!-- Generated from the addon's files in kubevela/catalog. Edit them there, not here. -->

Vela-workflow provides the capability to run a standalone workflow.

<dl className="addon-facts">
<dt>Addon version</dt>
<dd>

0.6.0

</dd>
<dt>Released</dt>
<dd>

2023-08-07

</dd>
<dt>KubeVela</dt>
<dd>

`>=v1.7.0-alpha.1`

</dd>
<dt>Upstream</dt>
<dd>

[https://github.com/kubevela/workflow](https://github.com/kubevela/workflow)

</dd>
<dt>Tags</dt>
<dd>

Official

</dd>
<dt>Source</dt>
<dd>

[kubevela/catalog: addons/vela-workflow](https://github.com/kubevela/catalog/tree/release/vela-workflow/v0.6.0/addons/vela-workflow)

</dd>
</dl>

## Install

### With the CLI

```shell
vela addon enable vela-workflow
```

Set [parameters](./parameters) as `key=value` on the same command.

```shell
vela addon disable vela-workflow
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
    - name: vela-workflow
      type: addon
      properties:
        version: "0.6.0"
        properties:
          image: "oamdev/vela-workflow"
```

## Definitions

| Definition | Type | What it does |
| --- | --- | --- |
| [`addon-operation`](./definitions/addon-operation) | Workflow-step | Enable a KubeVela addon |
| [`apply-app`](./definitions/apply-app) | Workflow-step | Apply application from data or ref to the cluster |
| [`chat-gpt`](./definitions/chat-gpt) | Workflow-step | Send request to chat-gpt |
| [`read-app`](./definitions/read-app) | Workflow-step | Read application from the cluster |
## More

- [Parameters](./parameters): everything `vela addon enable` takes.
- [Guide](./guide): how to use the addon, from its README.
- [Versions](/addons/catalog/vela-workflow/versions): 25 releases of the addon and what each needs.
## Feedback

Found something wrong, or missing something you need? Tell us in kubevela/catalog:

- [Report an issue](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+vela-workflow+0.6.0%0A%0A%23%23%23+Describe+the+issue%0A%0A%3C%21--+What+happened%2C+and+what+you+expected+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Fbug&title=%5Bvela-workflow+0.6.0%5D+)
- [Request an enhancement](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+vela-workflow+0.6.0%0A%0A%23%23%23+What+would+help%0A%0A%3C%21--+What+you%27d+like+the+addon+to+do%2C+and+what+it+would+let+you+do+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Ffeature&title=%5Bvela-workflow+0.6.0%5D+)
