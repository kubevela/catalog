---
title: Parameters
sidebar_position: 2
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/node-exporter/versions.json';

<AddonVersion data={versions} current="0.3.0" page="parameters" />

<!-- Generated from the addon's parameter.cue. -->

Set them when you enable the addon, `vela addon enable node-exporter <name>=<value>`, or in VelaUX's addon form.

<div className="addon-param"><div className="addon-param-head"><code>namespace</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>o11y-system</code></span></div><div className="addon-param-desc">The namespace of the node-exporter to be installed</div></div>
<div className="addon-param"><div className="addon-param-head"><code>clusters</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">The clusters to install</div></div>
<div className="addon-param"><div className="addon-param-head"><code>image</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>quay.io/prometheus/node-exporter</code></span></div><div className="addon-param-desc">Specify the image of node-exporter</div></div>
<div className="addon-param"><div className="addon-param-head"><code>imagePullPolicy</code> <span className="addon-param-type">IfNotPresent or Never or Always</span> <span className="addon-param-default">default <code>IfNotPresent</code></span></div><div className="addon-param-desc">Specify the imagePullPolicy of the image</div></div>
<div className="addon-param"><div className="addon-param-head"><code>cpu</code> <span className="addon-param-type">number</span> <span className="addon-param-default">default <code>0.1</code></span></div><div className="addon-param-desc">Specify the number of CPU units</div></div>
<div className="addon-param"><div className="addon-param-head"><code>memory</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>250Mi</code></span></div><div className="addon-param-desc">Specifies the attributes of the memory resource required for the container.</div></div>
