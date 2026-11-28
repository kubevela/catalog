---
title: koordinator-colocation-profile
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/koordinator/versions.json';

<AddonVersion data={versions} current="1.1.1" page="definitions/colocation-profile" />

<!-- Generated from the definition. -->

koordinator colocation profile component

**Type:** component. **From:** the [koordinator](/addons/catalog/koordinator/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>namespaceSelector</code> <span className="addon-param-type">object</span> <span className="addon-param-default">default <code>&#123;&#125;</code></span></div><div className="addon-param-desc">Decides whether to mutate/validate Pods if the namespace matches the selector.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>selector</code> <span className="addon-param-type">object</span> <span className="addon-param-default">default <code>&#123;&#125;</code></span></div><div className="addon-param-desc">Decides whether to mutate/validate Pods if the Pod matches the selector.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>qosClass</code> <span className="addon-param-type">(null or string)</span></div><div className="addon-param-desc">Describes the type of Koordinator QoS that the Pod is running. The value will be injected into Pod as label koordinator.sh/qosClass. Options are LSE, LSR, LS, BE, and SYSTEM.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>priorityClassName</code> <span className="addon-param-type">(null or string)</span></div><div className="addon-param-desc">The priorityClassName and the priority value defined in PriorityClass will be injected into the Pod. Options are koord-prod, koord-mid, koord-batch, and koord-free.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>koordinatorPriority</code> <span className="addon-param-type">(null or int)</span></div><div className="addon-param-desc">Defines the Pod sub-priority in Koordinator. The priority value will be injected into Pod as label koordinator.sh/priority. Various Koordinator components determine the priority of the Pod in the Koordinator through KoordinatorPriority and the priority value in PriorityClassName. Higher the value, higher the priority.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>labels</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Describes the k/v pair that needs to inject into Pod.Labels.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>annotations</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Describes the k/v pair that needs to inject into Pod.Annotations.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>schedulerName</code> <span className="addon-param-type">(null or string)</span></div><div className="addon-param-desc">If specified, the pod will be dispatched by specified scheduler.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>patch</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Indicates Pod Template patching that user would like to inject into the Pod.</div></div>
