---
title: prometheus-scrape
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/prometheus-server/versions.json';

<AddonVersion data={versions} current="0.3.3" page="definitions/prometheus-scrape" />

<!-- Generated from the definition. -->

Expose port and allow prometheus to scrape the service.

**Type:** trait. **From:** the [prometheus-server](/addons/catalog/prometheus-server/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>port</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>8080</code></span></div><div className="addon-param-desc">Specify the port to be scraped</div></div>
<div className="addon-param"><div className="addon-param-head"><code>path</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>/metrics</code></span></div><div className="addon-param-desc">Specify the path to be scraped</div></div>
<div className="addon-param"><div className="addon-param-head"><code>selector</code> <span className="addon-param-type">map&#91;string&#93;string</span></div><div className="addon-param-desc">Specify the selector of the service. In most cases, you don't need to set it.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>type</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>ClusterIP</code></span></div><div className="addon-param-desc">Specify the service type.</div></div>
