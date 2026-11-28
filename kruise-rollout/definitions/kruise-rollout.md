---
title: kruise-rollout
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/kruise-rollout/versions.json';

<AddonVersion data={versions} current="1.5.2" page="definitions/kruise-rollout" />

<!-- Generated from the definition. -->

Rollout workload by kruise controller.

**Type:** trait. **From:** the [kruise-rollout](/addons/catalog/kruise-rollout/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>auto</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">If true, a streaming release will be performed, i.e., after the current step is released, subsequent steps will be released without interval</div></div>
<div className="addon-param"><div className="addon-param-head"><code>releaseMode</code> <span className="addon-param-type">canary or batch</span> <span className="addon-param-default">default <code>canary</code></span></div><div className="addon-param-desc">Defines the rolling style of Deployment, cloud be "canary" or "batch"</div></div>
<div className="addon-param"><div className="addon-param-head"><code>stepPartition</code> <span className="addon-param-type">int</span></div><div className="addon-param-desc"></div></div>

<details>
<summary><code>canary</code> (11)</summary>


<details>
<summary><code>steps[]</code> (6) Defines the entire rollout process in steps</summary>

<div className="addon-param"><div className="addon-param-head"><code>weight</code> <span className="addon-param-type">int</span></div><div className="addon-param-desc">Define the percentage of traffic routing to the new version in each step, e.g., 20%, 40%...</div></div>
<div className="addon-param"><div className="addon-param-head"><code>replicas</code> <span className="addon-param-type">(int or string)</span></div><div className="addon-param-desc">Define the replicas of release to the new version in each step, e.g., 5, 10...</div></div>
<div className="addon-param"><div className="addon-param-head"><code>duration</code> <span className="addon-param-type">int</span></div><div className="addon-param-desc">Define the behavior after release each step, if not filled, the default requires manual determination. If filled, it indicates the time to wait in seconds, e.g., 60</div></div>

<details>
<summary><code>matches[]</code> (3) Define the Header/Cookie rules for the canary traffic in current step.</summary>


<details>
<summary><code>headers[]</code> (3)</summary>

<div className="addon-param"><div className="addon-param-head"><code>Type</code> <span className="addon-param-type">Exact or RegularExpression</span> <span className="addon-param-default">default <code>Exact</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>Name</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>Value</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>

</details>


</details>


</details>


<details>
<summary><code>trafficRoutings[]</code> (5) Define traffic routing related service, ingress information</summary>

<div className="addon-param"><div className="addon-param-head"><code>service</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Holds the name of a service which selects pods with stable version and don't select any pods with canary version. Use context.name as service if not filled</div></div>
<div className="addon-param"><div className="addon-param-head"><code>gracePeriodSeconds</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>5</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>ingressName</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Refers to the ingress as traffic route. Use context.name as service if not filled</div></div>
<div className="addon-param"><div className="addon-param-head"><code>gatewayHTTPRouteName</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Refers to the name of an `HTTPRoute` of gateway API.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>type</code> <span className="addon-param-type">ingress or gateway or aliyun-alb</span> <span className="addon-param-default">default <code>ingress</code></span></div><div className="addon-param-desc">Specify the type of traffic route, can be ingress or gateway.</div></div>

</details>


</details>


<details>
<summary><code>workloadType</code> (2)</summary>

<div className="addon-param"><div className="addon-param-head"><code>apiVersion</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>kind</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>

</details>

