---
title: cert-manager
sidebar_label: Overview
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/cert-manager/versions.json';

<AddonVersion data={versions} current="3.0.0" page="" />

<!-- Generated from the addon's files in kubevela/catalog. Edit them there, not here. -->

Automatically provision and manage TLS certificates in Kubernetes.

<dl className="addon-facts">
<dt>Addon version</dt>
<dd>

3.0.0

</dd>
<dt>Released</dt>
<dd>

2026-11-27

</dd>
<dt>KubeVela</dt>
<dd>

`>=1.12.0-alpha.3`

</dd>
<dt>Kubernetes</dt>
<dd>

`>=1.33.0`

</dd>
<dt>Upstream</dt>
<dd>

[https://cert-manager.io](https://cert-manager.io)

</dd>
<dt>Tags</dt>
<dd>

Graduated, Security & Compliance

</dd>
<dt>Source</dt>
<dd>

[kubevela/catalog: addons/cert-manager](https://github.com/kubevela/catalog/tree/release/cert-manager/3.0.0/addons/cert-manager)

</dd>
</dl>

## Install

### With the CLI

```shell
vela addon enable cert-manager
```

Set [parameters](./parameters) as `key=value` on the same command.

```shell
vela addon disable cert-manager
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
    - name: cert-manager
      type: addon
      properties:
        version: "3.0.0"
        properties:
          namespace: "cert-manager"
```

## Definitions

| Definition | Type | What it does |
| --- | --- | --- |
| [`certificate`](./definitions/certificate) | Trait | Issues a TLS certificate for the component with cert-manager, into a Secret its gateway or ingress can serve. |
| [`issuer`](./definitions/issuer) | Component | A cert-manager issuer: an ACME account (Let's Encrypt by default), a self-signed issuer, or a CA signing with a key pair from a Secret. |
## More

- [Parameters](./parameters): everything `vela addon enable` takes.
- [Guide](./guide): how to use the addon.
- [Versions](/addons/catalog/cert-manager/versions): 1 release of the addon and what each needs.
## Feedback

Found something wrong, or missing something you need? Tell us in kubevela/catalog:

- [Report an issue](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+cert-manager+3.0.0%0A%0A%23%23%23+Describe+the+issue%0A%0A%3C%21--+What+happened%2C+and+what+you+expected+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Fbug&title=%5Bcert-manager+3.0.0%5D+)
- [Request an enhancement](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+cert-manager+3.0.0%0A%0A%23%23%23+What+would+help%0A%0A%3C%21--+What+you%27d+like+the+addon+to+do%2C+and+what+it+would+let+you+do+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Ffeature&title=%5Bcert-manager+3.0.0%5D+)
