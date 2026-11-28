---
title: ocm-gateway-manager-addon
sidebar_label: Overview
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/ocm-gateway-manager-addon/versions.json';

<AddonVersion data={versions} current="1.4.0" page="" />

<!-- Generated from the addon's files in kubevela/catalog. Edit them there, not here. -->

<div className="addon-logo">

![ocm-gateway-manager-addon logo](./logo.svg)

</div>

Ocm-gateway-manager-addon is the OCM addon automates the cluster-gateway apiserver.

<dl className="addon-facts">
<dt>Addon version</dt>
<dd>

1.4.0

</dd>
<dt>Released</dt>
<dd>

2022-06-14

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

[kubevela/catalog: addons/ocm-gateway-manager-addon](https://github.com/kubevela/catalog/tree/release/ocm-gateway-manager-addon/1.4.0/addons/ocm-gateway-manager-addon)

</dd>
</dl>

## Install

### With the CLI

```shell
vela addon enable ocm-gateway-manager-addon
```


```shell
vela addon disable ocm-gateway-manager-addon
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
    - name: ocm-gateway-manager-addon
      type: addon
      properties:
        version: "1.4.0"
```

## More

- [Guide](./guide): how to use the addon, from its README.
- [Versions](/addons/catalog/ocm-gateway-manager-addon/versions): 5 releases of the addon and what each needs.
## Feedback

Found something wrong, or missing something you need? Tell us in kubevela/catalog:

- [Report an issue](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+ocm-gateway-manager-addon+1.4.0%0A%0A%23%23%23+Describe+the+issue%0A%0A%3C%21--+What+happened%2C+and+what+you+expected+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Fbug&title=%5Bocm-gateway-manager-addon+1.4.0%5D+)
- [Request an enhancement](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+ocm-gateway-manager-addon+1.4.0%0A%0A%23%23%23+What+would+help%0A%0A%3C%21--+What+you%27d+like+the+addon+to+do%2C+and+what+it+would+let+you+do+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Ffeature&title=%5Bocm-gateway-manager-addon+1.4.0%5D+)
