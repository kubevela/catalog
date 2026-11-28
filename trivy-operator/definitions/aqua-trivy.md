---
title: trivy-check
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/trivy-operator/versions.json';

<AddonVersion data={versions} current="3.1.2" page="definitions/aqua-trivy" />

<!-- Generated from the definition. -->

**Type:** workflow-step. **From:** the [trivy-operator](/addons/catalog/trivy-operator/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>level</code> <span className="addon-param-type">list</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>showDetail</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>true</code></span></div><div className="addon-param-desc"></div></div>

<details>
<summary><code>resource</code> (2)</summary>

<div className="addon-param"><div className="addon-param-head"><code>kind</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>Deployment</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>name</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>

</details>

