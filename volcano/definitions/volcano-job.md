---
title: volcano-job
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/volcano/versions.json';

<AddonVersion data={versions} current="1.0.0" page="definitions/volcano-job" />

<!-- Generated from the definition. -->

volcano job component

**Type:** component. **From:** the [volcano](/addons/catalog/volcano/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>schedulerName</code> <span className="addon-param-type">(null or string)</span></div><div className="addon-param-desc">SchedulerName indicates the scheduler that will schedule the job. Currently, the value can be volcano or default-scheduler, withvolcano` selected by default.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>minAvailable</code> <span className="addon-param-type">(null or int)</span></div><div className="addon-param-desc">MinAvailable represents the minimum number of running pods required to run the job. Only when the number of running pods is not less than minAvailable can the job be considered as running.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>volumes</code> <span className="addon-param-type">(null or list)</span></div><div className="addon-param-desc">Volumes indicates the configuration of the volume to which the job is mounted. It complies with the volume configuration requirements in Kubernetes.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>tasks</code> <span className="addon-param-type">(null or list)</span></div><div className="addon-param-desc">Configure tasks.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>policies</code> <span className="addon-param-type">(null or list)</span></div><div className="addon-param-desc">Policies defines the default lifecycle policy for all tasks when tasks.policies is not set.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>plugins</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Plugins indicates the plugins used by Volcano when the job is scheduled.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>queue</code> <span className="addon-param-type">(null or string)</span></div><div className="addon-param-desc">Queue indicates the queue to which the job belongs.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>priorityClassName</code> <span className="addon-param-type">(null or string)</span></div><div className="addon-param-desc">PriorityClassName indicates the priority of the job. It is used in preemptive scheduling.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>maxRetry</code> <span className="addon-param-type">(null or int)</span></div><div className="addon-param-desc">MaxRetry indicates the maximum number of retries allowed by the job.</div></div>
