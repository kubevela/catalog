---
title: canary-deploy
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/kruise-rollout/versions.json';

<AddonVersion data={versions} current="1.5.2" page="definitions/canary-deploy" />

<!-- Generated from the definition. -->

A canary rollout step for components multi-cluster delivery with policies.

**Type:** workflow-step. **From:** the [kruise-rollout](/addons/catalog/kruise-rollout/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>policies</code> <span className="addon-param-type">list</span></div><div className="addon-param-desc">Declare the policies that used for this deployment. If not specified, the components will be deployed to the hub cluster.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>components</code> <span className="addon-param-type">list</span></div><div className="addon-param-desc">Specify which component(s) to use for the canary rollout. If you do not specify, all components will be affected.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>weight</code> <span className="addon-param-type">int</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the percentage of replicas to update to the new version at each step, as well as the routing of traffic to the new version, e.g., 20, 40...</div></div>
<div className="addon-param"><div className="addon-param-head"><code>rolloutType</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>partition</code></span></div><div className="addon-param-desc">Specifies the rollout type. Optional values: "partition", "canary". If not specify, the rolloutType is partition.</div></div>
