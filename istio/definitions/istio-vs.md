---
title: istio-vs
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/istio/versions.json';

<AddonVersion data={versions} current="1.0.2" page="definitions/istio-vs" />

<!-- Generated from the definition. -->

Handle Traffic Via Istio VirtualService.

**Type:** trait. **From:** the [istio](/addons/catalog/istio/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>annotations</code> <span className="addon-param-type">map&#91;string&#93;string</span></div><div className="addon-param-desc">Annotations variable name</div></div>
<div className="addon-param"><div className="addon-param-head"><code>hosts</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">The destination hosts to which traffic is being sent</div></div>
<div className="addon-param"><div className="addon-param-head"><code>gateways</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">The names of gateways and sidecars that should apply these routes</div></div>
<div className="addon-param"><div className="addon-param-head"><code>exportTo</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">A list of namespaces to which this virtual service is exported</div></div>

<details>
<summary><code>http[]</code> (22) An ordered list of route rules for HTTP traffic</summary>

<div className="addon-param"><div className="addon-param-head"><code>name</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">The name assigned to the route for debugging purposes</div></div>

<details>
<summary><code>match[]</code> (5) Match conditions to be satisfied for the rule to be activated</summary>

<div className="addon-param"><div className="addon-param-head"><code>uri</code> <span className="addon-param-type">object</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">URI to match values are case-sensitive Ref(https://github.com/google/re2/wiki/Syntax).:</div></div>
<div className="addon-param"><div className="addon-param-head"><code>authority</code> <span className="addon-param-type">object</span></div><div className="addon-param-desc">HTTP Authority to match values are case-sensitive Ref(https://github.com/google/re2/wiki/Syntax).:</div></div>
<div className="addon-param"><div className="addon-param-head"><code>scheme</code> <span className="addon-param-type">object</span></div><div className="addon-param-desc">URI Scheme to match values are case-sensitive Ref(https://github.com/google/re2/wiki/Syntax).:</div></div>
<div className="addon-param"><div className="addon-param-head"><code>method</code> <span className="addon-param-type">object</span></div><div className="addon-param-desc">HTTP Method to match values are case-sensitive Ref(https://github.com/google/re2/wiki/Syntax).:</div></div>
<div className="addon-param"><div className="addon-param-head"><code>headers</code> <span className="addon-param-type">map&#91;string&#93;object</span></div><div className="addon-param-desc">The header keys must be lowercase and use hyphen as the separator, e.g. x-request-id.</div></div>

</details>


<details>
<summary><code>route[]</code> (4) A HTTP rule can either redirect or forward (default) traffic</summary>

<div className="addon-param"><div className="addon-param-head"><code>weight</code> <span className="addon-param-type">int</span></div><div className="addon-param-desc">Weight specifies the relative proportion of traffic to be forwarded to the destination</div></div>

<details>
<summary><code>destination</code> (3) Destination uniquely identifies the instances of a service to which the request/connection should be forwarded to.</summary>

<div className="addon-param"><div className="addon-param-head"><code>host</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">The name of a service from the service registry</div></div>
<div className="addon-param"><div className="addon-param-head"><code>subset</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">The name of a subset within the service</div></div>

<details>
<summary><code>port</code> (1) Specifies the port on the host that is being addressed</summary>

<div className="addon-param"><div className="addon-param-head"><code>number</code> <span className="addon-param-type">int</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Valid port number</div></div>

</details>


</details>


</details>


<details>
<summary><code>rewrite</code> (2) Rewrite HTTP URIs and Authority headers</summary>

<div className="addon-param"><div className="addon-param-head"><code>uri</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Rewrite the path (or the prefix) portion of the URI with this value</div></div>
<div className="addon-param"><div className="addon-param-head"><code>authority</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Rewrite the Authority/Host header with this value.</div></div>

</details>


<details>
<summary><code>corsPolicy</code> (4) Cross-Origin Resource Sharing policy (CORS)</summary>

<div className="addon-param"><div className="addon-param-head"><code>allowOrigins</code> <span className="addon-param-type">&#91;&#93;object</span></div><div className="addon-param-desc">String patterns that match allowed origins.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>allowMethods</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">List of HTTP methods allowed to access the resource</div></div>
<div className="addon-param"><div className="addon-param-head"><code>allowHeaders</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">List of HTTP headers that can be used when requesting the resource</div></div>
<div className="addon-param"><div className="addon-param-head"><code>allowCredentials</code> <span className="addon-param-type">bool</span></div><div className="addon-param-desc">Indicates whether the caller is allowed to send the actual request (not the preflight) using credentials</div></div>

</details>


<details>
<summary><code>headers</code> (6) Header manipulation rules</summary>


<details>
<summary><code>request</code> (3) Header manipulation rules to apply before forwarding a request to the destination service</summary>

<div className="addon-param"><div className="addon-param-head"><code>set</code> <span className="addon-param-type">map&#91;string&#93;string</span></div><div className="addon-param-desc">Overwrite the headers specified by key with the given values</div></div>
<div className="addon-param"><div className="addon-param-head"><code>add</code> <span className="addon-param-type">map&#91;string&#93;string</span></div><div className="addon-param-desc">Append the given values to the headers specified by keys (will create a comma-separated list of values)</div></div>
<div className="addon-param"><div className="addon-param-head"><code>remove</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Remove the specified headers</div></div>

</details>


<details>
<summary><code>response</code> (3) Header manipulation rules to apply before returning a response to the caller</summary>

<div className="addon-param"><div className="addon-param-head"><code>set</code> <span className="addon-param-type">map&#91;string&#93;string</span></div><div className="addon-param-desc">Overwrite the headers specified by key with the given values</div></div>
<div className="addon-param"><div className="addon-param-head"><code>add</code> <span className="addon-param-type">map&#91;string&#93;string</span></div><div className="addon-param-desc">Append the given values to the headers specified by keys (will create a comma-separated list of values)</div></div>
<div className="addon-param"><div className="addon-param-head"><code>remove</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Remove the specified headers</div></div>

</details>


</details>


</details>


<details>
<summary><code>tcp[]</code> (9) An ordered list of route rules for opaque TCP traffic</summary>


<details>
<summary><code>match[]</code> (5) Match conditions to be satisfied for the rule to be activated</summary>

<div className="addon-param"><div className="addon-param-head"><code>destinationSubnets</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">IPv4 or IPv6 ip addresses of destination with optional subnet</div></div>
<div className="addon-param"><div className="addon-param-head"><code>port</code> <span className="addon-param-type">int</span></div><div className="addon-param-desc">Specifies the port on the host that is being addressed.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>sourceLabels</code> <span className="addon-param-type">map&#91;string&#93;string</span></div><div className="addon-param-desc">One or more labels that constrain the applicability of a rule to workloads with the given labels</div></div>
<div className="addon-param"><div className="addon-param-head"><code>gateways</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Names of gateways where the rule should be applied.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>sourceNamespace</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Source namespace constraining the applicability of a rule to workloads in that namespace</div></div>

</details>


<details>
<summary><code>route[]</code> (4) The destination to which the connection should be forwarded to</summary>

<div className="addon-param"><div className="addon-param-head"><code>weight</code> <span className="addon-param-type">int</span></div><div className="addon-param-desc">Weight specifies the relative proportion of traffic to be forwarded to the destination</div></div>

<details>
<summary><code>destination</code> (3) Destination uniquely identifies the instances of a service to which the request/connection should be forwarded to.</summary>

<div className="addon-param"><div className="addon-param-head"><code>host</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">The name of a service from the service registry</div></div>
<div className="addon-param"><div className="addon-param-head"><code>subset</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">The name of a subset within the service</div></div>

<details>
<summary><code>port</code> (1) Specifies the port on the host that is being addressed</summary>

<div className="addon-param"><div className="addon-param-head"><code>number</code> <span className="addon-param-type">int</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Valid port number</div></div>

</details>


</details>


</details>


</details>

