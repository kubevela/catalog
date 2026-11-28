---
title: install-datasource-from-addon
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/o11y-definitions/versions.json';

<AddonVersion data={versions} current="0.3.2" page="definitions/install-datasource-from-addon" />

<!-- Generated from the definition. -->

Discover datasource from addon for grafana.

**Type:** workflow-step. **From:** the [o11y-definitions](/addons/catalog/o11y-definitions/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>type</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>prometheus</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>addonName</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>addon-prometheus-server</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>addonNamespace</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>vela-system</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>portName</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>http</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>grafana</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>default</code></span></div><div className="addon-param-desc"></div></div>
