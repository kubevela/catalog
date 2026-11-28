---
title: koordinator-reservation
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/koordinator/versions.json';

<AddonVersion data={versions} current="1.1.1" page="definitions/reservation" />

<!-- Generated from the definition. -->

koordinator reservation component

**Type:** component. **From:** the [koordinator](/addons/catalog/koordinator/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>template</code> <span className="addon-param-type">(null or struct)</span></div><div className="addon-param-desc">Template defines the scheduling requirements (resources, affinities, images, ...) processed by the scheduler just like a normal pod. If the template.spec.nodeName is specified, the scheduler will not choose another node but reserve resources on the specified node.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>owners</code> <span className="addon-param-type">(null or list)</span></div><div className="addon-param-desc">Specify the owners who can allocate the reserved resources. Multiple owner selectors and ORed.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>ttl</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>24h</code></span></div><div className="addon-param-desc">Time-to-Live period for the reservation. expires and ttl are mutually exclusive. Defaults to 24h. Set 0 to disable expiration.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>expires</code> <span className="addon-param-type">(null or string)</span> <span className="addon-param-default">default <code>being set dynamically at runtime based on the `ttl`</code></span></div><div className="addon-param-desc">Expired timestamp when the reservation is expected to expire. If both `expires` and `ttl` are set, `expires` is checked first. expires and ttl are mutually exclusive.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>preAllocation</code> <span className="addon-param-type">(null or bool)</span></div><div className="addon-param-desc">By default, the resources requirements of reservation (specified in `template.spec`) is filtered by whether the node has sufficient free resources (i.e. Reservation Request &lt;  Node Free). When `preAllocation` is set, the scheduler will skip this validation and allow overcommitment. The scheduled reservation would be waiting to be available until free resources are sufficient.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>allocateOnce</code> <span className="addon-param-type">(null or bool)</span></div><div className="addon-param-desc">By default, reserved resources are always allocatable as long as the reservation phase is Available. When `AllocateOnce` is set, the reserved resources are only available for the first owner who allocates successfully and are not allocatable to other owners anymore.</div></div>
