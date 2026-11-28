---
title: grafana-definitions
sidebar_label: Overview
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/grafana-definitions/versions.json';

<AddonVersion data={versions} current="0.2.2" page="" />

<!-- Generated from the addon's files in kubevela/catalog. Edit them there, not here. -->

<div className="addon-logo">

![grafana-definitions logo](./logo.jpg)

</div>

Grafana definitions is an auxiliary addon that creates definitions for grafana installation and use.

<dl className="addon-facts">
<dt>Addon version</dt>
<dd>

0.2.2

</dd>
<dt>Released</dt>
<dd>

2022-10-18

</dd>
<dt>KubeVela</dt>
<dd>

`>=v1.6.0-alpha.4`

</dd>
<dt>Upstream</dt>
<dd>

[https://grafana.com/](https://grafana.com/)

</dd>
<dt>Needs</dt>
<dd>

[vela-prism](/addons/catalog/vela-prism/)

</dd>
<dt>Tags</dt>
<dd>

Observability, Kubernetes, Grafana

</dd>
<dt>Source</dt>
<dd>

[kubevela/catalog: addons/grafana-definitions](https://github.com/kubevela/catalog/tree/release/grafana-definitions/v0.2.2/addons/grafana-definitions)

</dd>
</dl>

## Install

### With the CLI

```shell
vela addon enable grafana-definitions
```


```shell
vela addon disable grafana-definitions
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
    - name: grafana-definitions
      type: addon
      properties:
        version: "0.2.2"
```

## Definitions

| Definition | Type | What it does |
| --- | --- | --- |
| [`grafana-access`](./definitions/grafana-access) |  | Doesn't load: see its page. |
| [`grafana-dashboard`](./definitions/grafana-dashboard) |  | Doesn't load: see its page. |
| [`grafana-datasource`](./definitions/grafana-datasource) |  | Doesn't load: see its page. |
| [`import-grafana-dashboard`](./definitions/import-grafana-dashboard) | Workflow-step | Import dashboard to grafana. |
| [`install-datasource-from-addon`](./definitions/install-datasource-from-addon) |  | Doesn't load: see its page. |
| [`install-kubernetes-api-datasource`](./definitions/install-kubernetes-api-datasource) |  | Doesn't load: see its page. |
## More

- [Guide](./guide): how to use the addon, from its README.
- [Versions](/addons/catalog/grafana-definitions/versions): 4 releases of the addon and what each needs.
## Feedback

Found something wrong, or missing something you need? Tell us in kubevela/catalog:

- [Report an issue](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+grafana-definitions+0.2.2%0A%0A%23%23%23+Describe+the+issue%0A%0A%3C%21--+What+happened%2C+and+what+you+expected+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Fbug&title=%5Bgrafana-definitions+0.2.2%5D+)
- [Request an enhancement](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+grafana-definitions+0.2.2%0A%0A%23%23%23+What+would+help%0A%0A%3C%21--+What+you%27d+like+the+addon+to+do%2C+and+what+it+would+let+you+do+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Ffeature&title=%5Bgrafana-definitions+0.2.2%5D+)
