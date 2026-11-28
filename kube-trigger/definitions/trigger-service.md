---
title: trigger-service
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/kube-trigger/versions.json';

<AddonVersion data={versions} current="1.0.0" page="definitions/trigger-service" />

<!-- Generated from the definition. -->

Trigger service integrates kube-trigger, allowing you to configure event triggers.

**Type:** component. **From:** the [kube-trigger](/addons/catalog/kube-trigger/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>namespace</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>vela-system</code></span></div><div className="addon-param-desc">The namespace of the trigger service to configure</div></div>
<div className="addon-param"><div className="addon-param-head"><code>name</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">The name of the trigger service</div></div>

<details>
<summary><code>triggers[]</code> (5) Trigger configurations. Refer to https://github.com/kubevela/kube-trigger for details.</summary>

<div className="addon-param"><div className="addon-param-head"><code>filter</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>

<details>
<summary><code>source</code> (2)</summary>

<div className="addon-param"><div className="addon-param-head"><code>type</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>properties</code> <span className="addon-param-type">map&#91;string&#93;any</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>

</details>


<details>
<summary><code>action</code> (2)</summary>

<div className="addon-param"><div className="addon-param-head"><code>type</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>properties</code> <span className="addon-param-type">map&#91;string&#93;any</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>

</details>


</details>

