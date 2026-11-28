---
title: resource-analytics
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/crane/versions.json';

<AddonVersion data={versions} current="0.5.0" page="definitions/resource-analytics" />

<!-- Generated from the definition. -->

Resource analytics gives you recommended values for resources in a cluster and use them to improve the resource utilization of the cluster.

**Type:** trait. **From:** the [crane](/addons/catalog/crane/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>analyzePeriod</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>86400</code></span></div><div className="addon-param-desc">Analyze resources every analyzePeriod seconds</div></div>
