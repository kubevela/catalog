---
title: certificate
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/cert-manager/versions.json';

<AddonVersion data={versions} current="3.0.0" page="definitions/certificate" />

<!-- Generated from the definition. -->

Issues a TLS certificate for the component with cert-manager, into a Secret its gateway or ingress can serve.

**Type:** trait. **From:** the [cert-manager](/addons/catalog/cert-manager/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>dnsNames</code> <span className="addon-param-type">&#91;&#93;string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Host names the certificate covers</div></div>
<div className="addon-param"><div className="addon-param-head"><code>secretName</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">Secret the certificate and key are written to</div></div>
<div className="addon-param"><div className="addon-param-head"><code>duration</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">Lifetime to request, e.g. 2160h. The issuer may grant less</div></div>
<div className="addon-param"><div className="addon-param-head"><code>renewBefore</code> <span className="addon-param-type">string</span></div><div className="addon-param-desc">How long before expiry to renew, e.g. 360h</div></div>

<details>
<summary><code>issuerRef</code> (2) Issuer to use. Leave it out for the namespace's issuer, or else the ClusterIssuer named default</summary>

<div className="addon-param"><div className="addon-param-head"><code>name</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc"></div></div>
<div className="addon-param"><div className="addon-param-head"><code>kind</code> <span className="addon-param-type">ClusterIssuer or Issuer</span> <span className="addon-param-default">default <code>ClusterIssuer</code></span></div><div className="addon-param-desc"></div></div>

</details>

