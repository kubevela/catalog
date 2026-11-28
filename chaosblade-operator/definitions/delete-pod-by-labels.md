---
title: chaosblade-delete-pod-by-labels
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/chaosblade-operator/versions.json';

<AddonVersion data={versions} current="1.7.0" page="definitions/delete-pod-by-labels" />

<!-- Generated from the definition. -->

delete pod by labels

**Type:** trait. **From:** the [chaosblade-operator](/addons/catalog/chaosblade-operator/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>bladeName</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the name for ChaosBlade</div></div>
<div className="addon-param"><div className="addon-param-head"><code>labels</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Specify the labels</div></div>
<div className="addon-param"><div className="addon-param-head"><code>nsName</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Specify the ns names</div></div>
<div className="addon-param"><div className="addon-param-head"><code>counts</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Specify the evict counts</div></div>
