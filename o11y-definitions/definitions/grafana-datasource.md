---
title: grafana-datasource
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/o11y-definitions/versions.json';

<AddonVersion data={versions} current="0.3.2" page="definitions/grafana-datasource" />

<!-- Generated from the definition. -->

The datasource for grafana.

**Type:** component. **From:** the [o11y-definitions](/addons/catalog/o11y-definitions/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>grafana</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>default</code></span></div><div className="addon-param-desc">The name of the grafana instance.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>uid</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">The uid of the grafana datasource.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>data</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">The json model of the grafana datasource</div></div>
