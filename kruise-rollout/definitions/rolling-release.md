---
title: rolling-release
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/kruise-rollout/versions.json';

<AddonVersion data={versions} current="1.5.2" page="definitions/rolling-release" />

<!-- Generated from the definition. -->

Rolling workload with specified weight via kruise rollout. It's advisable not to use this trait directly. Instead, if you use the canary-deploy step, this trait will be added implicitly

**Type:** trait. **From:** the [kruise-rollout](/addons/catalog/kruise-rollout/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>weight</code> <span className="addon-param-type">int</span></div><div className="addon-param-desc">Define the percentage of traffic routing to the new version in each step, e.g., 20, 40...</div></div>
<div className="addon-param"><div className="addon-param-head"><code>replicas</code> <span className="addon-param-type">(int or string)</span></div><div className="addon-param-desc">Define the replicas of release to the new version in each step, e.g., 5, 10...</div></div>
<div className="addon-param"><div className="addon-param-head"><code>final</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">Declare whether the rolling reach end</div></div>
<div className="addon-param"><div className="addon-param-head"><code>rolloutType</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>partition</code></span></div><div className="addon-param-desc">Specifies the rollout type. Optional values: "partition", "canary". If not specify, the rolloutType is partition.</div></div>

<details>
<summary><code>workloadType</code> (2) Define the workload for rolling. If not specified, it will be auto detected.</summary>

<div className="addon-param"><div className="addon-param-head"><code>apiVersion</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>kind</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>

</details>

