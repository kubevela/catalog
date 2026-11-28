---
title: Parameters
sidebar_position: 2
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/trivy-operator/versions.json';

<AddonVersion data={versions} current="3.1.2" page="parameters" />

<!-- Generated from the addon's parameter.cue. -->

Set them when you enable the addon, `vela addon enable trivy-operator <name>=<value>`, or in VelaUX's addon form.

<div className="addon-param"><div className="addon-param-head"><code>clusters</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Deploy to specified clusters. Leave empty to deploy to all clusters.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>namespace</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>trivy-system</code></span></div><div className="addon-param-desc">Namespace to deploy to</div></div>
<div className="addon-param"><div className="addon-param-head"><code>upgradeCRD</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">Specify if upgrade the CRDs when upgrading trivy-operator or not</div></div>
