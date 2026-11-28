---
title: pod-cpu-load-by-names
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/chaosblade-operator/versions.json';

<AddonVersion data={versions} current="1.7.0" page="definitions/pod-cpu-load-by-names" />

<!-- Generated from the definition. -->

increase node cpu load by names

**Type:** trait. **From:** the [chaosblade-operator](/addons/catalog/chaosblade-operator/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>bladeName</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the name for ChaosBlade</div></div>
<div className="addon-param"><div className="addon-param-head"><code>cpuPercent</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Specify the cpuPercent</div></div>
<div className="addon-param"><div className="addon-param-head"><code>names</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Specify the names</div></div>
