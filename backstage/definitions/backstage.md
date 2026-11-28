---
title: backstage
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/backstage/versions.json';

<AddonVersion data={versions} current="1.2.0" page="definitions/backstage" />

<!-- Generated from the definition. -->

Mark backstage component information to help better integration.

**Type:** trait. **From:** the [backstage](/addons/catalog/backstage/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>type</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Specify the type of this backstage component</div></div>
<div className="addon-param"><div className="addon-param-head"><code>system</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Specify the system of this backstage component</div></div>
<div className="addon-param"><div className="addon-param-head"><code>lifecycle</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Specify the lifecycle of this backstage component</div></div>
<div className="addon-param"><div className="addon-param-head"><code>owner</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Specify the owner of this backstage component</div></div>
<div className="addon-param"><div className="addon-param-head"><code>description</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Add description for this backstage component</div></div>
<div className="addon-param"><div className="addon-param-head"><code>title</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Add title for this backstage component</div></div>
<div className="addon-param"><div className="addon-param-head"><code>tags</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Add tags for this backstage component</div></div>
<div className="addon-param"><div className="addon-param-head"><code>annotations</code> <span className="addon-param-type">map&#91;string&#93;any</span></div><div className="addon-param-desc">Add well-known-annotations(https://backstage.io/docs/features/software-catalog/well-known-annotations) for this backstage component</div></div>
<div className="addon-param"><div className="addon-param-head"><code>labels</code> <span className="addon-param-type">map&#91;string&#93;any</span></div><div className="addon-param-desc">Add labels for this backstage component</div></div>

<details>
<summary><code>links[]</code> (4) Add links for this backstage component</summary>

<div className="addon-param"><div className="addon-param-head"><code>url</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Specify the url of this link</div></div>
<div className="addon-param"><div className="addon-param-head"><code>title</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Specify the title of this link</div></div>
<div className="addon-param"><div className="addon-param-head"><code>icon</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Specify the icon of this link</div></div>
<div className="addon-param"><div className="addon-param-head"><code>type</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Specify the type of this link</div></div>

</details>

