---
title: volcano-queue
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/volcano/versions.json';

<AddonVersion data={versions} current="1.0.0" page="definitions/volcano-queue" />

<!-- Generated from the definition. -->

volcano queue component

**Type:** component. **From:** the [volcano](/addons/catalog/volcano/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>weight</code> <span className="addon-param-type">(null or int)</span></div><div className="addon-param-desc">Weight indicates the relative weight of a queue in cluster resource division. The resource allocated to the queue equals (weight/total-weight) x total-resource. total-weight is the total weight of all queues. total-resource is the total number of cluster resources. weight is a soft constraint.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>reclaimable</code> <span className="addon-param-type">(null or bool)</span></div><div className="addon-param-desc">Reclaimable specifies whether to allow other queues to reclaim extra resources occupied by a queue when the queue uses more resources than allocated.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>capability</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Capability indicates the upper limit of resources the queue can use. It is a hard constraint.</div></div>
