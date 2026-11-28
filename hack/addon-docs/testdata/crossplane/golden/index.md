---
title: crossplane
sidebar_label: Overview
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/crossplane/versions.json';

<AddonVersion data={versions} current="1.0.0" page="" />

<!-- Generated from the addon's files in kubevela/catalog. Edit them there, not here. -->

:::caution Experimental
This addon is in the catalog's experimental registry: enable it with `vela addon registry add experimental --type helm --endpoint=https://kubevela.github.io/catalog/experimental/` first.
:::

Crossplane turns the cluster into a control plane for infrastructure, from providers' managed resources to your own composite APIs.

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

`>=1.12.0-alpha.3`

</dd>
<dt>Upstream</dt>
<dd>

[https://crossplane.io/](https://crossplane.io/)

</dd>
<dt>Tags</dt>
<dd>

Graduated, Scheduling & Orchestration

</dd>
<dt>Source</dt>
<dd>

[kubevela/catalog: experimental/addons/crossplane](https://github.com/kubevela/catalog/tree/release/crossplane/1.0.0/experimental/addons/crossplane)

</dd>
</dl>

## Install

### With the CLI

```shell
vela addon enable crossplane
```

Set [parameters](./parameters) as `key=value` on the same command.

```shell
vela addon disable crossplane
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
    - name: crossplane
      type: addon
      properties:
        registry: experimental
        version: "1.0.0"
        properties:
          major: 2
```

## Definitions

| Definition | Type | What it does |
| --- | --- | --- |
| [`crossplane-composition`](./definitions/crossplane-composition) | Component | A Crossplane Composition: the pipeline of functions that builds a composite resource. |
| [`crossplane-function`](./definitions/crossplane-function) | Component | A Crossplane Function package, installed from its OCI image. |
| [`crossplane-provider`](./definitions/crossplane-provider) | Component | A Crossplane Provider package, installed from its OCI image. |
## More

- [Parameters](./parameters): everything `vela addon enable` takes.
- [Guide](./guide): how to use the addon.
- [Versions](/addons/catalog/crossplane/versions): 1 release of the addon and what each needs.
