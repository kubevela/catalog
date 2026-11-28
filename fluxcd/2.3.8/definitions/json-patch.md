---
title: kustomize-json-patch
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/fluxcd/versions.json';

<AddonVersion data={versions} current="2.3.8" page="definitions/json-patch" />

<!-- Generated from the definition. -->

A list of JSON6902 patch to selected target

**Type:** trait. **From:** the [fluxcd](/addons/catalog/fluxcd/) addon.

## Parameters


<details>
<summary><code>patchesJson[]</code> (11) A list of JSON6902 patch.</summary>


<details>
<summary><code>target</code> (7)</summary>

<div className="addon-param"><div className="addon-param-head"><code>group</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>version</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>kind</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>namespace</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>name</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>annotationSelector</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>labelSelector</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>

</details>


<details>
<summary><code>patch[]</code> (4)</summary>

<div className="addon-param"><div className="addon-param-head"><code>op</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Operation to perform</div></div>
<div className="addon-param"><div className="addon-param-head"><code>path</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Operate path e.g. /foo/bar</div></div>
<div className="addon-param"><div className="addon-param-head"><code>from</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Specify source path when op is copy/move</div></div>
<div className="addon-param"><div className="addon-param-head"><code>value</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Specify opraation value when op is test/add/replace</div></div>

</details>


</details>

