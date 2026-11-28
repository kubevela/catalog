---
title: config-tls-certificate
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/traefik/versions.json';

<AddonVersion data={versions} current="2.6.3" page="definitions/config-tls-certificate" />

<!-- Generated from the definition. -->

This component definition is designed to manage the TLS certificate

**Type:** component. **From:** the [traefik](/addons/catalog/traefik/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>cert</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">The certificate public key encrypted by base64</div></div>
<div className="addon-param"><div className="addon-param-head"><code>key</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">The certificate privite key encrypted by base64</div></div>
