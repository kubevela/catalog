---
title: issuer
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/cert-manager/versions.json';

<AddonVersion data={versions} current="3.0.0" page="definitions/issuer" />

<!-- Generated from the definition. -->

A cert-manager issuer: an ACME account (Let's Encrypt by default), a self-signed issuer, or a CA signing with a key pair from a Secret.

**Type:** component. **From:** the [cert-manager](/addons/catalog/cert-manager/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>scope</code> <span className="addon-param-type">cluster or namespace</span> <span className="addon-param-default">default <code>cluster</code></span></div><div className="addon-param-desc">Cluster makes a ClusterIssuer any namespace can use; namespace makes an Issuer in the Application's namespace</div></div>
<div className="addon-param"><div className="addon-param-head"><code>selfSigned</code> <span className="addon-param-type">object</span></div><div className="addon-param-desc">Sign certificates with their own key</div></div>

<details>
<summary><code>acme</code> (15) Issue from an ACME server, such as Let's Encrypt</summary>

<div className="addon-param"><div className="addon-param-head"><code>server</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>production</code></span></div><div className="addon-param-desc">Production or staging for Let's Encrypt, or the directory URL of another ACME server</div></div>
<div className="addon-param"><div className="addon-param-head"><code>email</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Email for the ACME account, which the server uses for expiry notices</div></div>
<div className="addon-param"><div className="addon-param-head"><code>privateKeySecretName</code> <span className="addon-param-type">string</span> <span className="addon-param-default">default <code>&lt;name&gt;-account-key</code></span></div><div className="addon-param-desc">Secret the ACME account's private key is stored in.</div></div>

<details>
<summary><code>http01</code> (3) Solve HTTP-01 challenges through an ingress class or a Gateway</summary>

<div className="addon-param"><div className="addon-param-head"><code>ingressClassName</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Ingress class that routes the challenge</div></div>

<details>
<summary><code>gateway</code> (2) Gateway that routes the challenge</summary>

<div className="addon-param"><div className="addon-param-head"><code>name</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>namespace</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>

</details>


</details>


<details>
<summary><code>dns01</code> (9) Solve DNS-01 challenges, needed for wildcard certificates. Credentials are read from Secrets you create</summary>


<details>
<summary><code>cloudflare</code> (2)</summary>


<details>
<summary><code>apiTokenSecretRef</code> (2) Cloudflare, with an API token that can edit the zone</summary>

<div className="addon-param"><div className="addon-param-head"><code>name</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Name of the Secret. For a ClusterIssuer it is read from cert-manager's namespace</div></div>
<div className="addon-param"><div className="addon-param-head"><code>key</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Key in the Secret</div></div>

</details>


</details>


<details>
<summary><code>route53</code> (7) Route53. Set both key refs, or leave them out to use the pod's ambient credentials (IRSA, Pod Identity)</summary>

<div className="addon-param"><div className="addon-param-head"><code>region</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>hostedZoneID</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>role</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc"></div></div>

<details>
<summary><code>accessKeyIDSecretRef</code> (2)</summary>

<div className="addon-param"><div className="addon-param-head"><code>name</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Name of the Secret. For a ClusterIssuer it is read from cert-manager's namespace</div></div>
<div className="addon-param"><div className="addon-param-head"><code>key</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Key in the Secret</div></div>

</details>


<details>
<summary><code>secretAccessKeySecretRef</code> (2)</summary>

<div className="addon-param"><div className="addon-param-head"><code>name</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Name of the Secret. For a ClusterIssuer it is read from cert-manager's namespace</div></div>
<div className="addon-param"><div className="addon-param-head"><code>key</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Key in the Secret</div></div>

</details>


</details>


</details>


</details>


<details>
<summary><code>ca</code> (1) Sign certificates with a CA key pair</summary>

<div className="addon-param"><div className="addon-param-head"><code>secretName</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Secret holding the CA's tls.crt and tls.key</div></div>

</details>

