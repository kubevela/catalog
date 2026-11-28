---
title: stdout-logs
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/loki/versions.json';

<AddonVersion data={versions} current="0.3.1" page="definitions/stdout-logs" />

<!-- Generated from the definition. -->

ETL transformer for application log

**Type:** trait. **From:** the [loki](/addons/catalog/loki/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>grafana</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>default</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>parser</code> <span className="addon-param-type">nginx or apache or customize</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>VRL</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>lokiEndpoint</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>http://loki:3100/</code></span></div><div className="addon-param-desc"></div></div>
