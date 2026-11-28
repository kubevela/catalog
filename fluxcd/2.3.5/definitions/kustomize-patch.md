---
title: kustomize-patch
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/fluxcd/versions.json';

<AddonVersion data={versions} current="2.3.5" page="definitions/kustomize-patch" />

<!-- Generated from the definition. -->

A list of StrategicMerge or JSON6902 patch to selected target

**Type:** trait. **From:** the [fluxcd](/addons/catalog/fluxcd/) addon.

## Parameters


<details>
<summary><code>patches[]</code> (8) a list of StrategicMerge or JSON6902 patch to selected target</summary>

<div className="addon-param"><div className="addon-param-head"><code>patch</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Inline patch string, in yaml style</div></div>

<details>
<summary><code>target</code> (7) Specify the target the patch should be applied to</summary>

<div className="addon-param"><div className="addon-param-head"><code>group</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>version</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>kind</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>namespace</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>name</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>annotationSelector</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>labelSelector</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>

</details>


</details>

