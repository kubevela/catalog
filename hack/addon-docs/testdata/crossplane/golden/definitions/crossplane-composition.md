---
title: crossplane-composition
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/crossplane/versions.json';

<AddonVersion data={versions} current="1.0.0" page="definitions/crossplane-composition" />

<!-- Generated from the definition. -->

A Crossplane Composition: the pipeline of functions that builds a composite resource.

**Type:** component. **From:** the [crossplane](/addons/catalog/crossplane/) addon.

## Parameters


<details>
<summary><code>compositeTypeRef</code> (2) The composite resource this Composition builds, as its XRD defines it</summary>

<div className="addon-param"><div className="addon-param-head"><code>apiVersion</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">API group and version of the composite, e.g. example.org/v1</div></div>
<div className="addon-param"><div className="addon-param-head"><code>kind</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Kind of the composite, e.g. XDatabase</div></div>

</details>


<details>
<summary><code>pipeline[]</code> (3) Steps run in order, each calling a Function</summary>

<div className="addon-param"><div className="addon-param-head"><code>step</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Name of the step</div></div>
<div className="addon-param"><div className="addon-param-head"><code>function</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Name of the Function, as installed with crossplane-function</div></div>
<div className="addon-param"><div className="addon-param-head"><code>input</code> <span className="addon-param-type">map&#91;string&#93;any</span></div><div className="addon-param-desc">The function's input</div></div>

</details>

