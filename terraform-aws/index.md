---
title: terraform-aws
sidebar_label: Overview
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/terraform-aws/versions.json';

<AddonVersion data={versions} current="1.0.3" page="" />

<!-- Generated from the addon's files in kubevela/catalog. Edit them there, not here. -->

<div className="addon-logo">

![terraform-aws logo](./logo.png)

</div>

Kubernetes Terraform Controller for AWS.

<dl className="addon-facts">
<dt>Addon version</dt>
<dd>

1.0.3

</dd>
<dt>Released</dt>
<dd>

2023-02-14

</dd>
<dt>KubeVela</dt>
<dd>

`>=v1.6.0-alpha.6`

</dd>
<dt>Upstream</dt>
<dd>

[https://registry.terraform.io/providers/hashicorp/aws/latest](https://registry.terraform.io/providers/hashicorp/aws/latest)

</dd>
<dt>Needs</dt>
<dd>

[terraform](/addons/catalog/terraform/)

</dd>
<dt>Tags</dt>
<dd>

Terraform Provider, Cloud Resource

</dd>
<dt>Source</dt>
<dd>

[kubevela/catalog: addons/terraform-aws](https://github.com/kubevela/catalog/tree/release/terraform-aws/1.0.3/addons/terraform-aws)

</dd>
</dl>

## Install

### With the CLI

```shell
vela addon enable terraform-aws
```


```shell
vela addon disable terraform-aws
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
    - name: terraform-aws
      type: addon
      properties:
        version: "1.0.3"
```

## More

- [Guide](./guide): how to use the addon, from its README.
- [Versions](/addons/catalog/terraform-aws/versions): 4 releases of the addon and what each needs.
## Feedback

Found something wrong, or missing something you need? Tell us in kubevela/catalog:

- [Report an issue](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+terraform-aws+1.0.3%0A%0A%23%23%23+Describe+the+issue%0A%0A%3C%21--+What+happened%2C+and+what+you+expected+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Fbug&title=%5Bterraform-aws+1.0.3%5D+)
- [Request an enhancement](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+terraform-aws+1.0.3%0A%0A%23%23%23+What+would+help%0A%0A%3C%21--+What+you%27d+like+the+addon+to+do%2C+and+what+it+would+let+you+do+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Ffeature&title=%5Bterraform-aws+1.0.3%5D+)
