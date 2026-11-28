---
title: Parameters
sidebar_position: 2
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/vela-workflow/versions.json';

<AddonVersion data={versions} current="0.6.1" page="parameters" />

<!-- Generated from the addon's parameter.cue. -->

Set them when you enable the addon, `vela addon enable vela-workflow <name>=<value>`, or in VelaUX's addon form.

<div className="addon-param"><div className="addon-param-head"><code>image</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>oamdev/vela-workflow</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>version</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>0.6.0</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>imagePullPolicy</code> <span className="addon-param-type">IfNotPresent or Never or Always</span> <span className="addon-param-default">default <code>IfNotPresent</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>concurrentReconciles</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>4</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>kubeQPS</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>50</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>kubeBurst</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>100</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>maxWorkflowWaitBackoffTime</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>60</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>maxWorkflowFailedBackoffTime</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>300</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>maxWorkflowStepErrorRetryTimes</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>10</code></span></div><div className="addon-param-desc"></div></div>

<details>
<summary><code>resources</code> (4)</summary>


<details>
<summary><code>requests</code> (2)</summary>

<div className="addon-param"><div className="addon-param-head"><code>cpu</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>50m</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>memory</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>20Mi</code></span></div><div className="addon-param-desc"></div></div>

</details>


<details>
<summary><code>limits</code> (2)</summary>

<div className="addon-param"><div className="addon-param-head"><code>cpu</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>500m</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>memory</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>1Gi</code></span></div><div className="addon-param-desc"></div></div>

</details>


</details>

