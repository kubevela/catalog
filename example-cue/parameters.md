---
title: Parameters
sidebar_position: 2
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/example-cue/versions.json';

<AddonVersion data={versions} current="1.1.0" page="parameters" />

<!-- Generated from the addon's parameter.cue. -->

Set them when you enable the addon, `vela addon enable example-cue <name>=<value>`, or in VelaUX's addon form.

<div className="addon-param"><div className="addon-param-head"><code>registry</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Base URL for images that the FluxCD controllers use, e.g. ghcr.io</div></div>
