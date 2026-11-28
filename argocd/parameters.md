---
title: Parameters
sidebar_position: 2
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/argocd/versions.json';

<AddonVersion data={versions} current="0.1.0" page="parameters" />

<!-- Generated from the addon's parameter.cue. -->

Set them when you enable the addon, `vela addon enable argocd <name>=<value>`, or in VelaUX's addon form.

<div className="addon-param"><div className="addon-param-head"><code>clusters</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">The clusters to install</div></div>
