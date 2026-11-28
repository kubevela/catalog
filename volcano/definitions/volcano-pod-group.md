---
title: volcano-pod-group
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/volcano/versions.json';

<AddonVersion data={versions} current="1.0.0" page="definitions/volcano-pod-group" />

<!-- Generated from the definition. -->

volcano pod group component

**Type:** component. **From:** the [volcano](/addons/catalog/volcano/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>queue</code> <span className="addon-param-type">(null or string)</span></div><div className="addon-param-desc">Queue indicates the queue to which the PodGroup belongs. The queue must be in the Open state.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>priorityClassName</code> <span className="addon-param-type">(null or string)</span></div><div className="addon-param-desc">PriorityClassName represents the priority of the PodGroup and is used by the scheduler to sort all the PodGroups in the queue during scheduling. Note that system-node-critical and system-cluster-critical are reserved values, which mean the highest priority. If priorityClassName is not specified, the default priority is used.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>minResources</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">MinResources indicates the minimum resources for running the PodGroup. If available resources in the cluster cannot satisfy the requirement, no pod or task in the PodGroup will be scheduled.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>minMember</code> <span className="addon-param-type">(null or int)</span></div><div className="addon-param-desc">MinMember indicates the minimum number of pods or tasks running under the PodGroup. If the cluster resource cannot meet the demand of running the minimum number of pods or tasks, no pod or task in the PodGroup will be scheduled.</div></div>
