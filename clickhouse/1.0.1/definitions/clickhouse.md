---
title: clickhouse
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/clickhouse/versions.json';

<AddonVersion data={versions} current="1.0.1" page="definitions/clickhouse" />

<!-- Generated from the definition. -->

Clickhouse Component provision a clickhouse cluster.

**Type:** component. **From:** the [clickhouse](/addons/catalog/clickhouse/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>annotations</code> <span className="addon-param-type">map&#91;string&#93;string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>labels</code> <span className="addon-param-type">map&#91;string&#93;string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>svcPortType</code> <span className="addon-param-type">ClusterIP or NodePort or LoadBalancer</span> <span className="addon-param-default">default <code>ClusterIP</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>password</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>default</code></span></div><div className="addon-param-desc"></div></div>

<details>
<summary><code>storage</code> (2)</summary>

<div className="addon-param"><div className="addon-param-head"><code>size</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>class</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>local-path</code></span></div><div className="addon-param-desc"></div></div>

</details>

