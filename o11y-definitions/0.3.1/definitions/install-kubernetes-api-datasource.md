---
title: install-kubernetes-api-datasource
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/o11y-definitions/versions.json';

<AddonVersion data={versions} current="0.3.1" page="definitions/install-kubernetes-api-datasource" />

<!-- Generated from the definition. -->

Create Kubernetes API datasource.

**Type:** workflow-step. **From:** the [o11y-definitions](/addons/catalog/o11y-definitions/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>serviceAccountName</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>grafana</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>namespace</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>o11y-system</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>uid</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>kubernetes-api</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>grafana</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>default</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>endpoint</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>https://kubernetes.default</code></span></div><div className="addon-param-desc"></div></div>
