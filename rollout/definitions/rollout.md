---
title: rollout
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/rollout/versions.json';

<AddonVersion data={versions} current="1.3.3" page="definitions/rollout" />

<!-- Generated from the definition. -->

Rollout the component.

**Type:** trait. **From:** the [rollout](/addons/catalog/rollout/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>targetRevision</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Specify the target revision, it should be set if you want to rollback. such as: componentname-v1</div></div>
<div className="addon-param"><div className="addon-param-head"><code>targetSize</code> <span className="addon-param-type">int</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the count of replicas.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>batchPartition</code> <span className="addon-param-type">int</span></div><div className="addon-param-desc">Specify the batch partition in current deploying. It is used to control batch processes.</div></div>

<details>
<summary><code>rolloutBatches[]</code> (1) Specify the rollout batches, The total number of replicas of all batches needs to be equal to number of targetSize.</summary>

<div className="addon-param"><div className="addon-param-head"><code>replicas</code> <span className="addon-param-type">int</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>

</details>

