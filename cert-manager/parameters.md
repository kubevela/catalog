---
title: Parameters
sidebar_position: 2
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/cert-manager/versions.json';

<AddonVersion data={versions} current="2.2.0" page="parameters" />

<!-- Generated from the addon's parameter.cue. -->

Set them when you enable the addon, `vela addon enable cert-manager <name>=<value>`, or in VelaUX's addon form.

<div className="addon-param"><div className="addon-param-head"><code>installCRDs</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>true</code></span></div><div className="addon-param-desc">Specify if install the CRDs before installing cert-manager or not</div></div>
<div className="addon-param"><div className="addon-param-head"><code>upgradeCRD</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">Specify if upgrade the CRDs when upgrading cert-manager or not</div></div>
<div className="addon-param"><div className="addon-param-head"><code>clusters</code> <span className="addon-param-type">&#91;&#93;string</span></div><div className="addon-param-desc">Deploy to specified clusters. Leave empty to deploy to all clusters.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>namespace</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>cert-manager</code></span></div><div className="addon-param-desc">Namespace to deploy to</div></div>
<div className="addon-param"><div className="addon-param-head"><code>replicas</code> <span className="addon-param-type">int</span> <span className="addon-param-default">default <code>1</code></span></div><div className="addon-param-desc">Number of replicas</div></div>
<div className="addon-param"><div className="addon-param-head"><code>staging</code> <span className="addon-param-type">bool</span> <span className="addon-param-default">default <code>false</code></span></div><div className="addon-param-desc">Use Let's Encrypt staging API. Enabling this is highly recommended BEFORE you get your application working.</div></div>

<details>
<summary><code>dns01</code> (10) DNS01 Challenge config. Wildcard TLS certificates will be obtained from Let's Encrypt.</summary>

<div className="addon-param"><div className="addon-param-head"><code>namespace</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Certificate namespace. This needs to be the same namespace as your service and ingress.</div></div>

<details>
<summary><code>cloudflare</code> (4) Cloudflare-specific DNS01 config</summary>

<div className="addon-param"><div className="addon-param-head"><code>email</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">The email associated with your domain, and also your Cloudflare account.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>token</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Cloudflare API token. API token should have RW access to your domain. be sure you are generating an API token and not a global API key https://cert-manager.io/docs/configuration/acme/dns01/cloudflare/#api-tokens</div></div>
<div className="addon-param"><div className="addon-param-head"><code>zone</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Cloudflare DNS zone. Sometime it is the same as your domain.</div></div>
<div className="addon-param"><div className="addon-param-head"><code>domain</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Your domain apex, e.g. "example.com"</div></div>

</details>


<details>
<summary><code>alidns</code> (5) Alidns DNS01 config</summary>

<div className="addon-param"><div className="addon-param-head"><code>email</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">The email associated with your domain</div></div>
<div className="addon-param"><div className="addon-param-head"><code>accessToken</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Alidns API access token. API token should have RW access to your domain</div></div>
<div className="addon-param"><div className="addon-param-head"><code>secretKey</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Alidns API secret key</div></div>
<div className="addon-param"><div className="addon-param-head"><code>regionId</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Alidns DNS zone</div></div>
<div className="addon-param"><div className="addon-param-head"><code>groupName</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Your domain apex, e.g. "example.com"</div></div>

</details>


</details>

