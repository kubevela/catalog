---
title: model-serving
sidebar_label: Overview
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/model-serving/versions.json';

<AddonVersion data={versions} current="1.0.1" page="" />

<!-- Generated from the addon's files in kubevela/catalog. Edit them there, not here. -->

Enable serving for models.

<dl className="addon-facts">
<dt>Addon version</dt>
<dd>

1.0.1

</dd>
<dt>Released</dt>
<dd>

2023-06-13

</dd>
<dt>KubeVela</dt>
<dd>

any

</dd>
<dt>Kubernetes</dt>
<dd>

`<1.22`

</dd>
<dt>Needs</dt>
<dd>

[fluxcd](/addons/catalog/fluxcd/)

</dd>
<dt>Tags</dt>
<dd>

ai, serving, alpha

</dd>
<dt>Source</dt>
<dd>

[kubevela/catalog: addons/model-serving](https://github.com/kubevela/catalog/tree/release/model-serving/1.0.1/addons/model-serving)

</dd>
</dl>

## Install

### With the CLI

```shell
vela addon enable model-serving
```


```shell
vela addon disable model-serving
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
    - name: model-serving
      type: addon
      properties:
        version: "1.0.1"
```

## More

- [Guide](./guide): how to use the addon, from its README.
- [Versions](/addons/catalog/model-serving/versions): 2 releases of the addon and what each needs.
## Feedback

Found something wrong, or missing something you need? Tell us in kubevela/catalog:

- [Report an issue](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+model-serving+1.0.1%0A%0A%23%23%23+Describe+the+issue%0A%0A%3C%21--+What+happened%2C+and+what+you+expected+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Fbug&title=%5Bmodel-serving+1.0.1%5D+)
- [Request an enhancement](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+model-serving+1.0.1%0A%0A%23%23%23+What+would+help%0A%0A%3C%21--+What+you%27d+like+the+addon+to+do%2C+and+what+it+would+let+you+do+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Ffeature&title=%5Bmodel-serving+1.0.1%5D+)
