---
title: o11y-definitions
sidebar_label: Overview
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/o11y-definitions/versions.json';

<AddonVersion data={versions} current="0.3.0" page="" />

<!-- Generated from the addon's files in kubevela/catalog. Edit them there, not here. -->

Grafana definitions is an auxiliary addon that creates definitions for grafana installation and use.

<dl className="addon-facts">
<dt>Addon version</dt>
<dd>

0.3.0

</dd>
<dt>Released</dt>
<dd>

2023-06-13

</dd>
<dt>KubeVela</dt>
<dd>

`>=v1.7.0`

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

Official, Observability, Kubernetes, Grafana

</dd>
<dt>Source</dt>
<dd>

[kubevela/catalog: addons/o11y-definitions](https://github.com/kubevela/catalog/tree/release/o11y-definitions/v0.3.0/addons/o11y-definitions)

</dd>
</dl>

## Install

### With the CLI

```shell
vela addon enable o11y-definitions
```


```shell
vela addon disable o11y-definitions
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
    - name: o11y-definitions
      type: addon
      properties:
        version: "0.3.0"
```

## Definitions

| Definition | Type | What it does |
| --- | --- | --- |
| [`grafana-access`](./definitions/grafana-access) | Component | The access credential for grafana. |
| [`grafana-dashboard`](./definitions/grafana-dashboard-trait) | Trait | The dashboard for grafana. |
| [`grafana-dashboard`](./definitions/grafana-dashboard) | Component | The dashboard for grafana. |
| [`grafana-datasource`](./definitions/grafana-datasource) | Component | The datasource for grafana. |
| [`import-grafana-dashboard`](./definitions/import-grafana-dashboard) | Workflow-step | Import dashboard to grafana. |
| [`install-datasource-from-addon`](./definitions/install-datasource-from-addon) | Workflow-step | Discover datasource from addon for grafana. |
| [`install-datasource-from-config`](./definitions/install-datasource-from-config) | Workflow-step | Discover datasource from the config system for grafana. |
| [`install-kubernetes-api-datasource`](./definitions/install-kubernetes-api-datasource) | Workflow-step | Create Kubernetes API datasource. |
## More

- [Guide](./guide): how to use the addon, from its README.
- [Versions](/addons/catalog/o11y-definitions/versions): 8 releases of the addon and what each needs.
## Feedback

Found something wrong, or missing something you need? Tell us in kubevela/catalog:

- [Report an issue](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+o11y-definitions+0.3.0%0A%0A%23%23%23+Describe+the+issue%0A%0A%3C%21--+What+happened%2C+and+what+you+expected+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Fbug&title=%5Bo11y-definitions+0.3.0%5D+)
- [Request an enhancement](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+o11y-definitions+0.3.0%0A%0A%23%23%23+What+would+help%0A%0A%3C%21--+What+you%27d+like+the+addon+to+do%2C+and+what+it+would+let+you+do+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Ffeature&title=%5Bo11y-definitions+0.3.0%5D+)
