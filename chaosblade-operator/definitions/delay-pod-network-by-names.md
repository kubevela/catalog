---
title: delay-pod-network-by-names
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/chaosblade-operator/versions.json';

<AddonVersion data={versions} current="1.7.0" page="definitions/delay-pod-network-by-names" />

<!-- Generated from the definition. -->

delay pod network by names

**Type:** trait. **From:** the [chaosblade-operator](/addons/catalog/chaosblade-operator/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>bladeName</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the name for ChaosBlade</div></div>
<div className="addon-param"><div className="addon-param-head"><code>podName</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Specify the pod names</div></div>
<div className="addon-param"><div className="addon-param-head"><code>nsName</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Specify the ns names</div></div>
<div className="addon-param"><div className="addon-param-head"><code>ports</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Specify the ports</div></div>
<div className="addon-param"><div className="addon-param-head"><code>interfaces</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Specify the interfaces</div></div>
<div className="addon-param"><div className="addon-param-head"><code>time</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Specify the time</div></div>
<div className="addon-param"><div className="addon-param-head"><code>offset</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Specify the offset</div></div>
