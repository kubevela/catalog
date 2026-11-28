---
title: Parameters
sidebar_position: 2
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/defkit/versions.json';

<AddonVersion data={versions} current="0.1.0" page="parameters" />

<!-- Generated from the addon's parameter.cue. -->

Set them when you enable the addon, `vela addon enable defkit <name>=<value>`, or in VelaUX's addon form.

<div className="addon-param"><div className="addon-param-head"><code>image</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>oamdev/defkit-render:v0.1.0</code></span></div><div className="addon-param-desc">Image of the render Job: Go plus defkit-render</div></div>
<div className="addon-param"><div className="addon-param-head"><code>repositories</code> <span className="addon-param-type">list</span></div><div className="addon-param-desc">Repositories VelaUX offers when adding a module; a module can still come from anywhere</div></div>
