---
title: Parameters
sidebar_position: 2
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/bytebase/versions.json';

<AddonVersion data={versions} current="1.0.0" page="parameters" />

<!-- Generated from the addon's parameter.cue. -->

Set them when you enable the addon, `vela addon enable bytebase <name>=<value>`, or in VelaUX's addon form.

<div className="addon-param"><div className="addon-param-head"><code>namespace</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>bytebase</code></span></div><div className="addon-param-desc">Custom parameter description.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>clusters</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>bytebasePort</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>8080</code></span></div><div className="addon-param-desc">Set bytebasePort to run bytebase on that port in Pod.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>externalURL</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>https://bytebase.example.com</code></span></div><div className="addon-param-desc">To configure external URL visit: https://www.bytebase.com/docs/get-started/install/external-url.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>version</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>1.16.0</code></span></div><div className="addon-param-desc">Version of bytebase.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>postgresURL</code> <span className="addon-param-type">(null or string)</span></div><div className="addon-param-desc">To configure postgres URL visit: https://www.bytebase.com/docs/get-started/install/external-postgres.</div></div>
