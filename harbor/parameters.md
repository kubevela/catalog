---
title: Parameters
sidebar_position: 2
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/harbor/versions.json';

<AddonVersion data={versions} current="0.0.2" page="parameters" />

<!-- Generated from the addon's parameter.cue. -->

Set them when you enable the addon, `vela addon enable harbor <name>=<value>`, or in VelaUX's addon form.

<div className="addon-param"><div className="addon-param-head"><code>serviceType</code> <span className="addon-param-type">ingress or clusterIP or loadBalancer or nodePort</span> <span className="addon-param-default">default <code>ingress</code></span></div><div className="addon-param-desc">Service type</div></div>
<div className="addon-param"><div className="addon-param-head"><code>externalURL</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the URL for harbor</div></div>
<div className="addon-param"><div className="addon-param-head"><code>clusters</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">The clusters to install</div></div>
