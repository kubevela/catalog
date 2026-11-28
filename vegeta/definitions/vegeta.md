---
title: vegeta
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/vegeta/versions.json';

<AddonVersion data={versions} current="12.8.4" page="definitions/vegeta" />

<!-- Generated from the definition. -->

**Type:** trait. **From:** the [vegeta](/addons/catalog/vegeta/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>backofflimit</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>0</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>parallelism</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>1</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>image</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>quay.io/karansingh/vegeta-ubi</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>restartPolicy</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>OnFailure</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>dorequest</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>vegetacli</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>vegeta attack -rate 5000 -duration 10000m | vegeta encode</code></span></div><div className="addon-param-desc"></div></div>
