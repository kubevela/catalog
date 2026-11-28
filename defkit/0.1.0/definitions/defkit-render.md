---
title: defkit-render
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/defkit/versions.json';

<AddonVersion data={versions} current="0.1.0" page="definitions/defkit-render" />

<!-- Generated from the definition. -->

Render a DefKit module in a Job into a ConfigMap of definitions (experimental)

**Type:** workflow-step. **From:** the [defkit](/addons/catalog/defkit/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>ref</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Go module path of the module; or set git</div></div>
<div className="addon-param"><div className="addon-param-head"><code>git</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Git repository of the module, in place of ref</div></div>
<div className="addon-param"><div className="addon-param-head"><code>version</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Module version; with git, a branch, tag or commit</div></div>
<div className="addon-param"><div className="addon-param-head"><code>prefix</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Prefix for every definition name</div></div>
<div className="addon-param"><div className="addon-param-head"><code>types</code> <span className="addon-param-type">list</span></div><div className="addon-param-desc">Definition types to render; all when empty</div></div>
