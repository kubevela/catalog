---
title: fluxcd
sidebar_label: Overview
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/fluxcd/versions.json';

<AddonVersion data={versions} current="3.0.2" page="" />

<!-- Generated from the addon's files in kubevela/catalog. Edit them there, not here. -->

<div className="addon-logo">

![fluxcd logo](./logo.svg)

</div>

Extended workload to do continuous and progressive delivery.

<dl className="addon-facts">
<dt>Addon version</dt>
<dd>

3.0.2

</dd>
<dt>Released</dt>
<dd>

2026-05-26

</dd>
<dt>KubeVela</dt>
<dd>

`>=1.9.0-alpha.2`

</dd>
<dt>Upstream</dt>
<dd>

[https://fluxcd.io](https://fluxcd.io)

</dd>
<dt>Tags</dt>
<dd>

Official, Extended Workload, GitOps, Helm

</dd>
<dt>Source</dt>
<dd>

[kubevela/catalog: addons/fluxcd](https://github.com/kubevela/catalog/tree/release/fluxcd/3.0.2/addons/fluxcd)

</dd>
</dl>

## Install

### With the CLI

```shell
vela addon enable fluxcd
```

Set [parameters](./parameters) as `key=value` on the same command.

```shell
vela addon disable fluxcd
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
    - name: fluxcd
      type: addon
      properties:
        version: "3.0.2"
        properties:
          namespace: "flux-system"
```

## Definitions

| Definition | Type | What it does |
| --- | --- | --- |
| [`helm-labels`](./definitions/helm-labels) | Trait | Patch labels of Pods created by workloads defined in Helm Charts. |
| [`helm`](./definitions/helm-release-def) | Component | helm release is a group of K8s resources from either git repository or helm repo |
| [`kustomize-json-patch`](./definitions/json-patch) | Trait | A list of JSON6902 patch to selected target |
| [`kustomize-patch`](./definitions/kustomize-patch) | Trait | A list of StrategicMerge or JSON6902 patch to selected target |
| [`kustomize`](./definitions/kustomize) | Component | kustomize can fetching, building, updating and applying Kustomize manifests from Git repo or Bucket or OCI repo. |
| [`kustomize-strategy-merge`](./definitions/strategy-merge) | Trait | A list of strategic merge to kustomize config |
## More

- [Parameters](./parameters): everything `vela addon enable` takes.
- [Guide](./guide): how to use the addon, from its README.
- [Versions](/addons/catalog/fluxcd/versions): 38 releases of the addon and what each needs.
## Feedback

Found something wrong, or missing something you need? Tell us in kubevela/catalog:

- [Report an issue](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+fluxcd+3.0.2%0A%0A%23%23%23+Describe+the+issue%0A%0A%3C%21--+What+happened%2C+and+what+you+expected+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Fbug&title=%5Bfluxcd+3.0.2%5D+)
- [Request an enhancement](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+fluxcd+3.0.2%0A%0A%23%23%23+What+would+help%0A%0A%3C%21--+What+you%27d+like+the+addon+to+do%2C+and+what+it+would+let+you+do+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Ffeature&title=%5Bfluxcd+3.0.2%5D+)
