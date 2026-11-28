---
title: helm-labels
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/fluxcd/versions.json';

<AddonVersion data={versions} current="3.0.0" page="definitions/helm-labels" />

<!-- Generated from the definition. -->

Patch labels of Pods created by workloads defined in Helm Charts.

**Type:** trait. **From:** the [fluxcd](/addons/catalog/fluxcd/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>apiVersion</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>apps/v1</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>kind</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>Deployment</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>name</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>context.name</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>namespace</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>context.namespace</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>labels</code> <span className="addon-param-type">map&#91;string&#93;string</span></div><div className="addon-param-desc"></div></div>
