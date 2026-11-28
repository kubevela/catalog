---
title: Parameters
sidebar_position: 2
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/keda/versions.json';

<AddonVersion data={versions} current="2.8.3" page="parameters" />

<!-- Generated from the addon's parameter.cue. -->

Set them when you enable the addon, `vela addon enable keda <name>=<value>`, or in VelaUX's addon form.

<div className="addon-param"><div className="addon-param-head"><code>clusters</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">The clusters to install</div></div>
<div className="addon-param"><div className="addon-param-head"><code>upgradeCRD</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">Specify if upgrade the CRDs when upgrading keda or not</div></div>
