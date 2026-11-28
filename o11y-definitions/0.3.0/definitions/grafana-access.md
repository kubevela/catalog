---
title: grafana-access
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/o11y-definitions/versions.json';

<AddonVersion data={versions} current="0.3.0" page="definitions/grafana-access" />

<!-- Generated from the definition. -->

The access credential for grafana.

**Type:** component. **From:** the [o11y-definitions](/addons/catalog/o11y-definitions/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>name</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">The name of the grafana instance.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>endpoint</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">The endpoint of the grafana instance.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>username</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">The username for access grafana</div></div>
<div className="addon-param"><div className="addon-param-head"><code>password</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">The password for access grafana</div></div>
<div className="addon-param"><div className="addon-param-head"><code>token</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">The usage for access grafana</div></div>
