---
title: Parameters
sidebar_position: 2
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/sample/versions.json';

<AddonVersion data={versions} current="1.0.0" page="parameters" />

<!-- Generated from the addon's parameter.cue. -->

Set them when you enable the addon, `vela addon enable sample <name>=<value>`, or in VelaUX's addon form.

<div className="addon-param"><div className="addon-param-head"><code>namespace</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>sample</code></span></div><div className="addon-param-desc">Namespace to install into</div></div>
<div className="addon-param"><div className="addon-param-head"><code>replicas</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>1</code></span></div><div className="addon-param-desc">How many replicas to run</div></div>
<div className="addon-param"><div className="addon-param-head"><code>installWith</code> <span className="addon-param-type">vela or flux or argo</span> <span className="addon-param-default">default <code>vela</code></span></div><div className="addon-param-desc">What installs it.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>clusters</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Clusters to install on. Leave it out for every cluster</div></div>
<div className="addon-param"><div className="addon-param-head"><code>labels</code> <span className="addon-param-type">map&#91;string&#93;string</span></div><div className="addon-param-desc">Labels on every object</div></div>

<details>
<summary><code>resources</code> (2) CPU and memory for each pod</summary>


<details>
<summary><code>requests</code> (2) What each pod asks for</summary>

<div className="addon-param"><div className="addon-param-head"><code>cpu</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>memory</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>

</details>


</details>


<details>
<summary><code>extraArgs[]</code> (2) Extra flags, one entry each</summary>

<div className="addon-param"><div className="addon-param-head"><code>name</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Flag name</div></div>
<div className="addon-param"><div className="addon-param-head"><code>value</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Flag value</div></div>

</details>

