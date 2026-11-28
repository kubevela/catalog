---
title: Parameters
sidebar_position: 2
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/backstage/versions.json';

<AddonVersion data={versions} current="1.1.1" page="parameters" />

<!-- Generated from the addon's parameter.cue. -->

Set them when you enable the addon, `vela addon enable backstage <name>=<value>`, or in VelaUX's addon form.

<div className="addon-param"><div className="addon-param-head"><code>serviceType</code> <span className="addon-param-type">ClusterIP or NodePort or LoadBalancer</span> <span className="addon-param-default">default <code>ClusterIP</code></span></div><div className="addon-param-desc">Service type</div></div>
<div className="addon-param"><div className="addon-param-head"><code>name</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>clusters</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">The clusters to install</div></div>
<div className="addon-param"><div className="addon-param-head"><code>image</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>wonderflow/backstage:v0.3</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>pluginOnly</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>cpu</code> <span className="addon-param-type">number</span> <span className="addon-param-default">default <code>0.1</code></span></div><div className="addon-param-desc">Specify the number of CPU units</div></div>
<div className="addon-param"><div className="addon-param-head"><code>memory</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>200Mi</code></span></div><div className="addon-param-desc">Specifies the attributes of the memory resource required for the container.</div></div>

<details>
<summary><code>backstageapp</code> (2)</summary>

<div className="addon-param"><div className="addon-param-head"><code>cpu</code> <span className="addon-param-type">number</span> <span className="addon-param-default">default <code>0.5</code></span></div><div className="addon-param-desc">Specify the number of CPU units for backstage app</div></div>
<div className="addon-param"><div className="addon-param-head"><code>memory</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>500Mi</code></span></div><div className="addon-param-desc">Specifies the attributes of the memory resource required for backstage app</div></div>

</details>

