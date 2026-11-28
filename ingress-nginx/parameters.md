---
title: Parameters
sidebar_position: 2
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/ingress-nginx/versions.json';

<AddonVersion data={versions} current="1.1.2" page="parameters" />

<!-- Generated from the addon's parameter.cue. -->

Set them when you enable the addon, `vela addon enable ingress-nginx <name>=<value>`, or in VelaUX's addon form.

<div className="addon-param"><div className="addon-param-head"><code>serviceType</code> <span className="addon-param-type">ClusterIP or NodePort or LoadBalancer</span> <span className="addon-param-default">default <code>ClusterIP</code></span></div><div className="addon-param-desc">Specify what kind of Service you want. options: "ClusterIP", "NodePort", "LoadBalancer"</div></div>
<div className="addon-param"><div className="addon-param-head"><code>upgradeCRD</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">Specify if upgrade the CRDs when upgrading ingress-nginx or not</div></div>
