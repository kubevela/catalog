---
title: tcp-route
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/gateway-traits/versions.json';

<AddonVersion data={versions} current="0.0.1" page="definitions/tcp-route" />

<!-- Generated from the definition. -->

defines TCP rules for mapping requests from a Gateway to Application.

**Type:** trait. **From:** the [gateway-traits](/addons/catalog/gateway-traits/) addon.

## Parameters


<details>
<summary><code>rules[]</code> (4) Specify the TCP matchers</summary>

<div className="addon-param"><div className="addon-param-head"><code>gatewayPort</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>8060</code></span></div><div className="addon-param-desc">Specify the gateway listener port</div></div>
<div className="addon-param"><div className="addon-param-head"><code>serviceName</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Specify the service name of component, the default is component name.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>port</code> <span className="addon-param-type">int</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the service port of component.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>gatewayClassName</code> <span className="addon-param-type">traefik or istio</span> <span className="addon-param-default">default <code>traefik</code></span></div><div className="addon-param-desc">Specify the gatewayClassName.</div></div>

</details>

