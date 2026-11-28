---
title: cronhpa
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/cronhpa/versions.json';

<AddonVersion data={versions} current="1.4.1" page="definitions/cronhpa" />

<!-- Generated from the definition. -->

kubernetes cron horizontal pod autoscaler trait

**Type:** trait. **From:** the [cronhpa](/addons/catalog/cronhpa/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>targetAPIVersion</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>apps/v1</code></span></div><div className="addon-param-desc">Specify the apiVersion of scale target</div></div>
<div className="addon-param"><div className="addon-param-head"><code>targetKind</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>Deployment</code></span></div><div className="addon-param-desc">Specify the kind of scale target</div></div>
<div className="addon-param"><div className="addon-param-head"><code>excludeDates</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Specify the job will skip the execution when the dates is matched. The minimum unit is day.</div></div>

<details>
<summary><code>hpaJobs[]</code> (4) Specify multiple cron hpa jobs</summary>

<div className="addon-param"><div className="addon-param-head"><code>name</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the name of hpa job, should be unique in one cronhpa spec</div></div>
<div className="addon-param"><div className="addon-param-head"><code>schedule</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the cron schedule strategy</div></div>
<div className="addon-param"><div className="addon-param-head"><code>targetSize</code> <span className="addon-param-type">int</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the size you desired to scale when the scheduled time arrive</div></div>
<div className="addon-param"><div className="addon-param-head"><code>runOnce</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">Specify if this job need executed repeatly, if runOnce is true then the job will only run and exit after the first execution.</div></div>

</details>

