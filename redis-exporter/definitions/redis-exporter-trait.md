---
title: redis-exporter
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/redis-exporter/versions.json';

<AddonVersion data={versions} current="0.0.1" page="definitions/redis-exporter-trait" />

<!-- Generated from the definition. -->

**Type:** trait. **From:** the [redis-exporter](/addons/catalog/redis-exporter/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>name</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>redis-server-exporter</code></span></div><div className="addon-param-desc">Specify the name of the Exporter.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>address</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>localhost</code></span></div><div className="addon-param-desc">Address of the Redis instance.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>serectName</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>redis-secret</code></span></div><div className="addon-param-desc">Secret name indidcates the secret that contains the username and password of the Redis instance.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>cpu</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Specify the CPU capacity of the Exporter collector.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>memory</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Specify the Memory capacity of the Exporter collector.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>disableAnnotation</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">Disable annotation means do not add the annotations for the exporter pod, and the Prometheus can not scrape it.</div></div>
