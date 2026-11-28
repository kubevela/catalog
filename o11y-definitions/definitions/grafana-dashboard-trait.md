---
title: grafana-dashboard
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/o11y-definitions/versions.json';

<AddonVersion data={versions} current="0.3.2" page="definitions/grafana-dashboard-trait" />

<!-- Generated from the definition. -->

The dashboard for grafana.

**Type:** trait. **From:** the [o11y-definitions](/addons/catalog/o11y-definitions/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>grafana</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>default</code></span></div><div className="addon-param-desc">The name of the grafana instance.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>uid</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">The uid of the grafana dashboard, if not specified, the default uid will be used.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>title</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">The title of the grafana dashboard, if not specified, the default title will be used.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>data</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">The json model of the grafana dashboard</div></div>
