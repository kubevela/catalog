---
title: Parameters
sidebar_position: 2
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/clickhouse/versions.json';

<AddonVersion data={versions} current="1.0.1" page="parameters" />

<!-- Generated from the addon's parameter.cue. -->

Set them when you enable the addon, `vela addon enable clickhouse <name>=<value>`, or in VelaUX's addon form.

<div className="addon-param"><div className="addon-param-head"><code>serviceType</code> <span className="addon-param-type">ClusterIP or NodePort or LoadBalancer</span> <span className="addon-param-default">default <code>ClusterIP</code></span></div><div className="addon-param-desc">Service type</div></div>
<div className="addon-param"><div className="addon-param-head"><code>name</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>clusters</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">The clusters to install</div></div>
<div className="addon-param"><div className="addon-param-head"><code>grafanaDashbord</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">Enable grafana dashboard for clickhouse operator, this requires prism and garafna addon enabled.</div></div>
