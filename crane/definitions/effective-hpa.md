---
title: effective-hpa
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/crane/versions.json';

<AddonVersion data={versions} current="0.5.0" page="definitions/effective-hpa" />

<!-- Generated from the definition. -->

EffectiveHorizontalPodAutoscaler supports prediction-driven autoscaling and helps you manage application scaling in an easy way.

**Type:** trait. **From:** the [crane](/addons/catalog/crane/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>min</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>1</code></span></div><div className="addon-param-desc">Specify the minimal number of replicas to which the autoscaler can scale down</div></div>
<div className="addon-param"><div className="addon-param-head"><code>max</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>10</code></span></div><div className="addon-param-desc">Specify the maximum number of of replicas to which the autoscaler can scale up</div></div>
<div className="addon-param"><div className="addon-param-head"><code>cpuUtil</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>50</code></span></div><div className="addon-param-desc">Specify the average CPU utilization, for example, 50 means the CPU usage is 50%</div></div>
<div className="addon-param"><div className="addon-param-head"><code>enablePrediction</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>true</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>predictionWindowSeconds</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>3600</code></span></div><div className="addon-param-desc">The time window to predict metrics in the future.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>sampleInterval</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>60s</code></span></div><div className="addon-param-desc">DSP sample interval</div></div>
<div className="addon-param"><div className="addon-param-head"><code>historyLength</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>3d</code></span></div><div className="addon-param-desc">DSP history length</div></div>
