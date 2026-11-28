---
title: apply-app
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/vela-workflow/versions.json';

<AddonVersion data={versions} current="0.6.3" page="definitions/apply-app" />

<!-- Generated from the definition. -->

Apply application from data or ref to the cluster

**Type:** workflow-step. **From:** the [vela-workflow](/addons/catalog/vela-workflow/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>data</code> <span className="addon-param-type">map&#91;string&#93;any</span></div><div className="addon-param-desc"></div></div>

<details>
<summary><code>ref</code> (4)</summary>

<div className="addon-param"><div className="addon-param-head"><code>name</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>namespace</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>context.namespace</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>type</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>configMap</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>key</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>application</code></span></div><div className="addon-param-desc"></div></div>

</details>

