---
title: game-server-set
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/kruise-game/versions.json';

<AddonVersion data={versions} current="1.0.0" page="definitions/game-server-set" />

<!-- Generated from the definition. -->

game server set component

**Type:** component. **From:** the [kruise-game](/addons/catalog/kruise-game/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>gameServerTemplate</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">INSERT ADDITIONAL SPEC FIELDS - desired state of cluster Important: Run "make" to regenerate code after modifying this file</div></div>
<div className="addon-param"><div className="addon-param-head"><code>network</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Configure Network.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>replicas</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>1</code></span></div><div className="addon-param-desc">Replicas is the desired number of replicas of the given Template. These are replicas in the sense that they are instantiations of the same Template, but individual replicas also have a consistent identity.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>reserveGameServerIds</code> <span className="addon-param-type">(null or list)</span></div><div className="addon-param-desc">Enter Reserve game server Ids.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>serviceQualities</code> <span className="addon-param-type">(null or list)</span></div><div className="addon-param-desc">Configure serviceQualities.</div></div>

<details>
<summary><code>scaleStrategy</code> (1) It takes an interger for attribute `maxUnavailable`.</summary>

<div className="addon-param"><div className="addon-param-head"><code>maxUnavailable</code> <span className="addon-param-type">(null or int)</span></div><div className="addon-param-desc">The maximum number of pods that can be unavailable during scaling. Value can be an absolute number (ex: 5) or a percentage of desired pods (ex: 10%). Absolute number is calculated from percentage by rounding down. It can just be allowed to work with Parallel podManagementPolicy.</div></div>

</details>


<details>
<summary><code>updateStrategy</code> (2) Configure updateStrategy.</summary>

<div className="addon-param"><div className="addon-param-head"><code>type</code> <span className="addon-param-type">(null or string)</span></div><div className="addon-param-desc">Type indicates the type of the StatefulSetUpdateStrategy. Default is RollingUpdate.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>rollingUpdate</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">RollingUpdate is used to communicate parameters when Type is RollingUpdateStatefulSetStrategyType.</div></div>

</details>

