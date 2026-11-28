---
title: addon-operation
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/vela-workflow/versions.json';

<AddonVersion data={versions} current="0.6.0" page="definitions/addon-operation" />

<!-- Generated from the definition. -->

Enable a KubeVela addon

**Type:** workflow-step. **From:** the [vela-workflow](/addons/catalog/vela-workflow/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>addonName</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the name of the addon.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>args</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Specify addon enable args.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>image</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>oamdev/vela-cli:v1.7.2</code></span></div><div className="addon-param-desc">Specify the image</div></div>
<div className="addon-param"><div className="addon-param-head"><code>operation</code> <span className="addon-param-type">enable or upgrade or disable</span> <span className="addon-param-default">default <code>enable</code></span></div><div className="addon-param-desc">Operation for the addon</div></div>
<div className="addon-param"><div className="addon-param-head"><code>serviceAccountName</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>kubevela-vela-core</code></span></div><div className="addon-param-desc">Specify serviceAccountName want to use</div></div>
