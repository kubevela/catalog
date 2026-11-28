---
title: read-app
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/vela-workflow/versions.json';

<AddonVersion data={versions} current="0.7.3" page="definitions/read-app" />

<!-- Generated from the definition. -->

Read application from the cluster

**Type:** workflow-step. **From:** the [vela-workflow](/addons/catalog/vela-workflow/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>name</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>namespace</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>context.namespace</code></span></div><div className="addon-param-desc"></div></div>
