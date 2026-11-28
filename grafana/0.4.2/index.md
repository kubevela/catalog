---
title: grafana
sidebar_label: Overview
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/grafana/versions.json';

<AddonVersion data={versions} current="0.4.2" page="" />

<!-- Generated from the addon's files in kubevela/catalog. Edit them there, not here. -->

Grafana is a multi-platform open source analytics and interactive visualization web application. It provides charts, graphs, and alerts for the web when connected to supported data sources.

<dl className="addon-facts">
<dt>Addon version</dt>
<dd>

0.4.2

</dd>
<dt>Released</dt>
<dd>

2023-03-13

</dd>
<dt>KubeVela</dt>
<dd>

`>=v1.8.0-alpha.3`

</dd>
<dt>Upstream</dt>
<dd>

[https://grafana.com/](https://grafana.com/)

</dd>
<dt>Needs</dt>
<dd>

[o11y-definitions](/addons/catalog/o11y-definitions/)

</dd>
<dt>Tags</dt>
<dd>

Official, Observability, Kubernetes, Grafana

</dd>
<dt>Source</dt>
<dd>

[kubevela/catalog: addons/grafana](https://github.com/kubevela/catalog/tree/release/grafana/v0.4.2/addons/grafana)

</dd>
</dl>

## Install

### With the CLI

```shell
vela addon enable grafana
```

Set [parameters](./parameters) as `key=value` on the same command.

```shell
vela addon disable grafana
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
    - name: grafana
      type: addon
      properties:
        version: "0.4.2"
        properties:
          install: true
```

## More

- [Parameters](./parameters): everything `vela addon enable` takes.
- [Guide](./guide): how to use the addon, from its README.
- [Versions](/addons/catalog/grafana/versions): 11 releases of the addon and what each needs.
## Feedback

Found something wrong, or missing something you need? Tell us in kubevela/catalog:

- [Report an issue](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+grafana+0.4.2%0A%0A%23%23%23+Describe+the+issue%0A%0A%3C%21--+What+happened%2C+and+what+you+expected+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Fbug&title=%5Bgrafana+0.4.2%5D+)
- [Request an enhancement](https://github.com/kubevela/catalog/issues/new?body=%2A%2AAddon%3A%2A%2A+grafana+0.4.2%0A%0A%23%23%23+What+would+help%0A%0A%3C%21--+What+you%27d+like+the+addon+to+do%2C+and+what+it+would+let+you+do+--%3E%0A%0A%23%23%23+Environment%0A%0A-+KubeVela+version%3A%0A-+Kubernetes+version%3A%0A&labels=type%2Ffeature&title=%5Bgrafana+0.4.2%5D+)
