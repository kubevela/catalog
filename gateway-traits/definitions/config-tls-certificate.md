---
title: config-tls-certificate
displayed_sidebar: addons
---

import AddonVersion from '@site/src/components/AddonVersion';
import versions from '@site/addons/catalog/gateway-traits/versions.json';

<AddonVersion data={versions} current="0.0.1" page="definitions/config-tls-certificate" />

<!-- Generated from the definition. -->

This component definition is designed to manage the TLS certificate

**Type:** component. **From:** the [gateway-traits](/addons/catalog/gateway-traits/) addon.

## Parameters

<div className="addon-param"><div className="addon-param-head"><code>cert</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">The certificate public key encrypted by base64</div></div>
<div className="addon-param"><div className="addon-param-head"><code>key</code> <span className="addon-param-type">string</span> <span className="addon-param-req">required</span></div><div className="addon-param-desc">The certificate privite key encrypted by base64</div></div>
