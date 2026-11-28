---
title: mysql-exporter
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/mysql-exporter/versions.json';

<AddonVersion data={versions} current="0.0.1" page="definitions/mysql-exporter-trait" />

<!-- Generated from the definition. -->

**Type:** trait. **From:** the [mysql-exporter](/addons/catalog/mysql-exporter/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>name</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>mysql-server-exporter</code></span></div><div className="addon-param-desc">Specify the name of the Exporter.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>mysqlHost</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>mysql-server</code></span></div><div className="addon-param-desc">Specify the host of the target Mysql server, maybe you could set the mysql component name.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>mysqlPort</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>3306</code></span></div><div className="addon-param-desc">Specify the port of the target Mysql server.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>username</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the username of the target Mysql server.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>password</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the password of the target Mysql server.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>version</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>v0.14.0</code></span></div><div className="addon-param-desc">Specify the version of the Exporter collector.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>cpu</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Specify the CPU capacity of the Exporter collector.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>memory</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Specify the Memory capacity of the Exporter collector.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>disableAnnotation</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">Disable annotation means do not add the annotations for the exporter pod, and the Prometheus can not scrape it.</div></div>
