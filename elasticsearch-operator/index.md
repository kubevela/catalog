---
title: elasticsearch-operator
sidebar_label: Overview
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/elasticsearch-operator/versions.json';

<AddonVersion data={versions} current="1.0.0" page="" />

<!-- Generated from the addon's files in kubevela/catalog. Edit them there, not here. -->

<div className="addon-logo">

![elasticsearch-operator logo](./logo.png)

</div>

:::caution Experimental
This addon is in the catalog's experimental registry: enable it with `vela addon registry add experimental --type helm --endpoint=https://kubevela.github.io/catalog/experimental/` first.
:::

This addon adds elasticsearch-operator to the kubevela to be used across the application installed in kubevela.

<dl className="addon-facts">
<dt>Addon version</dt>
<dd>

1.0.0

</dd>
<dt>Released</dt>
<dd>

2023-06-30

</dd>
<dt>KubeVela</dt>
<dd>

any

</dd>
<dt>Upstream</dt>
<dd>

[https://www.elastic.co/](https://www.elastic.co/)

</dd>
<dt>Needs</dt>
<dd>

[fluxcd](/addons/catalog/fluxcd/)

</dd>
<dt>Tags</dt>
<dd>

elasticsearch-operator

</dd>
<dt>Source</dt>
<dd>

[kubevela/catalog: experimental/addons/elasticsearch-operator](https://github.com/kubevela/catalog/tree/release/elasticsearch-operator/1.0.0/experimental/addons/elasticsearch-operator)

</dd>
</dl>

## Install

### With the CLI

```shell
vela addon enable elasticsearch-operator
```

Set [parameters](./parameters) as `key=value` on the same command.

```shell
vela addon disable elasticsearch-operator
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
    - name: elasticsearch-operator
      type: addon
      properties:
        registry: experimental
        version: "1.0.0"
        properties:
          namespace: "elasticsearch-operator"
```

## Definitions

| Definition | Type | What it does |
| --- | --- | --- |
| [`elasticsearch-apm-server`](./definitions/elasticsearch-apm-server) | Component | elasticsearch apm server component |
| [`elasticsearch-cluster`](./definitions/elasticsearch-cluster) | Component | elasticsearch cluster component |
| [`elasticsearch-enterprise-search`](./definitions/elasticsearch-enterprise-search) | Component | elasticsearch enterprise search |
| [`kibana`](./definitions/kibana) | Component | kibana component |
## More

- [Parameters](./parameters): everything `vela addon enable` takes.
- [Guide](./guide): how to use the addon, from its README.
- [Versions](/addons/catalog/elasticsearch-operator/versions): 1 release of the addon and what each needs.
## Feedback

Found something wrong, or missing something you need? Tell us in kubevela/catalog:

- [Report an issue](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+elasticsearch-operator+1.0.0%0A%0A%23%23%23+Describe+the+issue%0A%0A%3C%21--+What+happened%2C+and+what+you+expected+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Fbug&title=%5Belasticsearch-operator+1.0.0%5D+)
- [Request an enhancement](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+elasticsearch-operator+1.0.0%0A%0A%23%23%23+What+would+help%0A%0A%3C%21--+What+you%27d+like+the+addon+to+do%2C+and+what+it+would+let+you+do+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Ffeature&title=%5Belasticsearch-operator+1.0.0%5D+)
