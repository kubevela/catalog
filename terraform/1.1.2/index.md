---
title: terraform
sidebar_label: Overview
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/terraform/versions.json';

<AddonVersion data={versions} current="1.1.2" page="" />

<!-- Generated from the addon's files in kubevela/catalog. Edit them there, not here. -->

Terraform Controller is a Kubernetes Controller for Terraform.

<dl className="addon-facts">
<dt>Addon version</dt>
<dd>

1.1.2

</dd>
<dt>Released</dt>
<dd>

2023-07-18

</dd>
<dt>KubeVela</dt>
<dd>

any

</dd>
<dt>Upstream</dt>
<dd>

[https://github.com/oam-dev/terraform-controller](https://github.com/oam-dev/terraform-controller)

</dd>
<dt>Needs</dt>
<dd>

[fluxcd](/addons/catalog/fluxcd/)

</dd>
<dt>Tags</dt>
<dd>

Official, IaC, Cloud Resource

</dd>
<dt>Source</dt>
<dd>

[kubevela/catalog: addons/terraform](https://github.com/kubevela/catalog/tree/release/terraform/1.1.2/addons/terraform)

</dd>
</dl>

## Install

### With the CLI

```shell
vela addon enable terraform
```


```shell
vela addon disable terraform
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
    - name: terraform
      type: addon
      properties:
        version: "1.1.2"
```

## More

- [Guide](./guide): how to use the addon, from its README.
- [Versions](/addons/catalog/terraform/versions): 20 releases of the addon and what each needs.
## Feedback

Found something wrong, or missing something you need? Tell us in kubevela/catalog:

- [Report an issue](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+terraform+1.1.2%0A%0A%23%23%23+Describe+the+issue%0A%0A%3C%21--+What+happened%2C+and+what+you+expected+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Fbug&title=%5Bterraform+1.1.2%5D+)
- [Request an enhancement](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+terraform+1.1.2%0A%0A%23%23%23+What+would+help%0A%0A%3C%21--+What+you%27d+like+the+addon+to+do%2C+and+what+it+would+let+you+do+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Ffeature&title=%5Bterraform+1.1.2%5D+)
