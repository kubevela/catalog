---
title: http-route
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/traefik/versions.json';

<AddonVersion data={versions} current="2.6.3-3" page="definitions/http-route" />

<!-- Generated from the definition. -->

defines HTTP rules for mapping requests from a Gateway to Application.

**Type:** trait. **From:** the [traefik](/addons/catalog/traefik/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>domains</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Specify some domains, the domain may be prefixed with a wildcard label (*.)</div></div>
<div className="addon-param"><div className="addon-param-head"><code>gatewayName</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>traefik-gateway</code></span></div><div className="addon-param-desc">Specify the gateway name</div></div>
<div className="addon-param"><div className="addon-param-head"><code>listenerName</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>web</code></span></div><div className="addon-param-desc">Specify the listner name of the gateway</div></div>

<details>
<summary><code>rules[]</code> (7) Specify some HTTP matchers, filters and actions.</summary>

<div className="addon-param"><div className="addon-param-head"><code>serviceName</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Specify the service name of component, the default is component name.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>port</code> <span className="addon-param-type">int</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Specify the service port of component.</div></div>

<details>
<summary><code>path</code> (2) An HTTP request path matcher. If this field is not specified, a default prefix match on the "/" path is provided.</summary>

<div className="addon-param"><div className="addon-param-head"><code>type</code> <span className="addon-param-type">PathPrefix or Exact</span> <span className="addon-param-default">default <code>PathPrefix</code></span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>value</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>/</code></span></div><div className="addon-param-desc"></div></div>

</details>


<details>
<summary><code>headers[]</code> (3) Conditions to select a HTTP route by matching HTTP request headers.</summary>

<div className="addon-param"><div className="addon-param-head"><code>type</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>name</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>value</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>

</details>


</details>

