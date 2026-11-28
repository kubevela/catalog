---
title: Parameters
sidebar_position: 2
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/kube-trigger/versions.json';

<AddonVersion data={versions} current="1.0.0" page="parameters" />

<!-- Generated from the addon's parameter.cue. -->

Set them when you enable the addon, `vela addon enable kube-trigger <name>=<value>`, or in VelaUX's addon form.

<div className="addon-param"><div className="addon-param-head"><code>image</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>oamdev/kube-trigger-manager</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>imagePullPolicy</code> <span className="addon-param-type">IfNotPresent or Never or Always</span> <span className="addon-param-default">default <code>IfNotPresent</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>version</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>v0.1.0</code></span></div><div className="addon-param-desc"></div></div>

<details>
<summary><code>resources</code> (4)</summary>


<details>
<summary><code>requests</code> (2)</summary>

<div className="addon-param"><div className="addon-param-head"><code>cpu</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>10m</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>memory</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>64Mi</code></span></div><div className="addon-param-desc"></div></div>

</details>


<details>
<summary><code>limits</code> (2)</summary>

<div className="addon-param"><div className="addon-param-head"><code>cpu</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>500m</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>memory</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>1Gi</code></span></div><div className="addon-param-desc"></div></div>

</details>


</details>

