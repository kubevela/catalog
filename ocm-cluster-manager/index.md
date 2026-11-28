---
title: ocm-cluster-manager
sidebar_label: Overview
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/ocm-cluster-manager/versions.json';

<AddonVersion data={versions} current="1.0.0" page="" />

<!-- Generated from the addon's files in kubevela/catalog. Edit them there, not here. -->

<div className="addon-logo">

![ocm-cluster-manager logo](./logo.svg)

</div>

Ocm-cluster-manager can deploy an OCM hub cluster environment.

<dl className="addon-facts">
<dt>Addon version</dt>
<dd>

1.0.0

</dd>
<dt>Released</dt>
<dd>

2021-11-07

</dd>
<dt>KubeVela</dt>
<dd>

any

</dd>
<dt>Upstream</dt>
<dd>

[https://github.com/open-cluster-management-io/OCM](https://github.com/open-cluster-management-io/OCM)

</dd>
<dt>Tags</dt>
<dd>

multicluster

</dd>
<dt>Source</dt>
<dd>

[kubevela/catalog: addons/ocm-cluster-manager](https://github.com/kubevela/catalog/tree/release/ocm-cluster-manager/1.0.0/addons/ocm-cluster-manager)

</dd>
</dl>

## Install

### With the CLI

```shell
vela addon enable ocm-cluster-manager
```


```shell
vela addon disable ocm-cluster-manager
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
    - name: ocm-cluster-manager
      type: addon
      properties:
        version: "1.0.0"
```

## More

- [Guide](./guide): how to use the addon, from its README.
- [Versions](/addons/catalog/ocm-cluster-manager/versions): 1 release of the addon and what each needs.
## Feedback

Found something wrong, or missing something you need? Tell us in kubevela/catalog:

- [Report an issue](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+ocm-cluster-manager+1.0.0%0A%0A%23%23%23+Describe+the+issue%0A%0A%3C%21--+What+happened%2C+and+what+you+expected+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Fbug&title=%5Bocm-cluster-manager+1.0.0%5D+)
- [Request an enhancement](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+ocm-cluster-manager+1.0.0%0A%0A%23%23%23+What+would+help%0A%0A%3C%21--+What+you%27d+like+the+addon+to+do%2C+and+what+it+would+let+you+do+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Ffeature&title=%5Bocm-cluster-manager+1.0.0%5D+)
