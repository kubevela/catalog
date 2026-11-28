---
title: Parameters
sidebar_position: 2
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/postgrest/versions.json';

<AddonVersion data={versions} current="1.0.0" page="parameters" />

<!-- Generated from the addon's parameter.cue. -->

Set them when you enable the addon, `vela addon enable postgrest <name>=<value>`, or in VelaUX's addon form.

<div className="addon-param"><div className="addon-param-head"><code>namespace</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>prod</code></span></div><div className="addon-param-desc">Custom parameter description</div></div>
<div className="addon-param"><div className="addon-param-head"><code>clusters</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>PGRST_DB_URI</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>postgres://user:password@localhost:5432/postgres</code></span></div><div className="addon-param-desc">Type Postgres URL in the format:- postgres://user:password@localhost:5432/postgres.</div></div>
