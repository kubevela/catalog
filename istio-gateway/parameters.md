---
title: Parameters
sidebar_position: 2
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/istio-gateway/versions.json';

<AddonVersion data={versions} current="1.0.0" page="parameters" />

<!-- Generated from the addon's parameter.cue. -->

Set them when you enable the addon, `vela addon enable istio-gateway <name>=<value>`, or in VelaUX's addon form.

<div className="addon-param"><div className="addon-param-head"><code>gatewayNamespace</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>vela-system</code></span></div><div className="addon-param-desc">Specify the gateway namespace</div></div>
<div className="addon-param"><div className="addon-param-head"><code>gatewayType</code> <span className="addon-param-type">ClusterIP or NodePort or LoadBalancer</span> <span className="addon-param-default">default <code>ClusterIP</code></span></div><div className="addon-param-desc">Specify the gateway service type</div></div>

<details>
<summary><code>entryPoints[]</code> (3) Specify the istio entry points, only configured ports can be used for listenner.</summary>

<div className="addon-param"><div className="addon-param-head"><code>name</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>port</code> <span className="addon-param-type">int</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>protocol</code> <span className="addon-param-type">TCP or UDP</span> <span className="addon-param-default">default <code>TCP</code></span></div><div className="addon-param-desc"></div></div>

</details>


<details>
<summary><code>gatewayListeners[]</code> (4) Specify the gateway listeners</summary>

<div className="addon-param"><div className="addon-param-head"><code>name</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>web</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>hostname</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>port</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>8050</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>routeNamespace</code> <span className="addon-param-type">All or Same</span> <span className="addon-param-default">default <code>All</code></span></div><div className="addon-param-desc"></div></div>

</details>

