---
title: keda-auto-scaler
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/keda/versions.json';

<AddonVersion data={versions} current="2.8.3" page="definitions/keda-scaler" />

<!-- Generated from the definition. -->

Configure auto scale rule for your workload.

**Type:** trait. **From:** the [keda](/addons/catalog/keda/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>pollingInterval</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>30</code></span></div><div className="addon-param-desc">Specify the polling interval of metrics</div></div>
<div className="addon-param"><div className="addon-param-head"><code>cooldownPeriod</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>60</code></span></div><div className="addon-param-desc">Specify the cool down period that prevents the scaler from scaling down after each trigger activation.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>idleReplicaCount</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>0</code></span></div><div className="addon-param-desc">Specify the idle period that the scaler to scale to zero.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>minReplicaCount</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>1</code></span></div><div className="addon-param-desc">Specify the minimal replica count.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>maxReplicaCount</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>100</code></span></div><div className="addon-param-desc">Specify the maximal replica count.</div></div>

<details>
<summary><code>triggers[]</code> (2)</summary>

<div className="addon-param"><div className="addon-param-head"><code>type</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"> specify the type of trigger, the rest spec here aligns with KEDA spec</div></div>
<div className="addon-param"><div className="addon-param-head"><code>metadata</code> <span className="addon-param-type">map&#91;string&#93;any</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"> specify the metadata of trigger, the spec aligns with the spec of KEDA https://keda.sh/docs/2.8/scalers/</div></div>

</details>


<details>
<summary><code>scaleTargetRef</code> (4)</summary>

<div className="addon-param"><div className="addon-param-head"><code>apiVersion</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>apps/v1</code></span></div><div className="addon-param-desc">Specify apiVersion for target workload</div></div>
<div className="addon-param"><div className="addon-param-head"><code>kind</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>Deployment</code></span></div><div className="addon-param-desc">Specify kind for target workload</div></div>
<div className="addon-param"><div className="addon-param-head"><code>envSourceContainerName</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>find this path ".spec.template.spec.containers[0]"</code></span></div><div className="addon-param-desc">Specify containerName</div></div>
<div className="addon-param"><div className="addon-param-head"><code>name</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>context.name</code></span></div><div className="addon-param-desc">Specify the instance name for target workload</div></div>

</details>


<details>
<summary><code>fallback</code> (2) Specify the fallback value when the metrics server is not available.</summary>

<div className="addon-param"><div className="addon-param-head"><code>failureThreshold</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>3</code></span></div><div className="addon-param-desc">Specify the failure threshold of the scaler.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>replicas</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>1</code></span></div><div className="addon-param-desc">Specify the replica when failed to get metrics.</div></div>

</details>

