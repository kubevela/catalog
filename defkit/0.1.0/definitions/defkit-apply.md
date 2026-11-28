---
title: defkit-apply
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/defkit/versions.json';

<AddonVersion data={versions} current="0.1.0" page="definitions/defkit-apply" />

<!-- Generated from the definition. -->

Apply the definitions a defkit-render step produced, as this Application's resources (experimental)

**Type:** workflow-step. **From:** the [defkit](/addons/catalog/defkit/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>configMap</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">The ConfigMap in vela-defkit the render step wrote</div></div>
<div className="addon-param"><div className="addon-param-head"><code>skip</code> <span className="addon-param-type">list</span></div><div className="addon-param-desc">Definitions to leave alone, as Kind/name</div></div>
